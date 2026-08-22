namespace Shared.Redis.Permissions;

public interface IUserPermissionCacheService
{
    string GetKey(Guid userId);

    Task<IReadOnlyCollection<string>?> GetPermissionsAsync(
        Guid userId,
        CancellationToken cancellationToken = default);

    Task SetPermissionsAsync(
        Guid userId,
        IEnumerable<string> permissions,
        TimeSpan? ttl = null,
        CancellationToken cancellationToken = default);

    Task RemovePermissionsAsync(
        Guid userId,
        CancellationToken cancellationToken = default);
}
