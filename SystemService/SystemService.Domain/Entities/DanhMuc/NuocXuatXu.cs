namespace SystemService.Domain.Entities.DanhMuc;

public class NuocXuatXu : BaseEntity<Guid>, ISoftDeletedEntity
{
    public string MaNuocXuatXu { get; set; }
    public string TenNuocXuatXu { get; set; }
    public string GhiChu { get; set; }

    /// <summary>
    /// Đánh dấu là đã xóa
    /// </summary>
    public bool IsDeleted { get; set; }
}
