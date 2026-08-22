using AutoMapper;
using MediatR;
using SystemService.Application.Models.Menus;
using SystemService.Application.Services;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Queries;

public class GetAllMenusUserQuery : IRequest<IEnumerable<MenuUserModel>> { }

public class GetAllMenusByUserQueryHandler : IRequestHandler<GetAllMenusUserQuery, IEnumerable<MenuUserModel>>
{
    private readonly IApplicationMenuRepository _menuRepository;
    private readonly IMapper _mapper;
    private readonly ICurrentUserService _currentUser;

    public GetAllMenusByUserQueryHandler(IApplicationMenuRepository menuRepository, IMapper mapper, ICurrentUserService currentUser)
    {
        _menuRepository = menuRepository;
        _mapper = mapper;
        _currentUser = currentUser;
    }

    public async Task<IEnumerable<MenuUserModel>> Handle(GetAllMenusUserQuery request, CancellationToken cancellationToken)
    {
        // Lấy thông tin người dùng
        var userPermissions = new HashSet<string>(_currentUser.User.Permissions);
        var isAdmin = _currentUser.IsSuperAdmin(); // Giả sử IsSuperAdmin trả về bool

        // Lấy TẤT CẢ menu cùng với các permission yêu cầu
        var allMenus = await _menuRepository.GetAllWithPermissionsAsync();

        // Map sang MenuUserModel (đã chứa RequiredPermissions)
        var menuUserModels = _mapper.Map<List<MenuUserModel>>(allMenus);

        // Xây dựng cây menu ĐẦY ĐỦ
        var menuLookup = menuUserModels.ToDictionary(m => m.Id);
        var rootMenus = new List<MenuUserModel>();
        foreach (var menuItem in menuUserModels)
        {
            if (menuItem.ParentId.HasValue && menuLookup.TryGetValue(menuItem.ParentId.Value, out var parent))
            {
                parent.Children.Add(menuItem);
            }
            else
            {
                rootMenus.Add(menuItem);
            }
        }


        if (isAdmin)
        {
            SortChildrenRecursively(rootMenus);
            return rootMenus.OrderBy(m => m.Order);
        }



        // Nếu không phải admin, tiếp tục logic lọc 
        var accessibleMenus = FilterMenuTree(rootMenus, userPermissions);

        // Sắp xếp kết quả cuối cùng
        SortChildrenRecursively(accessibleMenus);
        return accessibleMenus.OrderBy(m => m.Order);
    }

    /// <summary>
    /// Hàm đệ quy để lọc cây menu. Nó duyệt từ dưới lên (post-order traversal).
    /// </summary>
    private List<MenuUserModel> FilterMenuTree(List<MenuUserModel> menus, HashSet<string> userPermissions)
    {
        var accessibleMenus = new List<MenuUserModel>();

        foreach (var menu in menus)
        {
            // Lọc danh sách con của menu hiện tại trước
            menu.Children = FilterMenuTree(menu.Children, userPermissions);

            // Kiểm tra xem menu hiện tại có nên được giữ lại hay không
            bool hasVisibleChildren = menu.Children.Any();

            // Một menu được phép truy cập trực tiếp nếu:
            // - Nó không yêu cầu quyền nào, HOẶC
            // - Người dùng có ÍT NHẤT MỘT trong các quyền mà nó yêu cầu.
            bool hasDirectPermission = !menu.RequiredPermissions.Any() ||
                                       menu.RequiredPermissions.Any(userPermissions.Contains);

            // Giữ lại menu nếu nó có con hiển thị HOẶC người dùng có quyền truy cập trực tiếp
            if (hasVisibleChildren || hasDirectPermission)
            {
                accessibleMenus.Add(menu);
            }
        }

        return accessibleMenus;
    }

    private void SortChildrenRecursively(List<MenuUserModel> menus)
    {
        foreach (var menu in menus)
        {
            if (menu.Children.Any())
            {
                // Sắp xếp danh sách con của menu hiện tại
                menu.Children = menu.Children.OrderBy(c => c.Order).ToList();
                // Gọi đệ quy để sắp xếp các cấp tiếp theo
                SortChildrenRecursively(menu.Children);
            }
        }
    }
}

