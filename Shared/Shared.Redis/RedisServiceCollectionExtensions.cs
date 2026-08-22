using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;

namespace Shared.Redis;

public static class RedisServiceCollectionExtensions
{
    public static IServiceCollection AddSharedRedis(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var redisOptions = configuration
            .GetSection(RedisOptions.SectionName)
            .Get<RedisOptions>()
            ?? throw new InvalidOperationException("Missing Redis configuration.");

        services.Configure<RedisOptions>(configuration.GetSection(RedisOptions.SectionName));

        //services.AddSingleton<IConnectionMultiplexer>(_ =>
        //    ConnectionMultiplexer.Connect(configuration[$"{RedisOptions.SectionName}:ConnectionString"]!));

        services.AddSingleton<IConnectionMultiplexer>(sp =>
        {
            var logger = sp.GetService<ILoggerFactory>()?.CreateLogger("RedisConnectionFactory");
            return RedisConnectionFactory.Create(redisOptions, logger);
        });

        if (redisOptions.UseDistributedCache)
        {
            services.AddStackExchangeRedisCache(options =>
            {
                options.InstanceName = redisOptions.InstanceName;

                options.ConnectionMultiplexerFactory = async () =>
                {
                    var multiplexer = RedisConnectionFactory.Create(redisOptions);
                    return await Task.FromResult(multiplexer);
                };
            });
        }

        services.AddScoped<Permissions.IUserPermissionCacheService, Permissions.RedisUserPermissionCacheService>();

        return services;
    }
}
