using System.Text.Json;
using Microsoft.Extensions.Options;
using StackExchange.Redis;
using Microsoft.Extensions.Logging;

namespace Shared.Redis.Permissions;

public sealed class RedisUserPermissionCacheService : IUserPermissionCacheService
{
    private static readonly JsonSerializerOptions JsonSerializerOptions = new(JsonSerializerDefaults.Web);

    private readonly IDatabase _database;
    private readonly RedisOptions _options;
    private readonly ILogger<RedisUserPermissionCacheService> _logger;

    public RedisUserPermissionCacheService(
        IConnectionMultiplexer connectionMultiplexer,
        IOptions<RedisOptions> options,
        ILogger<RedisUserPermissionCacheService> logger)
    {
        _database = connectionMultiplexer.GetDatabase();
        _options = options.Value;
        _logger = logger;
    }

    public string GetKey(Guid userId)
    {
        return $"{_options.PermissionKeyPrefix}:{userId}";
    }

    public async Task<IReadOnlyCollection<string>?> GetPermissionsAsync(
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var key = GetKey(userId);
        //_logger.LogInformation("Getting permissions for user {UserId} from Redis key '{Key}'...", userId, key);

        try
        {
            var value = await _database.StringGetAsync(key);
            if (value.IsNullOrEmpty)
            {
                _logger.LogInformation("RedisLogging: No permissions found in Redis for user {UserId} (key: '{Key}')", userId, key);
                return null;
            }

            var permissions = JsonSerializer.Deserialize<string[]>(value!, JsonSerializerOptions);
            //_logger.LogInformation("Successfully retrieved {Count} permissions for user {UserId} from Redis (key: '{Key}')", permissions?.Length ?? 0, userId, key);
            return permissions;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "RedisLogging: Error reading permissions from Redis for user {UserId} (key: '{Key}')", userId, key);
            return null;
        }
    }

    public async Task SetPermissionsAsync(
        Guid userId,
        IEnumerable<string> permissions,
        TimeSpan? ttl = null,
        CancellationToken cancellationToken = default)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var key = GetKey(userId);

        try
        {
            var normalizedPermissions = permissions
                .Where(static permission => !string.IsNullOrWhiteSpace(permission))
                .Select(static permission => permission.Trim())
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(static permission => permission, StringComparer.OrdinalIgnoreCase)
                .ToArray();

            var serializedPermissions = JsonSerializer.Serialize(normalizedPermissions, JsonSerializerOptions);
            var expiry = ttl ?? TimeSpan.FromMinutes(_options.PermissionTtlMinutes);

            //_logger.LogInformation("Saving {Count} permissions for user {UserId} to Redis key '{Key}' with TTL {Expiry}...",
            //    normalizedPermissions.Length, userId, key, expiry);

            var success = await _database.StringSetAsync(key, serializedPermissions, expiry);
            if (success)
            {
                //_logger.LogInformation("Successfully saved permissions for user {UserId} to Redis (key: '{Key}')", userId, key);
            }
            else
            {
                _logger.LogWarning("RedisLogging: Failed to save permissions for user {UserId} to Redis (key: '{Key}') - StringSetAsync returned false", userId, key);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "RedisLogging: Error saving permissions to Redis for user {UserId} (key: '{Key}')", userId, key);
        }
    }

    public async Task RemovePermissionsAsync(
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        cancellationToken.ThrowIfCancellationRequested();
        var key = GetKey(userId);
        //_logger.LogInformation("Removing permissions for user {UserId} from Redis (key: '{Key}')...", userId, key);
        try
        {
            var success = await _database.KeyDeleteAsync(key);
            //_logger.LogInformation("Remove permissions for user {UserId} from Redis (key: '{Key}') completed. Success: {Success}", userId, key, success);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "RedisLogging: Error removing permissions from Redis for user {UserId} (key: '{Key}')", userId, key);
        }
    }
}
