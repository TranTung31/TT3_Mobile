namespace SystemService.Domain.Entities.DanhMuc;

public class QuyCachDongGoi : BaseEntity<Guid>, ISoftDeletedEntity
{
    public string MaQuyCach { get; set; }
    public string TenQuyCach { get; set; }
    public string Description { get; set; }

    /// <summary>
    /// Đánh dấu là đã xóa
    /// </summary>
    public bool IsDeleted { get; set; }
}
