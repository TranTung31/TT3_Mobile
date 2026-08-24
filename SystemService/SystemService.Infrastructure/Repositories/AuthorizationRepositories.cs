using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using SystemService.Domain;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;
using SystemService.Infrastructure.Extensions;
using SystemService.Infrastructure.Persistence;

namespace SystemService.Infrastructure.Repositories;

public class RoleRepository : IRoleRepository
{
    private readonly SystemDbContext _context;

    public RoleRepository(SystemDbContext context) => _context = context;

    public IQueryable<Role> Table => _context.Roles.AsQueryable();

    public async Task<Role?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await Table.FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
    }

    public async Task<Role?> GetByNameAsync(string name, CancellationToken cancellationToken = default)
    {
        return await Table.FirstOrDefaultAsync(r => r.Name == name, cancellationToken);
    }

    public async Task<bool> BeUniqueNameAsync(string name, Guid? currentId = null, CancellationToken cancellationToken = default)
    {
        var role = await Table.FirstOrDefaultAsync(r => r.Name == name, cancellationToken);
        return role == null || role.Id == currentId;
    }

    public async Task<Role?> GetByIdWithPermissionsAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await Table
            .Include(r => r.RolePermissions)
                .ThenInclude(rp => rp.Permission)
            .FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
    }

    public async Task<IPagedList<Role>> SearchAsync(string keyword, string name, string desciption, int pageIndex = 0, int pageSize = int.MaxValue)
    {
        var query = Table.AsQueryable();

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            keyword = keyword.ToLower();
            query = query.Where(r => r.Name.ToLower().Contains(keyword) ||
                                 (r.Description != null && r.Description.ToLower().Contains(keyword)));
        }

        if (!string.IsNullOrWhiteSpace(name))
        {
            name = name.ToLower();
            query = query.Where(r => r.Name.ToLower().Contains(name));
        }

        if (!string.IsNullOrWhiteSpace(desciption))
        {
            desciption = desciption.ToLower();
            query = query.Where(r => r.Description.ToLower().Contains(desciption));
        }

        query = query.OrderBy(r => r.Name);

        return await query.ToPagedListAsync(pageIndex, pageSize);
    }

    public async Task<IList<Role>> GetByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default)
    {
        var nameList = names.ToList();
        return await Table
            .Where(r => nameList.Contains(r.Name))
            .ToListAsync(cancellationToken);
    }
}

public class PermissionRepository : IPermissionRepository
{
    private readonly SystemDbContext _context;

    public PermissionRepository(SystemDbContext context) => _context = context;

    public IQueryable<Permission> Table => _context.Permissions.AsQueryable();

    public async Task<Permission?> GetByNameAsync(string name, CancellationToken cancellationToken = default)
    {
        return await Table.FirstOrDefaultAsync(p => p.Name == name, cancellationToken);
    }

    public async Task<IList<Permission>> GetByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default)
    {
        var nameList = names.ToList();
        return await Table
            .Where(p => nameList.Contains(p.Name))
            .ToListAsync(cancellationToken);
    }

    public async Task<IList<Permission>> GetAllActiveAsync(CancellationToken cancellationToken = default)
    {
        return await Table
            .Where(p => p.IsActive)
            .OrderBy(p => p.Name)
            .ToListAsync(cancellationToken);
    }

    public async Task InsertAsync(Permission entity)
    {
        await _context.Permissions.AddAsync(entity);
    }

    public Task UpdateAsync(Permission entity)
    {
        ArgumentNullException.ThrowIfNull(entity);
        _context.Permissions.Update(entity);
        return Task.CompletedTask;
    }
}

public class RolePermissionRepository : IRolePermissionRepository
{
    private readonly SystemDbContext _context;

    public RolePermissionRepository(SystemDbContext context) => _context = context;

    public IQueryable<RolePermission> Table => _context.RolePermissions.AsQueryable();

    public async Task<IList<Permission>> GetPermissionsByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default)
    {
        return await Table
            .Where(rp => rp.RoleId == roleId)
            .Include(rp => rp.Permission)
            .Select(rp => rp.Permission)
            .ToListAsync(cancellationToken);
    }

    public async Task<IList<Role>> GetRolesByPermissionIdAsync(Guid permissionId, CancellationToken cancellationToken = default)
    {
        return await Table
            .Where(rp => rp.PermissionId == permissionId)
            .Include(rp => rp.Role)
            .Select(rp => rp.Role)
            .ToListAsync(cancellationToken);
    }

    public async Task DeleteByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default)
    {
        var rolePermissions = await Table.Where(rp => rp.RoleId == roleId).ToListAsync(cancellationToken);
        _context.RolePermissions.RemoveRange(rolePermissions);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<bool> HasPermissionAsync(Guid roleId, Guid permissionId, CancellationToken cancellationToken = default)
    {
        return await Table
            .AnyAsync(rp => rp.RoleId == roleId && rp.PermissionId == permissionId, cancellationToken);
    }

    public async Task AssignPermissionsAsync(Guid roleId, IEnumerable<Guid> permissionIds, CancellationToken cancellationToken = default)
    {
        var current = await Table.Where(rp => rp.RoleId == roleId).Select(rp => rp.PermissionId).ToListAsync(cancellationToken);
        var target = permissionIds?.ToList() ?? [];

        var toDelete = current.Except(target).ToList();
        if (toDelete.Count != 0)
            _context.RolePermissions.RemoveRange(Table.Where(rp => rp.RoleId == roleId && toDelete.Contains(rp.PermissionId)));

        var toAdd = target.Except(current).ToList();
        if (toAdd.Count != 0)
            await _context.RolePermissions.AddRangeAsync(
                toAdd.Select(permissionId => new RolePermission
                {
                    Id = Guid.NewGuid(),
                    RoleId = roleId,
                    PermissionId = permissionId
                }), cancellationToken);
    }
}

public class ApplicationUserRoleRepository : IApplicationUserRoleRepository
{
    private readonly SystemDbContext _context;

    public ApplicationUserRoleRepository(SystemDbContext context) => _context = context;

    public async Task<IList<Role>> GetRolesByUserIdAsync(Guid userId, CancellationToken cancellationToken = default)
        => await _context.UserRoles
            .Where(ur => ur.UserId == userId)
            .Join(_context.Roles, ur => ur.RoleId, r => r.Id, (ur, r) => r)
            .ToListAsync(cancellationToken);

    public async Task<IList<ApplicationUser>> GetUsersByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default)
        => await _context.UserRoles
            .Where(ur => ur.RoleId == roleId)
            .Join(_context.Users, ur => ur.UserId, u => u.Id, (ur, u) => u)
            .ToListAsync(cancellationToken);

    public async Task DeleteByUserIdAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var links = await _context.UserRoles.Where(ur => ur.UserId == userId).ToListAsync(cancellationToken);
        _context.UserRoles.RemoveRange(links);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task AssignRolesAsync(Guid userId, IEnumerable<Guid> roleIds, CancellationToken cancellationToken = default)
    {
        await DeleteByUserIdAsync(userId, cancellationToken);

        var links = roleIds.Distinct()
            .Select(roleId => new IdentityUserRole<Guid> { UserId = userId, RoleId = roleId });

        await _context.UserRoles.AddRangeAsync(links, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
    }
}