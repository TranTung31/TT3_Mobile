using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Queries;

public record GetRoleByNameFromDbQuery(Guid Id) : IRequest<RoleDetailResponseModel>;

public class GetRoleByNameFromDbQueryHandler
    : IRequestHandler<GetRoleByNameFromDbQuery, RoleDetailResponseModel>
{
    private readonly IRoleRepository _roleRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;

    public GetRoleByNameFromDbQueryHandler(
        IRoleRepository roleRepository,
        IRolePermissionRepository rolePermissionRepository)
    {
        _roleRepository = roleRepository;
        _rolePermissionRepository = rolePermissionRepository;
    }

    public async Task<RoleDetailResponseModel> Handle(
        GetRoleByNameFromDbQuery request,
        CancellationToken cancellationToken)
    {
        var role = await _roleRepository.GetByIdAsync(request.Id);

        if (role == null)
            return null;

        var permissions = await _rolePermissionRepository.GetPermissionsByRoleIdAsync(
            role.Id,
            cancellationToken);

        return new RoleDetailResponseModel
        {
            Id = role.Id,
            Name = role.Name,
            Description = role.Description ?? "",
            Permissions = [.. permissions.Select(permission => new PermissionNode()
            { 
                Id = permission.Id,
                Permission = permission.Name,
                Name = !string.IsNullOrEmpty(permission.Description)
                    ? permission.Description
                    : permission.Name
            })]
        };
    }
}
