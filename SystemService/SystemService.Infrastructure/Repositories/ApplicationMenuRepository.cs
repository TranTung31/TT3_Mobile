using Microsoft.EntityFrameworkCore;
using SystemService.Domain;
using SystemService.Domain.Entities.Common;
using SystemService.Domain.Entities.Enums;
using SystemService.Domain.Repositories;
using SystemService.Infrastructure.Extensions;
using SystemService.Infrastructure.Persistence;

namespace SystemService.Infrastructure.Repositories;

public class ApplicationMenuRepository : EfRepository<ApplicationMenu, Guid>, IApplicationMenuRepository
{
    public ApplicationMenuRepository(SystemDbContext context) : base(context)
    {

    }
    public async Task<bool> IsNameUniqueAsync(string name, Guid? parentId = null, Guid? idToIgnore = null, CancellationToken cancellationToken = default)
    {
        var normalizedSystemName = name.ToLower();

        var query = Table.Where(d => d.Name.ToLower() == normalizedSystemName);

        if (parentId.HasValue && parentId.Value != Guid.Empty)
            query = query.Where(d => d.ParentId == parentId);

        if (idToIgnore.HasValue && idToIgnore.Value != Guid.Empty)
            query = query.Where(d => d.Id != idToIgnore);

        bool exists = await query.AnyAsync(cancellationToken);

        return !exists;
    }

    public async Task<ApplicationMenu> GetByIdWithPermissionsAsync(Guid id, CancellationToken cancellationToken = default)
    {
        return await Table
            .Include(m => m.RequiredPermissions)
            .FirstOrDefaultAsync(m => m.Id == id, cancellationToken: cancellationToken);
    }

    public async Task<List<ApplicationMenu>> GetAllWithPermissionsAsync(CancellationToken cancellationToken = default)
    {
        return await Table
            .Include(m => m.RequiredPermissions)
            .ToListAsync(cancellationToken: cancellationToken);
    }

    //public async Task<IPagedList<ApplicationMenu>> SearchAsync(string keyword = null, int pageIndex = 0, int pageSize = int.MaxValue, CancellationToken cancellationToken = default)
    //{
    //    string sqlQuery = @"
    //    SELECT * FROM ""ApplicationMenu""
    //    START WITH ""ParentId"" IS NULL
    //    CONNECT BY PRIOR ""Id"" = ""ParentId""
    //    ORDER SIBLINGS BY ""Order""";
    //    var query = Entities.FromSqlRaw(sqlQuery);

    //    if (!string.IsNullOrWhiteSpace(keyword))
    //    {
    //        keyword = keyword.ToLower().Trim();
    //        query = query.Where(m => m.Name.ToLower().Contains(keyword));
    //    }    

    //    return await query.ToPagedListAsync(pageIndex, pageSize);
    //}

    public async Task<IPagedList<ApplicationMenu>> SearchAsync(
        string keyword = null,
        int pageIndex = 0,
        int pageSize = int.MaxValue,
        CancellationToken cancellationToken = default)
    {
        var query = Entities.AsQueryable();

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            keyword = keyword.Trim().ToLower();

            query = query.Where(x =>
                x.Name.ToLower().Contains(keyword));
        }

        query = query
            .OrderBy(x => x.ParentId)
            .ThenBy(x => x.Order);

