using SystemService.Domain.Entities.Users;

namespace SystemService.Domain.Entities.Auth;

/// <summary>
/// Refresh token cho JWT — bảng tự định nghĩa (giống Permission/RolePermission),
/// nằm cạnh ASP.NET Identity chứ không phải khái niệm của Identity.
/// </summary>
public class RefreshToken : BaseEntity<Guid>
{
    public Guid UserId { get; set; }
    public virtual ApplicationUser User { get; set; } = null!;

    /// <summary>Hash SHA-256 của chuỗi token trả cho client (không lưu plaintext).</summary>
    public string TokenHash { get; set; } = string.Empty;

    public DateTime ExpiresAtUtc { get; set; }

    /// <summary>Thời điểm thu hồi (null = còn hiệu lực).</summary>
    public DateTime? RevokedAtUtc { get; set; }

    public bool IsActive => RevokedAtUtc == null && ExpiresAtUtc > DateTime.UtcNow;
}
