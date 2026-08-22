using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Entities.Users;

namespace SystemService.Infrastructure.Persistence.Configurations.Authorization;

public class ApplicationUserRoleConfiguration : IEntityTypeConfiguration<IdentityUserRole<Guid>>
{
    public void Configure(EntityTypeBuilder<IdentityUserRole<Guid>> builder)
    {
        builder.ToTable("ApplicationUserRole");

        // PK composite (UserId, RoleId) do Identity thiết lập sẵn — khai báo lại cho rõ ràng
        builder.HasKey(ur => new { ur.UserId, ur.RoleId });

        // Nối navigation UserRoles (khai báo trên ApplicationUser / Role) với relationship
        // chuẩn của Identity. Nếu không khai báo, EF tự suy ra relationship mới và sinh
        // FK shadow (UserId1 / RoleId1) trong bảng.
        builder.HasOne<ApplicationUser>()
               .WithMany(u => u.UserRoles)
               .HasForeignKey(ur => ur.UserId)
               .IsRequired();

        builder.HasOne<Role>()
               .WithMany(r => r.UserRoles)
               .HasForeignKey(ur => ur.RoleId)
               .IsRequired();
    }
}
