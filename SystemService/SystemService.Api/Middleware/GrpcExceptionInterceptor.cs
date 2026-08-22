using Grpc.Core;
using Grpc.Core.Interceptors;
using System.Text.Json;
using SystemService.Application.Exceptions;

namespace SystemService.Api.Middleware;

public class GrpcExceptionInterceptor : Interceptor
{
    private readonly ILogger<GrpcExceptionInterceptor> _logger;
    private readonly IWebHostEnvironment _env;

    public GrpcExceptionInterceptor(ILogger<GrpcExceptionInterceptor> logger, IWebHostEnvironment env)
    {
        _logger = logger;
        _env = env;
    }

    public override async Task<TResponse> UnaryServerHandler<TRequest, TResponse>(
        TRequest request,
        ServerCallContext context,
        UnaryServerMethod<TRequest, TResponse> continuation)
    {
        try
        {
            return await continuation(request, context);
        }
        catch (Exception ex)
        {
            throw HandleException(ex);
        }
    }

    private RpcException HandleException(Exception exception)
    {
        if (exception is RpcException rpcEx)
        {
            return rpcEx;
        }

        StatusCode statusCode;
        string message;
        var metadata = new Metadata();

        switch (exception)
        {
            case InvalidDataException invalidDataException:
                statusCode = StatusCode.InvalidArgument;
                message = "Dung lượng file vượt quá giới hạn cho phép (tối đa 50 MB).";
                _logger.LogWarning("gRPC Multipart body length limit exceeded: {Message}", invalidDataException.Message);
                break;

            case FluentValidation.ValidationException validationException:
                statusCode = StatusCode.InvalidArgument;
                message = "Dữ liệu yêu cầu không hợp lệ.";

                var validationErrors = validationException.Errors
                    .GroupBy(e => e.PropertyName.Split('.').Last())
                    .ToDictionary(
                        g => JsonNamingPolicy.CamelCase.ConvertName(g.Key),
                        g => g.Select(e => e.ErrorMessage).ToArray()
                    );

                metadata.Add("validation-errors-bin", JsonSerializer.SerializeToUtf8Bytes(validationErrors));
                _logger.LogWarning("gRPC Validation error: {ValidationErrors}", JsonSerializer.Serialize(validationErrors));
                break;

            case BadRequestException badRequestException:
            case ApplicationException _:
                statusCode = StatusCode.InvalidArgument;
                message = exception.Message;
                _logger.LogWarning("gRPC Bad request: {Message}", exception.Message);
                break;

            case NotFoundException notFoundException:
                statusCode = StatusCode.NotFound;
                message = exception.Message;
                _logger.LogWarning("gRPC Resource not found: {Message}", exception.Message);
                break;

            case UnauthorizedException unauthorizedException:
                statusCode = StatusCode.Unauthenticated;
                message = unauthorizedException.Message;
                _logger.LogWarning("gRPC Unauthorized access: {Message}", unauthorizedException.Message);
                break;

            default:
                statusCode = StatusCode.Internal;
                message = _env.IsDevelopment() ? exception.ToString() : "An unexpected error occurred. Please contact support.";
                _logger.LogError(exception, "An unhandled exception has occurred in gRPC Pipeline.");
                break;
        }

        return new RpcException(new Status(statusCode, message), metadata);
    }
}
