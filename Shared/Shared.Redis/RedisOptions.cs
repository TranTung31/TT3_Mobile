namespace Shared.Redis;

public sealed class RedisOptions
{
    public const string SectionName = "Redis";

    public string Mode { get; set; } = "Cluster";

    public string? ConnectionString { get; set; }

    public string? SentinelConnectionString { get; set; }

    public string? ServiceName { get; set; }

    public string? Password { get; set; }

    public bool UseDistributedCache { get; set; } = false;

    public string InstanceName { get; set; } = "tcdt:";

    public int PermissionTtlMinutes { get; set; } = 720;

    public string PermissionKeyPrefix { get; set; } = "permissions:user";
}
