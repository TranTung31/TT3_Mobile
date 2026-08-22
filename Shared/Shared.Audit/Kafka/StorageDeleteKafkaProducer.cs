using Confluent.Kafka;
using Microsoft.Extensions.Options;
using System.Text.Json;

namespace Shared.Audit.Kafka;

public interface IStorageDeleteKafkaProducer
{
    Task PublishAsync<T>(string key, T message, CancellationToken cancellationToken = default) where T : class;
}

public class StorageDeleteKafkaProducer : IStorageDeleteKafkaProducer, IDisposable
{
    private readonly IProducer<string, string> _producer;
    private readonly KafkaOptions _options;
    public StorageDeleteKafkaProducer(IOptions<KafkaOptions> options)
    {
        _options = options.Value;

        var acksEnum = _options.Producer.Acks.Equals("all", StringComparison.CurrentCultureIgnoreCase) ? Acks.All : Acks.Leader;
        var config = new ProducerConfig
        {
            BootstrapServers = _options.BootstrapServers,
            SecurityProtocol = Enum.Parse<SecurityProtocol>(_options.SecurityProtocol, true),
            Acks = acksEnum,
            MessageTimeoutMs = _options.Producer.MessageTimeoutMs,
            MessageSendMaxRetries = _options.Producer.Retries,
            EnableIdempotence = true
        };

        _producer = new ProducerBuilder<string, string>(config).Build();
    }

    public async Task PublishAsync<T>(string key, T message, CancellationToken cancellationToken = default) where T : class
    {
        string topicName = _options.Topics.StorageDelete;
        var jsonValue = JsonSerializer.Serialize(message);
        var kafkaMessage = new Message<string, string> { Key = key, Value = jsonValue };
        await _producer.ProduceAsync(topicName, kafkaMessage, cancellationToken);
    }

    public void Dispose()
    {
        _producer.Flush(TimeSpan.FromSeconds(5));
        _producer.Dispose();
    }
}