using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using SystemService.Application.Services;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Entities.Users;

namespace SystemService.Infrastructure.Persistence.SeedData;

public class ApplicationDbSeeder
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly RoleManager<Role> _roleManager;
    private readonly IPermissionSyncService _permissionSyncService;
    private readonly ILogger<ApplicationDbSeeder> _logger;

    public ApplicationDbSeeder(
        UserManager<ApplicationUser> userManager,
        RoleManager<Role> roleManager,
        IPermissionSyncService permissionSyncService,
        ILogger<ApplicationDbSeeder> logger)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _permissionSyncService = permissionSyncService;
        _logger = logger;
    }

    public async Task SeedDatabaseAsync(CancellationToken cancellationToken = default)
    {
        // 1. Đồng bộ toàn bộ permission từ TcdtPermissions vào bảng Permissions
        await _permissionSyncService.SyncPermissionsFromCodeAsync(cancellationToken);

        // 2. Role SuperAdmin + gán toàn bộ quyền
        const string superAdminRoleName = "administrator";
        //if (await _roleManager.FindByNameAsync(superAdminRoleName) is null)
        //{
        //    var role = await _permissionSyncService.CreateRoleAsync(superAdminRoleName, "Quản trị hệ thống", cancellationToken);
        //    var allPermissions = await _permissionSyncService.GetPermissionsByNamesAsync(
        //        PermissionReflectionHelper.GetAll().Select(p => p.Name), cancellationToken);
        //    await _permissionSyncService.AssignPermissionsToRoleAsync(role.Id, allPermissions.Select(p => p.Id), cancellationToken);
        //    _logger.LogInformation("Đã tạo role {Role} và gán toàn bộ quyền.", superAdminRoleName);
        //}

        // 3. User admin mặc định (tạo bằng Identity kèm password)
        const string adminUserName = "admin";
        if (await _userManager.FindByNameAsync(adminUserName) is null)
        {
            var admin = new ApplicationUser
            {
                Id = Guid.NewGuid(),
                UserName = adminUserName,
                Email = "admin@btc.vn",
                FullName = "Administrator",
                IsSuperAdmin = true,
                IsDeleted = false,
                CreatedOnUtc = DateTime.UtcNow
            };

            var createResult = await _userManager.CreateAsync(admin, "Ab@123456");
            if (!createResult.Succeeded)
                throw new InvalidOperationException(
                    $"Không thể tạo user {adminUserName}: {string.Join(", ", createResult.Errors.Select(e => e.Description))}");

            //await _userManager.AddToRoleAsync(admin, superAdminRoleName);
            _logger.LogInformation("Đã tạo user {User}.", adminUserName);
        }
    }
}
