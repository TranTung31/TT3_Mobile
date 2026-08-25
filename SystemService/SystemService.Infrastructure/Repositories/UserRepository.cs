using Microsoft.EntityFrameworkCore;
using SystemService.Domain;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;
using SystemService.Infrastructure.Extensions;
using SystemService.Infrastructure.Persistence;

namespace SystemService.Infrastructure.Repositories;

public class UserRepository : IUserRepository
{
    private readonly SystemDbContext _context;

    public UserRepository(SystemDbContext context) => _context = context;

    public IQueryable<ApplicationUser> Table => _context.Users.AsQueryable();

    public async Task<IList<ApplicationUser>> GetAllAsync(
        Func<IQueryable<ApplicationUser>, IQueryable<ApplicationUser>>? func = null,
        CancellationToken cancellationToken = default)
    {
        var query = Table.AsQueryable();
        if (func != null)
            query = func(query);
        return await query.ToListAsync(cancellationToken);
    }

    public async Task<ApplicationUser?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default)
        => await Table.FirstOrDefaultAsync(u => u.Id == id && !u.IsDeleted, cancellationToken);

    public async Task<IPagedList<ApplicationUser>> SearchAsync(
        string keyword = null,
        string userName = null,
        string fullName = null,
        string email = null,
        bool? isEnabled = null,
        Guid? donViId = null,
        int pageIndex = 0,
        int pageSize = int.MaxValue,
        CancellationToken cancellationToken = default)
    {
        var query = Table.Where(c => !c.IsDeleted);

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            keyword = keyword.ToLower();
            query = query.Where(u =>
                (u.UserName != null && u.UserName.ToLower().Contains(keyword)) ||
                (u.FullName != null && u.FullName.ToLower().Contains(keyword)) ||
                (u.Email != null && u.Email.ToLower().Contains(keyword)));
        }

        if (!string.IsNullOrWhiteSpace(userName))
            query = query.Where(u => u.UserName != null && u.UserName.Contains(userName));

        if (!string.IsNullOrWhiteSpace(fullName))
            query = query.Where(u => u.FullName != null && u.FullName.Contains(fullName));

        if (!string.IsNullOrWhiteSpace(email))
            query = query.Where(u => u.Email != null && u.Email.Contains(email));

        if (isEnabled.HasValue)
        {
            var now = DateTimeOffset.UtcNow;
            query = isEnabled.Value
                ? query.Where(u => u.LockoutEnd == null || u.LockoutEnd <= now)
                : query.Where(u => u.LockoutEnd != null && u.LockoutEnd > now);
        }

        if (donViId.HasValue)
            query = query.Where(u => u.DonViId == donViId.Value);

        return await query.OrderBy(u => u.UserName).ToPagedListAsync(pageIndex, pageSize);
    }

    /// <summary>
    /// Hàm kiểm tra UserName có tồn tại trong DB hay không.
    /// </summary>
    public async Task<bool> BeUniqueUserName(string userName, Guid? currentId = null, CancellationToken cancellationToken = default)
    {
        var user = await Table.FirstOrDefaultAsync(c => c.UserName == userName, cancellationToken: cancellationToken);

        return user == null || user.Id == currentId;

    }

    /// <summary>
    /// Hàm kiểm tra Email có tồn tại trong DB hay không.
    /// </summary>
    public async Task<bool> BeUniqueEmail(string email, Guid? currentId = null, CancellationToken cancellationToken = default)
    {
        var user = await Table.FirstOrDefaultAsync(c => c.Email == email, cancellationToken: cancellationToken);

        return user == null || user.Id == currentId;
    }

    public async Task<Guid> GetDonViIdByIdAsync(Guid userId)
    {
        var user = await Table.FirstOrDefaultAsync(c => c.Id == userId);

        return user.DonViId.Value;
    }
}
