namespace SystemService.Domain;

/// <summary>
/// Interface để đánh dấu các version, dùng để kiểm tra concurrency khi update dữ liệu
/// </summary>
public partial interface IVersionedEntity
{
    long VersionEntity { get; set; }
}
