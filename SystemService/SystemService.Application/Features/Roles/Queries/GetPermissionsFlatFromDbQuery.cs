using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Queries;

public record GetPermissionsFlatFromDbQuery : IRequest<List<PermissionGroup>>;

public class GetPermissionsFlatFromDbQueryHandler
    : IRequestHandler<GetPermissionsFlatFromDbQuery, List<PermissionGroup>>
{
    private const string UncategorizedGroupName = "Chưa phân loại";
    private readonly IPermissionRepository _permissionRepository;

    public GetPermissionsFlatFromDbQueryHandler(IPermissionRepository permissionRepository)
    {
        _permissionRepository = permissionRepository;
    }

    public async Task<List<PermissionGroup>> Handle(
        GetPermissionsFlatFromDbQuery request,
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

            // Dạng phẳng: lấy nhóm cuối (leaf) của GroupPath làm tên group, không tạo subGroups phân cấp nữa.
            // Ví dụ GroupPath = "Quản lý hệ thống|Quản lý menu" => gộp vào group "Quản lý menu".
            var moduleGroupName = permission.GroupPath
                .Split('|', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
                .LastOrDefault();

            if (string.IsNullOrEmpty(moduleGroupName))
            {
                AddToUncategorizedGroup(rootGroups, permissionNode);
                continue;
            }

            if (!groupLookup.TryGetValue(moduleGroupName, out var group))
            {
                group = new PermissionGroup { Name = moduleGroupName };
                groupLookup[moduleGroupName] = group;
                rootGroups.Add(group);
            }

            group.Permissions.Add(permissionNode);
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
