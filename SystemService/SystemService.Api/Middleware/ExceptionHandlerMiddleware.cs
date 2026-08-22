using FluentValidation;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using System.Net;
using System.Text.Json;
using SystemService.Application.Models.Common;

namespace SystemService.Api.Middleware;

public class ExceptionHandlerMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionHandlerMiddleware> _logger;
    private readonly JsonSerializerOptions _jsonOptions;
    private readonly IWebHostEnvironment _env;

    public ExceptionHandlerMiddleware(
        RequestDelegate next,
        ILogger<ExceptionHandlerMiddleware> logger,
        IOptions<JsonOptions> jsonOptions,
        IWebHostEnvironment env
        )
    {
        _next = next;
        _logger = logger;
        _jsonOptions = jsonOptions.Value.JsonSerializerOptions;
        _env = env;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            await HandleExceptionAsync(context, ex, _env);
        }
    }

    private async Task HandleExceptionAsync(HttpContext context, Exception exception, IWebHostEnvironment env)
    {
        var statusCode = HttpStatusCode.InternalServerError;
        ApiResponseModel response;

        switch (exception)
        {
            case ValidationException validationException:
                statusCode = HttpStatusCode.BadRequest;
                var namingPolicy = _jsonOptions.PropertyNamingPolicy ?? JsonNamingPolicy.CamelCase;
                var validationErrors = validationException.Errors
                    .GroupBy(e => e.PropertyName.Split('.').Last())
                    .ToDictionary(
                        g => namingPolicy.ConvertName(g.Key),
                        g => g.Select(e => e.ErrorMessage).ToArray()
                    );

                response = ApiResponseModel.Fail(validationErrors);
                _logger.LogWarning("Validation error: {ValidationErrors}", JsonSerializer.Serialize(validationErrors, _jsonOptions));
                break;

            case Application.Exceptions.NotFoundException notFoundException:
                statusCode = HttpStatusCode.NotFound;
                response= ApiResponseModel.Fail(notFoundException.Message);
                _logger.LogWarning("Resource not found: {Message}", notFoundException.Message);
                break;

            case Application.Exceptions.BadRequestException badRequestException:
                statusCode = HttpStatusCode.BadRequest;
                response = ApiResponseModel.Fail(badRequestException.Message);
                _logger.LogWarning("Bad request: {Message}", badRequestException.Message);
                break;

            case Application.Exceptions.ConflictException conflictException:
                statusCode = HttpStatusCode.Conflict;
                response = ApiResponseModel.Fail(conflictException.Message);
                _logger.LogWarning("Conflict: {Message}", conflictException.Message);
                break;

            case Application.Exceptions.UnauthorizedException unauthorizedException:
                statusCode = HttpStatusCode.Unauthorized;
                response = ApiResponseModel.Fail(unauthorizedException.Message);
                _logger.LogWarning("Unauthorized access: {Message}", unauthorizedException.Message);
                break;

            default:
                string message = env.IsDevelopment() ? exception.ToString() : "An unexpected error occurred. Please contact support.";
                response = ApiResponseModel.Fail(message);
                _logger.LogError(exception, "An unhandled exception has occurred.");
                break;
        }

        context.Response.ContentType = "application/json";
        context.Response.StatusCode = (int)statusCode;
        await context.Response.WriteAsync(JsonSerializer.Serialize(response, _jsonOptions));
    }
}

