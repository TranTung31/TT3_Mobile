using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Commands;

//public record UpdateRoleCommand(string OriginalName, RoleModel Model) : IRequest<bool>;
//public class UpdateRoleCommandHandler : IRequestHandler<UpdateRoleCommand, bool>
//{
//    private readonly IPermissionSyncService _permissionSyncService;
//    public UpdateRoleCommandHandler(IPermissionSyncService permissionSyncService)
//    {
//        _permissionSyncService = permissionSyncService;
//    }
//    public async Task<bool> Handle(UpdateRoleCommand request, CancellationToken cancellationToken)
//    {
//        // Lấy role từ DB để có ID
//        var role = await _permissionSyncService.GetRoleByNameAsync(request.OriginalName, cancellationToken);
//        if (role == null)
//            throw new InvalidOperationException($"Role '{request.OriginalName}' not found");

//        // Xử lý permissions:
//        // - permissions = null hoặc empty list với RoleType != "group": không cập nhật permissions
//        // - permissions có giá trị: Cập nhật permissions trên DB và Keycloak
//        List<string>? permissionsToUpdate = null;
//        if (request.Model.RoleType == "group")
//        {
//            permissionsToUpdate = request.Model.Permissions;
//        }

//        // Cập nhật role kèm permissions (có thể null)
//        await _permissionSyncService.UpdateRoleWithPermissionsAsync(
//            role.Id,
//            request.Model.Name,
//            request.Model.Description,
//            permissionsToUpdate,
//            request.OriginalName,
//            cancellationToken);

//        return true;
//    }
//}