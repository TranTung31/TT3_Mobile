using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Queries;

public record GetPermissionsAsTreeFromDbQuery : IRequest<List<PermissionGroup>>;

public class GetPermissionsAsTreeFromDbQueryHandler
    : IRequestHandler<GetPermissionsAsTreeFromDbQuery, List<PermissionGroup>>
{
    private const string UncategorizedGroupName = "Chưa phân loại";
    private readonly IPermissionRepository _permissionRepository;

    public GetPermissionsAsTreeFromDbQueryHandler(IPermissionRepository permissionRepository)
    {
        _permissionRepository = permissionRepository;
    }

    public async Task<List<PermissionGroup>> Handle(
        GetPermissionsAsTreeFromDbQuery request,
        CancellationToken cancellationToken)
    {
        var allPermissions = await _permissionRepository.GetAllActiveAsync(cancellationToken);
        var rootGroups = new List<PermissionGroup>();
        var groupLookup = new Dictionary<string, PermissionGroup>();

        foreach (var permission in allPermissions.OrderBy(p => p.Name))
        {
            var permissionNode = new PermissionNode
            {
                Id = permission.Id,
                Permission = permission.Name,
                Name = !string.IsNullOrEmpty(permission.Description)
                    ? permission.Description
                    : permission.Name
            };

            if (string.IsNullOrWhiteSpace(permission.GroupPath))
            {
                AddToUncategorizedGroup(rootGroups, permissionNode);
                continue;
            }

            var groupPath = permission.GroupPath.Split(
                '|',
                StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

            if (groupPath.Length == 0)
            {
                AddToUncategorizedGroup(rootGroups, permissionNode);
                continue;
            }

            PermissionGroup currentParentGroup = null;
            var currentPathKey = string.Empty;

            foreach (var part in groupPath)
            {
                currentPathKey = string.IsNullOrEmpty(currentPathKey)
                    ? part
                    : $"{currentPathKey}|{part}";

                if (!groupLookup.TryGetValue(currentPathKey, out var group))
                {
                    group = new PermissionGroup { Name = part };
                    groupLookup[currentPathKey] = group;

                    if (currentParentGroup is null)
                    {
                        rootGroups.Add(group);
                    }
                    else
                    {
                        currentParentGroup.SubGroups.Add(group);
                    }
                }

                currentParentGroup = group;
            }

            currentParentGroup.Permissions.Add(permissionNode);
        }

        return rootGroups;
    }

    private static void AddToUncategorizedGroup(
        List<PermissionGroup> rootGroups,
        PermissionNode permissionNode)
    {
        var uncategorizedGroup = rootGroups.FirstOrDefault(g => g.Name == UncategorizedGroupName);
        if (uncategorizedGroup is null)
        {
            uncategorizedGroup = new PermissionGroup { Name = UncategorizedGroupName };
            rootGroups.Add(uncategorizedGroup);
        }

        uncategorizedGroup.Permissions.Add(permissionNode);
    }
}
