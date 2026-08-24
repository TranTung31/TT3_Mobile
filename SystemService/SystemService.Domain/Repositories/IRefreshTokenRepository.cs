using SystemService.Domain.Entities.Auth;

namespace SystemService.Domain.Repositories;

public interface IRefreshTokenRepository
{
    Task<RefreshToken?> GetByTokenHashAsync(string tokenHash, CancellationToken cancellationToken = default);

    /// <summary>
    /// Danh sách refresh token còn hiệu lực của một user (dùng khi logout / đổi mật khẩu).
    /// </summary>
    Task<IList<RefreshToken>> GetActiveByUserIdAsync(Guid userId, CancellationToken cancellationToken = default);

    Task InsertAsync(RefreshToken entity, CancellationToken cancellationToken = default);

    /// <summary>
    /// Đánh dấu thu hồi (chưa SaveChanges — handler tự gọi IUnitOfWork).
    /// </summary>
    void Revoke(RefreshToken entity);

    /// <summary>
    /// Xoá token hết hạn (dọn dẹp định kỳ hoặc gọi lúc refresh).
    /// </summary>
    Task<int> DeleteExpiredAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Xoá các token đã bị thu hồi (revoke) — không dùng được nữa — để tránh bảng RefreshToken phình to.
    /// </summary>
    Task<int> DeleteRevokedAsync(CancellationToken cancellationToken = default);
}
