using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using SystemService.Application.Services;
using SystemService.Domain.Repositories;
using SystemService.Domain;
using SystemService.Domain.Entities.Authorization;
using Microsoft.EntityFrameworkCore;
using SystemService.Infrastructure.Persistence;

namespace SystemService.Infrastructure.Services;

public class PermissionSyncService : IPermissionSyncService
{
    private readonly RoleManager<Role> _roleManager;
    private readonly SystemDbContext _dbContext;
    private readonly IPermissionRepository _permissionRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<PermissionSyncService> _logger;

    public PermissionSyncService(
        RoleManager<Role> roleManager,
        SystemDbContext dbContext,
        IPermissionRepository permissionRepository,
        IRolePermissionRepository rolePermissionRepository,
        IUnitOfWork unitOfWork,
        ILogger<PermissionSyncService> logger)
    {
        _roleManager = roleManager;
        _dbContext = dbContext;
        _permissionRepository = permissionRepository;
        _rolePermissionRepository = rolePermissionRepository;
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    public async Task<Role> CreateRoleAsync(string name, string? description = null, CancellationToken cancellationToken = default)
    {
        var role = new Role { Id = Guid.NewGuid(), Name = name, Description = description ?? string.Empty, IsActive = true };
        var result = await _roleManager.CreateAsync(role);
        if (!result.Succeeded)
            throw new InvalidOperationException(
                $"Không thể tạo role {name}: {string.Join(", ", result.Errors.Select(e => e.Description))}");
        return role;
    }

    public async Task<Role?> GetRoleByNameAsync(string name, CancellationToken cancellationToken = default)
        => await _roleManager.FindByNameAsync(name);

    public async Task<Role> UpdateRoleAsync(Guid id, string name, string? description = null, CancellationToken cancellationToken = default)
    {
        var role = await _roleManager.FindByIdAsync(id.ToString())
                   ?? throw new InvalidOperationException($"Role {id} không tồn tại.");
        role.Name = name;
        role.Description = description ?? role.Description;
        var result = await _roleManager.UpdateAsync(role);
        if (!result.Succeeded)
            throw new InvalidOperationException("Không thể cập nhật role.");
        return role;
    }

    public async Task<Role> UpdateRoleWithPermissionsAsync(Guid id, string name, string? description, List<string>? permissions, string originalName, CancellationToken cancellationToken = default)
    {
        var role = await UpdateRoleAsync(id, name, description, cancellationToken);
        if (permissions != null)
            await AssignPermissionsToRoleByNamesAsync(role.Id, permissions, cancellationToken);
        return role;
    }

    public async Task DeleteRoleAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var role = await _roleManager.FindByIdAsync(id.ToString());
        if (role == null) return;
        await _rolePermissionRepository.DeleteByRoleIdAsync(id, cancellationToken);
        await _roleManager.DeleteAsync(role);
    }

    public async Task DeleteRoleByNameAsync(string name, CancellationToken cancellationToken = default)
    {
        var role = await _roleManager.FindByNameAsync(name);
        if (role != null)
            await DeleteRoleAsync(role.Id, cancellationToken);
    }

    public async Task AssignPermissionsToRoleAsync(Guid roleId, IEnumerable<Guid> permissionIds, CancellationToken cancellationToken = default)
    {
        await _rolePermissionRepository.AssignPermissionsAsync(roleId, permissionIds, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    public async Task AssignPermissionsToRoleByNamesAsync(Guid roleId, IEnumerable<string> permissionNames, CancellationToken cancellationToken = default)
    {
        var permissions = await _permissionRepository.GetByNamesAsync(permissionNames, cancellationToken);
        await AssignPermissionsToRoleAsync(roleId, permissions.Select(p => p.Id), cancellationToken);
    }

    public async Task RemoveAllPermissionsFromRoleAsync(Guid roleId, CancellationToken cancellationToken = default)
    {
        await _rolePermissionRepository.DeleteByRoleIdAsync(roleId, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    public async Task SyncPermissionsFromCodeAsync(CancellationToken cancellationToken = default)
    {
        var fromCode = PermissionReflectionHelper.GetAll();
        var existing = await _permissionRepository.GetAllActiveAsync(cancellationToken);

        var codePermissionNames = fromCode.Select(p => p.Name).ToHashSet(StringComparer.OrdinalIgnoreCase);
        var deletePermissions = existing.Where(p => !codePermissionNames.Contains(p.Name)).ToList();

        if (deletePermissions.Any())
        {
            _dbContext.Permissions.RemoveRange(deletePermissions);
        }

        foreach (var seed in fromCode)
        {
            var existingPer = await _permissionRepository.GetByNameAsync(seed.Name, cancellationToken);

            if (existingPer != null)
            {
                // Cập nhật description nếu khác
                if (existingPer.Description != seed.Description || existingPer.GroupPath != string.Join("|", seed.GroupPath))
                {
                    existingPer.Description = seed.Description;
                    existingPer.GroupPath = string.Join("|", seed.GroupPath);
                    await _permissionRepository.UpdateAsync(existingPer);
                }
            }
            else
            {
                await _permissionRepository.InsertAsync(new Permission
                {
                    Id = Guid.NewGuid(),
                    Name = seed.Name,
                    Description = seed.Description,
                    GroupPath = seed.GroupPath,   // "|" làm separator, khớp GetPermissionsAsTreeFromDbQuery
                    IsActive = true,
                    CreatedOnUtc = DateTime.UtcNow
                });
            }
        }

        await _unitOfWork.SaveChangesAsync(cancellationToken);
        _logger.LogInformation("Đồng bộ xong {Count} permission từ code vào DB.", fromCode.Count);
    }

    public async Task InitializeAsync(CancellationToken cancellationToken = default)
        => await SyncPermissionsFromCodeAsync(cancellationToken);

    public async Task<IList<Permission>> GetPermissionsByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default)
        => await _rolePermissionRepository.GetPermissionsByRoleIdAsync(roleId, cancellationToken);

    public async Task<IList<Permission>> GetPermissionsByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default)
        => await _permissionRepository.GetByNamesAsync(names, cancellationToken);
}
