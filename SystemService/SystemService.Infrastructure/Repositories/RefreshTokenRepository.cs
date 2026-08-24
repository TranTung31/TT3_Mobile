using Microsoft.EntityFrameworkCore;
using SystemService.Domain.Entities.Auth;
using SystemService.Domain.Repositories;
using SystemService.Infrastructure.Persistence;

namespace SystemService.Infrastructure.Repositories;

public class RefreshTokenRepository : IRefreshTokenRepository
{
    private readonly SystemDbContext _context;

    public RefreshTokenRepository(SystemDbContext context) => _context = context;

    public Task<RefreshToken?> GetByTokenHashAsync(string tokenHash, CancellationToken cancellationToken = default)
        => _context.Set<RefreshToken>().FirstOrDefaultAsync(x => x.TokenHash == tokenHash, cancellationToken);

    public async Task<IList<RefreshToken>> GetActiveByUserIdAsync(Guid userId, CancellationToken cancellationToken = default)
        => await _context.Set<RefreshToken>()
            .Where(x => x.UserId == userId && x.RevokedAtUtc == null && x.ExpiresAtUtc > DateTime.UtcNow)
            .ToListAsync(cancellationToken);

    public async Task InsertAsync(RefreshToken entity, CancellationToken cancellationToken = default)
        => await _context.Set<RefreshToken>().AddAsync(entity, cancellationToken);

    public void Revoke(RefreshToken entity)
    {
        entity.RevokedAtUtc = DateTime.UtcNow;
    }

    public Task<int> DeleteExpiredAsync(CancellationToken cancellationToken = default)
        => _context.Set<RefreshToken>()
            .Where(x => x.ExpiresAtUtc <= DateTime.UtcNow)
            .ExecuteDeleteAsync(cancellationToken);

    public Task<int> DeleteRevokedAsync(CancellationToken cancellationToken = default)
        => _context.Set<RefreshToken>()
            .Where(x => x.RevokedAtUtc != null)
            .ExecuteDeleteAsync(cancellationToken);
}
