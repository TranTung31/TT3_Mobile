using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Queries;

//public record GetPermissionsAsTreeQuery : IRequest<List<PermissionGroup>>;
//public class GetPermissionsAsTreeQueryHandler : IRequestHandler<GetPermissionsAsTreeQuery, List<PermissionGroup>>
//{
//    private readonly IKeycloakAdminClient _keycloakAdminClient;
//    public GetPermissionsAsTreeQueryHandler(IKeycloakAdminClient keycloakAdminClient)
//    {
//        _keycloakAdminClient = keycloakAdminClient;
//    }
//    public async Task<List<PermissionGroup>> Handle(GetPermissionsAsTreeQuery request, CancellationToken cancellationToken)
//    {
//        var allPermissions = await _keycloakAdminClient.GetClientRolesAsync(cancellationToken);
//        var rootGroups = new List<PermissionGroup>();

//        var groupLookup = new Dictionary<string, PermissionGroup>();
//        foreach (var permission in allPermissions.OrderBy(p => p.Name))
//        {
//            var permissionNode = new PermissionNode
//            {
//                Permission = permission.Name,
//                Name = !string.IsNullOrEmpty(permission.Description) ? permission.Description : permission.Name
//            };
//            var groupPathString = permission.Attributes?.ContainsKey("group_path") == true
//                ? permission.Attributes["group_path"].FirstOrDefault()
//                : null;
//            if (string.IsNullOrEmpty(groupPathString))
//            {
//                var uncategorizedGroup = rootGroups.FirstOrDefault(g => g.Name == "Chưa phân loại");
//                if (uncategorizedGroup == null)
//                {
//                    uncategorizedGroup = new PermissionGroup { Name = "Chưa phân loại" };
//                    rootGroups.Add(uncategorizedGroup);
//                }
//                uncategorizedGroup.Permissions.Add(permissionNode);
//                continue;
//            }
//            var groupPath = groupPathString.Split('|');
//            PermissionGroup currentParentGroup = null;
//            string currentPathKey = "";
//            for (int i = 0; i < groupPath.Length; i++)
//            {
//                var part = groupPath[i];
//                var oldPathKey = currentPathKey;
//                currentPathKey += (i > 0 ? "|" : "") + part;
//                if (!groupLookup.TryGetValue(currentPathKey, out var group))
//                {
//                    group = new PermissionGroup { Name = part };
//                    groupLookup[currentPathKey] = group;
//                    if (currentParentGroup == null) 
//                    {
//                        rootGroups.Add(group);
//                    }
//                    else 
//                    {
//                        currentParentGroup.SubGroups.Add(group);
//                    }
//                }
//                currentParentGroup = group;
//            }
//            if (currentParentGroup != null)
//            {
//                currentParentGroup.Permissions.Add(permissionNode);
//            }
//        }
//        return rootGroups;
//    }
//}
