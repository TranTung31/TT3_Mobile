using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Commands;

//public record CreateRoleCommand(RoleModel Model) : IRequest<bool>;
//public class CreateRoleCommandHandler : IRequestHandler<CreateRoleCommand, bool>
//{
//    private readonly IPermissionSyncService _permissionSyncService;
//    public CreateRoleCommandHandler(IPermissionSyncService permissionSyncService)
//    {
//        _permissionSyncService = permissionSyncService;
//    }
//    public async Task<bool> Handle(CreateRoleCommand request, CancellationToken cancellationToken)
//    {
//        // Tạo role mới - lưu cả DB và Keycloak
//        var role = await _permissionSyncService.CreateRoleAsync(
//            request.Model.Name,
//            request.Model.Description,
//            cancellationToken);

//        // Gán permissions nếu có (chỉ khi RoleType = "group" và có permissions)
//        if (request.Model.RoleType == "group" && request.Model.Permissions != null && request.Model.Permissions.Count > 0)
//        {
//            await _permissionSyncService.AssignPermissionsToRoleByNamesAsync(
//                role.Id,
//                request.Model.Permissions,
//                cancellationToken);
//        }

//        return true;
//    }
//}