        return await query.ToPagedListAsync(
            pageIndex,
            pageSize);
    }

    public async Task<List<ApplicationMenu>> GetLstVerticalOrHorizontalMenu(
        bool? isHorizontalMenu,
        List<string> userPermissions,
        Guid? parentId = null,
        int? type = null,
        bool isSupperAdmin = false,
        CancellationToken cancellationToken = default)
    {
        var query = Table.AsQueryable().AsNoTracking();

        if (type.HasValue)
        {
            query = query.Where(x => x.Type == (MenuHeThongType)type.Value);
        }

        // Menu ngang
        if (isHorizontalMenu.HasValue && isHorizontalMenu.Value)
        {
            // Bước 1: Query ban đầu chỉ lấy menu ngang đang active.
            // Điều kiện Type ở phía trên chỉ áp dụng cho query menu ngang này.
            query = query.Where(x => x.isHorizontal == true && x.IsActive == true);

            // Nếu là super admin thì show toàn bộ menu ngang
            if (isSupperAdmin)
            {
                return await query.OrderBy(x => x.Order).ThenBy(x => x.Id).ToListAsync(cancellationToken);
            }

            // Bước 2: Chuẩn hóa quyền của người dùng.
            // User có quyền dạng "*.View", còn RequiredPermissions của menu lưu theo nhóm quyền không có hậu tố ".View".
            var menuPermissions = new HashSet<string>();
            if (userPermissions != null)
            {
                menuPermissions = [.. userPermissions
                    .Where(p => p.EndsWith(".View"))
                    .Select(p => p[..p.LastIndexOf('.')])];
            }

            // Bước 3: Lấy danh sách menu ngang trước để giữ đúng thứ tự hiển thị sau khi lọc.
            // Include RequiredPermissions để xử lý trường hợp menu ngang không có menu dọc con.
            var horizontalMenus = await query
                .Include(x => x.RequiredPermissions)
                .OrderBy(x => x.Order)
                .ThenBy(x => x.Id)
                .ToListAsync(cancellationToken);

            // Bước 4: Lấy toàn bộ menu dọc active để duyệt cây con nhiều cấp của từng menu ngang.
            var verticalQuery = Table
                .AsNoTracking()
                .Where(x => x.IsActive == true && x.isHorizontal != true);

            var activeVerticalMenus = await verticalQuery
                .Include(x => x.RequiredPermissions)
                .ToListAsync(cancellationToken);

            // Bước 5: Gom menu dọc theo ParentId để duyệt nhanh từ menu ngang xuống các menu dọc con.
            // Menu dọc cha không gắn permission vẫn được dùng làm node trung gian để kiểm tra các cấp con sâu hơn.
            var activeVerticalMenusByParentId = activeVerticalMenus.ToLookup(x => x.ParentId);

            // Bước 6: Chỉ giữ menu ngang nếu trong toàn bộ cây menu dọc con của nó
            // có ít nhất 1 menu dọc có permission khớp với quyền người dùng.
            // Nếu menu ngang không có menu dọc con thì lọc theo permission gắn trực tiếp trên menu ngang.
            return horizontalMenus
                .Where(horizontalMenu =>
                    HasAccessibleVerticalDescendant(horizontalMenu.Id, activeVerticalMenusByParentId, menuPermissions) ||
                    (!activeVerticalMenusByParentId[horizontalMenu.Id].Any() &&
                     //horizontalMenu.RequiredPermissions.Any(permission => menuPermissions.Contains(permission.PermissionName))))
                     (!horizontalMenu.RequiredPermissions.Any() || horizontalMenu.RequiredPermissions.Any(permission => menuPermissions.Contains(permission.PermissionName)))))
                .ToList();
        }

        // Menu dọc
        if (parentId != null)
        {

            var menuPermissions = new HashSet<string>();
            if (!isSupperAdmin && userPermissions != null)
            {
                menuPermissions = [.. userPermissions
                    .Where(p => p.EndsWith(".View"))
                    .Select(p => p[..p.LastIndexOf('.')])];
            }

            var allActiveMenus = await query
            .Where(x => x.IsActive == true)
            .Include(x => x.RequiredPermissions)
            .AsNoTracking()
            .ToListAsync(cancellationToken);

            var allDescendants = new List<ApplicationMenu>();
            var queue = new Queue<Guid>();

            var directChildren = allActiveMenus.Where(x => x.ParentId == parentId && HasPermission(x, isSupperAdmin, menuPermissions));

            foreach (var child in directChildren)
            {
                allDescendants.Add(child);
                queue.Enqueue(child.Id);
            }
            while (queue.Count > 0)
            {
                var currentParentId = queue.Dequeue();
                var nextLevel = allActiveMenus.Where(x => x.ParentId == currentParentId && HasPermission(x, isSupperAdmin, menuPermissions));

                foreach (var child in nextLevel)
                {
                    allDescendants.Add(child);
                    queue.Enqueue(child.Id);
                }
            }

            return allDescendants.OrderBy(x => x.Order).ThenBy(x => x.Id).ToList();
        }

        query = query.Where(x => x.IsActive == true);
        return await query.OrderBy(x => x.Order).ThenBy(x => x.Id).ToListAsync(cancellationToken);
    }

    private bool HasPermission(ApplicationMenu menu, bool isSupperAdmin, HashSet<string> menuPermissions)
    {
        if (isSupperAdmin)
            return true;

        return !menu.RequiredPermissions.Any() || menu.RequiredPermissions.Any(p => menuPermissions.Contains(p.PermissionName));
    }

    private bool HasAccessibleVerticalDescendant(Guid horizontalMenuId, ILookup<Guid?, ApplicationMenu> activeVerticalMenusByParentId, HashSet<string> menuPermissions)
    {
        var queue = new Queue<ApplicationMenu>();

        // Bắt đầu từ các menu dọc con trực tiếp của menu ngang.
        foreach (var child in activeVerticalMenusByParentId[horizontalMenuId])
        {
            queue.Enqueue(child);
        }

        while (queue.Count > 0)
        {
            var currentMenu = queue.Dequeue();

            // Nếu menu dọc hiện tại có ít nhất 1 permission khớp thì menu ngang được hiển thị.
            //if (currentMenu.RequiredPermissions.Any(permission => menuPermissions.Contains(permission.PermissionName)))
            if (!currentMenu.RequiredPermissions.Any() || currentMenu.RequiredPermissions.Any(permission => menuPermissions.Contains(permission.PermissionName)))
            {
                return true;
            }

            // Nếu menu dọc hiện tại không có quyền hoặc không khớp quyền,
            // vẫn tiếp tục kiểm tra các menu con của nó.
            foreach (var child in activeVerticalMenusByParentId[currentMenu.Id])
            {
                queue.Enqueue(child);
            }
        }

        return false;
    }
}
