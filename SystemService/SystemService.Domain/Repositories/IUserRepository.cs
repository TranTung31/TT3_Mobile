using SystemService.Domain.Entities.Users;

namespace SystemService.Domain.Repositories;

public interface IUserRepository
{
    IQueryable<ApplicationUser> Table { get; }

    /// <summary>
    /// Lấy danh sách tất cả người dùng (kèm query builder tùy chọn)
    /// </summary>
    Task<IList<ApplicationUser>> GetAllAsync(
        Func<IQueryable<ApplicationUser>, IQueryable<ApplicationUser>>? func = null,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Lấy người dùng theo Id (đã loại trừ người dùng bị xóa mềm)
    /// </summary>
    Task<ApplicationUser?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>
    /// Tìm kiếm và lấy danh sách người dùng và phân trang
    /// </summary>
    /// <param name="keyword">Từ khóa tìm kiếm (UserName/FullName/Email)</param>
    /// <param name="userName">Lọc theo tên đăng nhập</param>
    /// <param name="fullName">Lọc theo họ tên</param>
    /// <param name="email">Lọc theo email</param>
    /// <param name="isEnabled">Lọc theo trạng thái kích hoạt</param>
    /// <param name="donViId">Lọc theo đơn vị</param>
    /// <param name="pageIndex">Chỉ số trang (bắt đầu từ 0).</param>
    /// <param name="pageSize">Kích thước trang.</param>
    /// <returns>Một danh sách đã phân trang của các thực thể ApplicationUser.</returns>
    Task<IPagedList<ApplicationUser>> SearchAsync(
        string keyword = null,
        string userName = null,
        string fullName = null,
        string email = null,
        bool? isEnabled = null,
        Guid? donViId = null,
        int pageIndex = 0,
        int pageSize = int.MaxValue,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Hàm kiểm tra UserName có tồn tại trong DB hay không.
    /// </summary>
    Task<bool> BeUniqueUserName(string userName, Guid? currentId = null, CancellationToken cancellationToken = default);

    /// <summary>
    /// Hàm kiểm tra Email có tồn tại trong DB hay không.
    /// </summary>
    Task<bool> BeUniqueEmail(string email, Guid? currentId = null, CancellationToken cancellationToken = default);

    Task<Guid> GetDonViIdByIdAsync(Guid userId);
}
