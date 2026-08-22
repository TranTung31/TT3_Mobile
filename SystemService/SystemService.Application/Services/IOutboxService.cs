namespace SystemService.Application.Services;

public interface IOutboxService
{
    /// <summary>
    /// Thêm một sự kiện vào outbox. Bên gọi chịu trách nhiệm commit
    /// dữ liệu nghiệp vụ và sự kiện trong cùng một transaction.
    /// </summary>
    Task SaveEventAsync<T>(
        string eventType,
        T eventData,
        CancellationToken cancellationToken = default);
}
