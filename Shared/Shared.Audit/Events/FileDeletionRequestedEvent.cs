namespace Shared.Audit.Events;

public class FileDeletionRequestedEvent
{
    public Guid FileId { get; set; }
    public string Reason { get; set; } = string.Empty;
}
