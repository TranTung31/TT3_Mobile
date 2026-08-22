using MediatR;
using SystemService.Application.Models.Users;
using SystemService.Application.Services;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Queries;

public record GetCurrentUserPermissionsQuery : IRequest<UserPermissionsModel>;

public class GetCurrentUserPermissionsQueryHandler : IRequestHandler<GetCurrentUserPermissionsQuery, UserPermissionsModel>
{
    private readonly ICurrentUserService _currentUserService;
    private readonly IApplicationUserRoleRepository _userRoleRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;

    public GetCurrentUserPermissionsQueryHandler(
        ICurrentUserService currentUserService,
        IApplicationUserRoleRepository userRoleRepository,
        IRolePermissionRepository rolePermissionRepository)
    {
        _currentUserService = currentUserService;
        _userRoleRepository = userRoleRepository;
        _rolePermissionRepository = rolePermissionRepository;
    }

    public async Task<UserPermissionsModel> Handle(GetCurrentUserPermissionsQuery request, CancellationToken cancellationToken)
    {
        var userId = _currentUserService.GetUserId();
        if (userId == null)
            return new UserPermissionsModel();

        // Lấy roles từ local DB
        var roles = await _userRoleRepository.GetRolesByUserIdAsync(userId.Value, cancellationToken);
        var roleNames = roles.Select(r => r.Name).ToList();

        // Lấy permissions từ tất cả các role
        var allPermissions = new HashSet<string>();
        foreach (var role in roles)
        {
            var permissions = await _rolePermissionRepository.GetPermissionsByRoleIdAsync(role.Id, cancellationToken);
            foreach (var permission in permissions)
            {
                allPermissions.Add(permission.Name);
            }
        }

        return new UserPermissionsModel
        {
            UserId = userId.Value,
            Roles = roleNames,
            Permissions = allPermissions.ToList()
        };
    }
}