namespace Shared.Contracts.Messaging;

/// <summary>
/// Contract dùng để đồng bộ dữ liệu danh mục dùng chung giữa các service.
/// </summary>
public sealed record DanhMucSyncEvent
{
    /// <summary>
    /// Mã định danh duy nhất của sự kiện, dùng để consumer kiểm tra idempotency và tránh xử lý trùng lặp.
    /// </summary>
    public Guid EventId { get; init; }

    /// <summary>
    /// Tên entity đã thay đổi.
    /// </summary>
    public required string EntityType { get; init; }

    /// <summary>
    /// Mã định danh của entity đã thay đổi.
    /// </summary>
    public Guid EntityId { get; init; }

    /// <summary>
    /// Thao tác được thực hiện trên entity: Created, Updated hoặc Deleted.
    /// </summary>
    public required string Operation { get; init; }

    /// <summary>
    /// Dữ liệu entity được serialize dưới dạng JSON.
    /// </summary>
    public required string Payload { get; init; }

    /// <summary>
    /// Thời điểm sự kiện được tạo, theo giờ UTC.
    /// </summary>
    public DateTime Timestamp { get; init; }

    /// <summary>
    /// Phiên bản của entity, dùng để kiểm tra tính nhất quán dữ liệu khi đồng bộ.
    /// </summary>
    public long VersionEntity { get; init; }

    /// <summary>
    /// Tên service phát sinh sự kiện.
    /// </summary>
    public required string SourceService { get; init; }
}
