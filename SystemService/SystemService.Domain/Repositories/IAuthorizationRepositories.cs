using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Entities.Users;

namespace SystemService.Domain.Repositories;

public interface IPermissionRepository
{
    IQueryable<Permission> Table { get; }

    Task InsertAsync(Permission entity);

    /// <summary>
    /// Lấy permission theo tên
    /// </summary>
    Task<Permission?> GetByNameAsync(string name, CancellationToken cancellationToken = default);

    /// <summary>
    /// Lấy danh sách permissions theo danh sách tên
    /// </summary>
    Task<IList<Permission>> GetByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default);

    /// <summary>
    /// Lấy tất cả permissions active
    /// </summary>
    Task<IList<Permission>> GetAllActiveAsync(CancellationToken cancellationToken = default);
}

public interface IRolePermissionRepository
{
    IQueryable<RolePermission> Table { get; }

    /// <summary>
    /// Lấy tất cả permissions của một role
    /// </summary>
    Task<IList<Permission>> GetPermissionsByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Lấy tất cả roles có một permission
    /// </summary>
    Task<IList<Role>> GetRolesByPermissionIdAsync(Guid permissionId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Xóa tất cả permissions của một role
    /// </summary>
    Task DeleteByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Kiểm tra một role có một permission cụ thể không
    /// </summary>
    Task<bool> HasPermissionAsync(Guid roleId, Guid permissionId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gán nhiều permissions cho một role
    /// </summary>
    Task AssignPermissionsAsync(Guid roleId, IEnumerable<Guid> permissionIds, CancellationToken cancellationToken = default);
}

public interface IRoleRepository
{
    IQueryable<Role> Table { get; }

    /// <summary>
    /// Tìm role theo id
    /// </summary>
    Task<Role?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>
    /// Tìm role theo tên
    /// </summary>
    Task<Role?> GetByNameAsync(string name, CancellationToken cancellationToken = default);

    /// <summary>
    /// Kiểm tra tên role đã tồn tại chưa
    /// </summary>
    Task<bool> BeUniqueNameAsync(string name, Guid? currentId = null, CancellationToken cancellationToken = default);

    /// <summary>
    /// Lấy danh sách role kèm theo permissions
    /// </summary>
    Task<Role?> GetByIdWithPermissionsAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>
    /// Tìm kiếm và phân trang
    /// </summary>
    Task<IPagedList<Role>> SearchAsync(string keyword, string name, string desciption, int pageIndex = 0, int pageSize = int.MaxValue);

    /// <summary>
    /// Lấy danh sách role theo danh sách tên
    /// </summary>
    Task<IList<Role>> GetByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default);
}

public interface IApplicationUserRoleRepository
{
    /// <summary>
    /// Lấy tất cả roles của một user
    /// </summary>
    Task<IList<Role>> GetRolesByUserIdAsync(Guid userId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Lấy tất cả users của một role
    /// </summary>
    Task<IList<ApplicationUser>> GetUsersByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Xóa tất cả roles của một user
    /// </summary>
    Task DeleteByUserIdAsync(Guid userId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gán nhiều roles cho một user
    /// </summary>
    Task AssignRolesAsync(Guid userId, IEnumerable<Guid> roleIds, CancellationToken cancellationToken = default);
}
