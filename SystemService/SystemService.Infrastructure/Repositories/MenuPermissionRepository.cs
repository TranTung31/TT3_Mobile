using SystemService.Domain.Entities.Common;
using SystemService.Domain.Repositories;
using SystemService.Infrastructure.Persistence;

namespace SystemService.Infrastructure.Repositories;

public class MenuPermissionRepository : EfRepository<MenuPermission, Guid>, IMenuPermissionRepository
{
    public MenuPermissionRepository(SystemDbContext context) : base(context)
    {

    }
}
