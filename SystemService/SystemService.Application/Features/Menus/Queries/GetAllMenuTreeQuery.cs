using AutoMapper;
using MediatR;
using Shared.Redis.Permissions;
using SystemService.Application.Models.Menus;
using SystemService.Application.Services;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Queries;

public record GetAllMenuTreeQuery(MenuTreeSearchModel SearchModel)
    : IRequest<List<MenuTreeItemModel>>;

public class GetAllMenuTreeQueryHandler : IRequestHandler<GetAllMenuTreeQuery, List<MenuTreeItemModel>>
{
    private readonly IApplicationMenuRepository _repository;
    private readonly IMapper _mapper;
    private readonly ICurrentUserService _currentUserService;
    private readonly IApplicationUserRoleRepository _applicationUserRoleRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUserPermissionCacheService _userPermissionCacheService;

    public GetAllMenuTreeQueryHandler(
        IApplicationMenuRepository repository,
        IMapper mapper,
        ICurrentUserService currentUserService,
        IApplicationUserRoleRepository applicationUserRoleRepository, IRolePermissionRepository rolePermissionRepository, IUserPermissionCacheService userPermissionCacheService)
    {
        _repository = repository;
        _mapper = mapper;
        _currentUserService = currentUserService;
        _applicationUserRoleRepository = applicationUserRoleRepository;
        _rolePermissionRepository = rolePermissionRepository;
        _userPermissionCacheService = userPermissionCacheService;
    }

    public async Task<List<MenuTreeItemModel>> Handle(GetAllMenuTreeQuery request, CancellationToken cancellationToken)
    {
        var isSupperAdmin = _currentUserService.IsSuperAdmin();
        var userId = _currentUserService.GetUserId();
        var lstPermission = _currentUserService.User?.Permissions?.ToList();
        var searchModel = request.SearchModel;

        //IReadOnlyCollection<string> effectivePermissions = null;
        //var lstPermission = new List<string>();

        //if (userId != null && userId.HasValue)
        //{
        //    try
        //    {
        //        // Đầu tiên cố gắng lấy permissions từ Redis cache
        //        effectivePermissions = await _userPermissionCacheService.GetPermissionsAsync(
        //            userId.Value,
        //            cancellationToken);
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine($"Có lỗi trong quá trình lấy permission từ Redis. UserId: {userId}. Error: {ex.Message}");
        //    }

        //    if (effectivePermissions == null)
        //    {
        //        // Lấy danh sách quyền từ DB
        //        var permissions = await LoadUserPermissionsFromDbAsync(userId.Value, cancellationToken);
        //        if (permissions != null)
        //        {
        //            lstPermission = permissions.ToList();
        //            try
        //            {
        //                await _userPermissionCacheService.SetPermissionsAsync(
        //                    userId.Value,
        //                    permissions,
        //                    cancellationToken: cancellationToken);
        //            }
        //            catch (Exception ex)
        //            {
        //                Console.WriteLine($"Có lỗi trong quá trình lưu permission vào Redis. UserId: {userId}. Error: {ex.Message}");
        //            }
        //        }
        //    } else
        //    {
        //        var userPermissions = effectivePermissions
        //                    .Where(static permission => !string.IsNullOrWhiteSpace(permission))
        //                    .Select(static permission => permission.Trim())
        //                    .ToHashSet(StringComparer.OrdinalIgnoreCase);
        //        lstPermission = userPermissions.ToList();
        //    }
        //}

        var lstMenu = await _repository.GetLstVerticalOrHorizontalMenu(
                isHorizontalMenu: searchModel.IsHorizontalMenu,
                userPermissions: lstPermission,
                parentId: searchModel.ParentId,
                type: searchModel.Type,
                isSupperAdmin: isSupperAdmin,
                cancellationToken: cancellationToken
            );

        var menuItems = _mapper.Map<List<MenuTreeItemModel>>(lstMenu);

        if (searchModel.IsHorizontalMenu == false && searchModel.ParentId != null)
        {
            //menuItems = menuItems.Where(x => x.ParentId == searchModel.ParentId).ToList();
            menuItems = BuildMenuHierarchy(menuItems, searchModel.ParentId);
        }

        return menuItems;
    }

    private List<MenuTreeItemModel> BuildMenuHierarchy(List<MenuTreeItemModel> flatList, Guid? menuId)
    {
        var lookup = flatList.ToLookup(x => x.ParentId);

        foreach (var item in flatList)
        {
            item.Children = lookup[item.Id].OrderBy(x => x.Order).ToList();
        }

        return lookup[menuId].OrderBy(x => x.Order).ToList();
    }

    private async Task<IReadOnlyCollection<string>> LoadUserPermissionsFromDbAsync(
        Guid userId,
        CancellationToken cancellationToken)
    {
        var roles = await _applicationUserRoleRepository.GetRolesByUserIdAsync(userId, cancellationToken);
        var permissions = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var role in roles)
        {
            var rolePermissions = await _rolePermissionRepository.GetPermissionsByRoleIdAsync(role.Id, cancellationToken);
            foreach (var permission in rolePermissions)
            {
                if (!string.IsNullOrWhiteSpace(permission.Name))
                {
                    permissions.Add(permission.Name);
                }
            }
        }

        return permissions.ToArray();
    }
}
