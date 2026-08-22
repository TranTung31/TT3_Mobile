using MediatR;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Commands;

//public record DeleteRoleCommand(string Name) : IRequest<bool>;

//public class DeleteRoleCommandHandler : IRequestHandler<DeleteRoleCommand, bool>
//{
//    private readonly IPermissionSyncService _permissionSyncService;
//    public DeleteRoleCommandHandler(IPermissionSyncService permissionSyncService)
//    {
//        _permissionSyncService = permissionSyncService;
//    }
//    public async Task<bool> Handle(DeleteRoleCommand request, CancellationToken cancellationToken)
//    {
//        // Xóa role - xóa cả DB và Keycloak
//        await _permissionSyncService.DeleteRoleByNameAsync(request.Name, cancellationToken);
//        return true;
//    }
//}
