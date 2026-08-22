using SystemService.Domain.Entities.Common;

namespace SystemService.Domain.Repositories;

public interface IApplicationMenuRepository : IRepository<ApplicationMenu, Guid>
{
    Task<bool> IsNameUniqueAsync(string name, Guid? parentId = null, Guid? idToIgnore = null, CancellationToken cancellationToken = default);

    Task<ApplicationMenu> GetByIdWithPermissionsAsync(Guid id, CancellationToken cancellationToken = default);

    Task<List<ApplicationMenu>> GetAllWithPermissionsAsync(CancellationToken cancellationToken = default);

    Task<IPagedList<ApplicationMenu>> SearchAsync(string keyword = null, int pageIndex = 0, int pageSize = int.MaxValue, CancellationToken cancellationToken = default);

    Task<List<ApplicationMenu>> GetLstVerticalOrHorizontalMenu(bool? isHorizontalMenu, List<string> userPermissions, Guid? parentId = null, int? type = null, bool isSupperAdmin = false, CancellationToken cancellationToken = default);
}
