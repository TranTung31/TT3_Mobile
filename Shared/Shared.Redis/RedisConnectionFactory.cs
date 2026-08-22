using StackExchange.Redis;
using Microsoft.Extensions.Logging;
using System;

namespace Shared.Redis
{
    /// <summary>
    /// Cho trường hợp nếu Redis cấu hình là Redis Cluster và Redis Sentinel
    /// </summary>
    public static class RedisConnectionFactory
    {
        public static IConnectionMultiplexer Create(RedisOptions redisOptions, ILogger? logger = null)
        {
            var mode = redisOptions.Mode?.Trim().ToLowerInvariant();
            //logger?.LogInformation("RedisLogging: Initializing Redis connection in mode: {Mode}", redisOptions.Mode);
            Console.WriteLine($"[RedisConnectionFactory] Initializing Redis connection in mode: {redisOptions.Mode}");

            try
            {
                return mode switch
                {
                    "sentinel" => CreateSentinelConnection(redisOptions, logger),
                    "cluster" => CreateDirectConnection(redisOptions, logger),
                    "standalone" => CreateDirectConnection(redisOptions, logger),
                    _ => throw new InvalidOperationException(
                        $"Unsupported Redis mode: {redisOptions.Mode}")
                };
            }
            catch (Exception ex)
            {
                logger?.LogError(ex, "RedisLogging: Failed to create Redis connection for mode {Mode}", redisOptions.Mode);
                Console.Error.WriteLine($"[RedisConnectionFactory] [ERROR] Failed to create Redis connection for mode {redisOptions.Mode}: {ex}");
                throw;
            }
        }

        /// <summary>
        /// Redis Cluster
        /// </summary>
        /// <param name="redisOptions"></param>
        /// <param name="logger"></param>
        /// <returns></returns>
        /// <exception cref="InvalidOperationException"></exception>
        private static IConnectionMultiplexer CreateDirectConnection(
            RedisOptions redisOptions, ILogger? logger = null)
        {
            if (string.IsNullOrWhiteSpace(redisOptions.ConnectionString))
            {
                throw new InvalidOperationException(
                    "Redis:ConnectionString is required.");
            }

            //logger?.LogInformation("RedisLogging: Connecting directly to Redis using ConnectionString: {ConnectionString}", redisOptions.ConnectionString);
            Console.WriteLine($"[RedisConnectionFactory] Connecting directly to Redis using ConnectionString: {redisOptions.ConnectionString}");

            var options = ConfigurationOptions.Parse(redisOptions.ConnectionString);

            options.AbortOnConnectFail = false;
            options.ConnectRetry = options.ConnectRetry > 0 ? options.ConnectRetry : 3;
            options.ConnectTimeout = options.ConnectTimeout > 0 ? options.ConnectTimeout : 5000;
            options.KeepAlive = options.KeepAlive > 0 ? options.KeepAlive : 60;

            var connection = ConnectionMultiplexer.Connect(options);

            logger?.LogInformation("RedisLogging: Direct Redis connection established. IsConnected: {IsConnected}", connection.IsConnected);
            Console.WriteLine($"[RedisConnectionFactory] Direct Redis connection established. IsConnected: {connection.IsConnected}");

            return connection;
        }

        /// <summary>
        /// Redis Sentinel
        /// </summary>
        /// <param name="redisOptions"></param>
        /// <param name="logger"></param>
        /// <returns></returns>
        /// <exception cref="InvalidOperationException"></exception>
        private static IConnectionMultiplexer CreateSentinelConnection(
            RedisOptions redisOptions, ILogger? logger = null)
        {
            if (string.IsNullOrWhiteSpace(redisOptions.SentinelConnectionString))
            {
                throw new InvalidOperationException(
                    "Redis:SentinelConnectionString is required.");
            }

            if (string.IsNullOrWhiteSpace(redisOptions.ServiceName))
            {
                throw new InvalidOperationException(
                    "Redis:ServiceName is required.");
            }

            //logger?.LogInformation("Connecting to Redis Sentinel. SentinelConnectionString: {SentinelConnectionString}, ServiceName: {ServiceName}",
            //    redisOptions.SentinelConnectionString, redisOptions.ServiceName);
            Console.WriteLine($"[RedisConnectionFactory] Connecting to Redis Sentinel. SentinelConnectionString: {redisOptions.SentinelConnectionString}, ServiceName: {redisOptions.ServiceName}");

            var sentinelOptions = ConfigurationOptions.Parse(
                redisOptions.SentinelConnectionString);

            sentinelOptions.CommandMap = CommandMap.Sentinel;
            sentinelOptions.ServiceName = redisOptions.ServiceName;
            sentinelOptions.AbortOnConnectFail = false;
            sentinelOptions.ConnectRetry = sentinelOptions.ConnectRetry > 0
                ? sentinelOptions.ConnectRetry
                : 3;
            sentinelOptions.ConnectTimeout = sentinelOptions.ConnectTimeout > 0
                ? sentinelOptions.ConnectTimeout
                : 5000;

            if (!string.IsNullOrWhiteSpace(redisOptions.Password))
            {
                //logger?.LogInformation("Applying Password to SentinelOptions.");
                Console.WriteLine("[RedisConnectionFactory] Applying Password to SentinelOptions.");
                sentinelOptions.Password = redisOptions.Password;
            }

            var sentinelConnection =
                ConnectionMultiplexer.SentinelConnect(sentinelOptions);

            //logger?.LogInformation("Sentinel Connection established. IsConnected: {IsConnected}", sentinelConnection.IsConnected);
            Console.WriteLine($"[RedisConnectionFactory] Sentinel Connection established. IsConnected: {sentinelConnection.IsConnected}");

            var masterOptions = new ConfigurationOptions
            {
                ServiceName = redisOptions.ServiceName,
                Password = redisOptions.Password,
                AbortOnConnectFail = false,
                ConnectRetry = 3,
                ConnectTimeout = 5000,
                KeepAlive = 60
            };

            //logger?.LogInformation("Retrieving Sentinel Master connection for ServiceName: {ServiceName}...", redisOptions.ServiceName);
            Console.WriteLine($"[RedisConnectionFactory] Retrieving Sentinel Master connection for ServiceName: {redisOptions.ServiceName}...");

            var masterConnection = sentinelConnection.GetSentinelMasterConnection(masterOptions);

            logger?.LogInformation("RedisLogging: Sentinel Master connection retrieved. IsConnected: {IsConnected}", masterConnection.IsConnected);
            Console.WriteLine($"[RedisConnectionFactory] Sentinel Master connection retrieved. IsConnected: {masterConnection.IsConnected}");

            return masterConnection;
        }
    }
}
