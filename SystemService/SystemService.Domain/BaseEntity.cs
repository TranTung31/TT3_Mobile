using SystemService.Domain.Shadow;

namespace SystemService.Domain;

/// <summary>
/// Represents the base class for entities
/// </summary>
public abstract partial class BaseEntity<TKey>: ShadowBaseEntity
{
    /// <summary>
    /// Gets or sets the entity identifier
    /// </summary>
    public TKey Id { get; set; } = default!;

}
