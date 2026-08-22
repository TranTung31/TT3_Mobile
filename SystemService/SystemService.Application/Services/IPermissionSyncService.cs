using System.Collections.Generic;
using SystemService.Domain.Entities.Authorization;

namespace SystemService.Application.Services;

public interface IPermissionSyncService
{
    #region Role Management (Dual Write: DB + Keycloak)

    /// <summary>
    /// Tạo role mới - lưu cả DB và Keycloak
    /// </summary>
    Task<Role> CreateRoleAsync(string name, string? description = null, CancellationToken cancellationToken = default);

    /// <summary>
    /// Cập nhật role - cập nhật cả DB và Keycloak (chỉ cập nhật name và description)
    /// </summary>
    Task<Role> UpdateRoleAsync(Guid id, string name, string? description = null, CancellationToken cancellationToken = default);

    /// <summary>
    /// Lấy role theo tên
    /// </summary>
    Task<Role?> GetRoleByNameAsync(string name, CancellationToken cancellationToken = default);

    /// <summary>
    /// Cập nhật role kèm theo permissions - cập nhật cả DB và Keycloak (Composite Role)
    /// </summary>
    /// <param name="id">Role ID</param>
    /// <param name="name">Tên mới của role</param>
    /// <param name="description">Mô tả</param>
    /// <param name="permissions">Danh sách permission names. Để null nếu không muốn cập nhật permissions</param>
    /// <param name="originalName">Tên cũ của role (để handle đổi tên)</param>
    Task<Role> UpdateRoleWithPermissionsAsync(Guid id, string name, string? description, List<string>? permissions, string originalName, CancellationToken cancellationToken = default);

    /// <summary>
    /// Xóa role - xóa cả DB và Keycloak
    /// </summary>
    Task DeleteRoleAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>
    /// Xóa role theo tên - xóa cả DB và Keycloak
    /// </summary>
    Task DeleteRoleByNameAsync(string name, CancellationToken cancellationToken = default);

    #endregion

    #region Permission Management

    /// <summary>
    /// Đồng bộ permissions từ TcdtPermissions (code) vào DB
    /// </summary>
    Task SyncPermissionsFromCodeAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Khởi tạo: Sync tất cả permissions và roles từ Keycloak về DB (dùng khi app start lần đầu)
    /// </summary>
    Task InitializeAsync(CancellationToken cancellationToken = default);

    #endregion

    #region Role-Permission Assignment (Dual Write: DB + Keycloak Composite)

    /// <summary>
    /// Gán permissions cho role - lưu cả DB và Keycloak (Composite Role) theo permission IDs
    /// </summary>
    Task AssignPermissionsToRoleAsync(Guid roleId, IEnumerable<Guid> permissionIds, CancellationToken cancellationToken = default);

    /// <summary>
    /// Gán permissions cho role - lưu cả DB và Keycloak (Composite Role) theo permission names
    /// </summary>
    Task AssignPermissionsToRoleByNamesAsync(Guid roleId, IEnumerable<string> permissionNames, CancellationToken cancellationToken = default);

    /// <summary>
    /// Xóa tất cả permissions của một role - xóa cả DB và Keycloak
    /// </summary>
    Task RemoveAllPermissionsFromRoleAsync(Guid roleId, CancellationToken cancellationToken = default);

    #endregion

    #region Query

    /// <summary>
    /// Lấy danh sách permissions của một role
    /// </summary>
    Task<IList<Permission>> GetPermissionsByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Lấy danh sách permissions theo tên
    /// </summary>
    Task<IList<Permission>> GetPermissionsByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default);

    #endregion
}