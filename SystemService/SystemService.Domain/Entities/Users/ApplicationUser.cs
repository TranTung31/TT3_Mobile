using Microsoft.AspNetCore.Identity;
using SystemService.Domain.Entities.Auth;

namespace SystemService.Domain.Entities.Users;

public class ApplicationUser : IdentityUser<Guid>
{
    public string FullName { get; set; } = string.Empty;
    public Guid? DonViId { get; set; }
    public bool IsSuperAdmin { get; set; }
    public bool IsDeleted { get; set; }

    // IdentityUser không có 2 trường audit này (đang nằm ở BaseEntity/ShadowBaseEntity),
    public DateTime CreatedOnUtc { get; set; }
    public DateTime? UpdatedOnUtc { get; set; }

    public virtual ICollection<IdentityUserRole<Guid>> UserRoles { get; set; } = new List<IdentityUserRole<Guid>>();

    public virtual ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();
}
