using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Queries;

//public record GetPermissionsQuery : IRequest<IEnumerable<RoleItemModel>>;
//public class GetPermissionsQueryHandler : IRequestHandler<GetPermissionsQuery, IEnumerable<RoleItemModel>>
//{
//    private readonly IKeycloakAdminClient _keycloakAdminClient;
//    public GetPermissionsQueryHandler(IKeycloakAdminClient keycloakAdminClient)
//    {
//        _keycloakAdminClient = keycloakAdminClient;
//    }
//    public async Task<IEnumerable<RoleItemModel>> Handle(GetPermissionsQuery request, CancellationToken cancellationToken)
//    {
//        var allRoles = await _keycloakAdminClient.GetRealmRolesAsync(null, 0, int.MaxValue, cancellationToken);
//        // Lọc ra những vai trò là "Quyền"
//        var permissionRoles = allRoles
//            .Where(r => r.Attributes == null ||
//                        !r.Attributes.ContainsKey("role_type") ||
//                        r.Attributes["role_type"].Contains("permission"))
//            .Select(r => new RoleItemModel
//            {
//                Id = r.Id,
//                Name = r.Name,
//                Description = r.Description
//            })
//            .ToList();
//        return permissionRoles;
//    }
//}
