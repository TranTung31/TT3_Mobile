using MediatR;
using Shared.Audit.Core;
using Shared.Audit.Events;
using Shared.Audit.Kafka;
using System.Text.Json;

namespace Shared.Audit.Behaviors;

public class AuditBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    where TRequest : IRequest<TResponse>
{
    private readonly IAuditKafkaProducer _kafkaProducer;
    private readonly IAuditUserContext _userContext;
    public AuditBehavior(IAuditKafkaProducer kafkaProducer, IAuditUserContext userContext)
    {
        _kafkaProducer = kafkaProducer;
        _userContext = userContext;
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken = default)
    {
        var response = await next();

        if (request is IAuditableCommand<TResponse>)
        {
            var auditEvent = new AuditLogEvent
            {
                TraceId = _userContext.TraceId,
                UserId = await _userContext.GetUserIdAsync() ?? "System/Anonymous",
                UserName = await _userContext.GetUserNameAsync() ?? "System/Anonymous",
                Action = $"COMMAND_{typeof(TRequest).Name}",
                Data = JsonSerializer.Serialize(request),
                Timestamp = DateTime.UtcNow,
                IpAddress = _userContext.IpAddress
            };

            await _kafkaProducer.PublishAsync("audit-logs", auditEvent, cancellationToken);
        }

        return response;
    }
}
