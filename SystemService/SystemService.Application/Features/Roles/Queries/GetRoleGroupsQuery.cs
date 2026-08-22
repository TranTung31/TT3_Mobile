using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Queries;

//public record GetRoleGroupsQuery : IRequest<IEnumerable<RoleItemModel>>;
//public class GetRoleGroupsQueryHandler : IRequestHandler<GetRoleGroupsQuery, IEnumerable<RoleItemModel>>
//{
//    private readonly IKeycloakAdminClient _keycloakAdminClient;
//    public GetRoleGroupsQueryHandler(IKeycloakAdminClient keycloakAdminClient)
//    {
//        _keycloakAdminClient = keycloakAdminClient;
//    }
//    public async Task<IEnumerable<RoleItemModel>> Handle(GetRoleGroupsQuery request, CancellationToken cancellationToken)
//    {
//        // Lấy tất cả các vai trò (với page size rất lớn để đảm bảo lấy hết)
//        var allRoles = await _keycloakAdminClient.GetRealmRolesAsync(cancellationToken: cancellationToken);
//        // Lọc ra những vai trò là "Nhóm Quyền"
//        var groupRoles = allRoles
//            .Where(r => r.Attributes != null &&
//                        r.Attributes.TryGetValue("role_type", out var type) &&
//                        type.Contains("group"))
//            .Select(r => new RoleItemModel
//            {
//                Id = r.Id,
//                Name = r.Name,
//                Description = r.Description
//            })
//            .ToList();
//        return groupRoles;
//    }
//}
