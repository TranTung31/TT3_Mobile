namespace Shared.Audit.Core;

public interface IAuditUserContext
{
    Task<string> GetUserNameAsync();
    Task<string> GetUserIdAsync();
    string TraceId { get; }
    string IpAddress { get; }
}
