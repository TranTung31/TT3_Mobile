namespace SystemService.Domain.Shadow;

public abstract partial class ShadowBaseEntity
{
    /// <summary>
    /// Gets or sets the date and time when the entity was created
    /// </summary>
    public DateTime CreatedOnUtc { get; set; }

    /// <summary>
    /// Gets or sets the date and time when the entity was last updated
    /// </summary>
    public DateTime? UpdatedOnUtc { get; set; }
}
