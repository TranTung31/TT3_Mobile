using AutoMapper;
using MediatR;
using SystemService.Application.Models.Menus;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Queries;

public class GetAllMenusQuery : IRequest<IEnumerable<MenuModel>>
{
}

public class GetAllMenusQueryHandler : IRequestHandler<GetAllMenusQuery, IEnumerable<MenuModel>>
{
    private readonly IApplicationMenuRepository _menuRepository;
    private readonly IMapper _mapper;

    public GetAllMenusQueryHandler(IApplicationMenuRepository menuRepository, IMapper mapper)
    {
        _menuRepository = menuRepository;
        _mapper = mapper;
    }

    public async Task<IEnumerable<MenuModel>> Handle(GetAllMenusQuery request, CancellationToken cancellationToken)
    {
        //  Lấy danh sách phẳng tất cả menu từ database
        var allMenus = await _menuRepository.GetAllAsync(query => { return query; });

        //  Map tất cả các entity sang MenuModel.
        // Sử dụng ToList() để có một danh sách cụ thể để thao tác.
        var menuModels = _mapper.Map<List<MenuModel>>(allMenus);

        // Tạo một Dictionary để tra cứu nhanh các menu theo Id.
        // Đây là bước quan trọng nhất để tối ưu hiệu năng.
        var menuLookup = menuModels.ToDictionary(m => m.Id);

        //Tạo danh sách để chứa các menu gốc (cấp cao nhất).
        var rootMenus = new List<MenuModel>();

        //Duyệt qua danh sách phẳng để xây dựng cấu trúc cây.
        foreach (var menuItem in menuModels)
        {
            if (menuItem.ParentId.HasValue && menuLookup.TryGetValue(menuItem.ParentId.Value, out var parent))
            {
                // Nếu menu hiện tại có ParentId và tìm thấy menu cha trong Dictionary,
                // thì thêm nó vào danh sách Children của menu cha.
                parent.Children.Add(menuItem);
            }
            else
            {
                // Nếu không có ParentId, đây là một menu gốc.
                rootMenus.Add(menuItem);
            }
        }

        // (Tùy chọn) Bước 6: Sắp xếp các menu ở mỗi cấp theo thứ tự.
        // Cần một hàm đệ quy để sắp xếp tất cả các cấp.
        SortChildrenRecursively(rootMenus);

        // Bước 7: Trả về danh sách các menu gốc đã được phân cấp và sắp xếp.
        return rootMenus.OrderBy(m => m.Order);
    }

    private void SortChildrenRecursively(List<MenuModel> menus)
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
