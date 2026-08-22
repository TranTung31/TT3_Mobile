using MediatR;

namespace Shared.Audit.Core;

public interface IAuditableCommand<out TResponse> : IRequest<TResponse>
{
}
