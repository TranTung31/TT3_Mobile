using Shared.Audit.Events;
using System.Text.Json;

namespace Shared.Audit.Core;

public class AuditEntry
{
    public string TraceId { get; set; } = string.Empty;
    public string UserId { get; set; } = string.Empty;
    public string UserName { get; set; } = string.Empty;
    public string TableName { get; set; } = string.Empty;
    public string Action { get; set; } = string.Empty;
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    public string? IpAddress { get; set; }

    public Dictionary<string, object> KeyValues { get; } = [];
    public Dictionary<string, object> OldValues { get; } = [];
    public Dictionary<string, object> NewValues { get; } = [];

    public AuditLogEvent ToAuditEvent()
    {
        var detailedData = new
        {
            Table = TableName,
            Keys = KeyValues,
            OldValues = OldValues.Count > 0 ? OldValues : null,
            NewValues = NewValues.Count > 0 ? NewValues : null
        };

        return new AuditLogEvent
        {
            TraceId = TraceId,
            UserId = UserId,
            UserName = UserName,
            Action = $"{Action}_{TableName}",
            Data = JsonSerializer.Serialize(detailedData),
            Timestamp = Timestamp,
            IpAddress = IpAddress
        };
    }
}
