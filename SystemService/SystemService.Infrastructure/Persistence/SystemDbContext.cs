using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.Extensions.Logging;
using System.Reflection;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Entities.Catalog;
using SystemService.Domain.Entities.Common;
using SystemService.Domain.Entities.Users;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;

namespace SystemService.Infrastructure.Persistence;

public class SystemDbContext : IdentityDbContext<ApplicationUser, Role, Guid>
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<SystemDbContext> _logger;

    public SystemDbContext(DbContextOptions<SystemDbContext> options,
        IServiceProvider serviceProvider,
        ILogger<SystemDbContext> logger) : base(options)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    public DbSet<ApplicationMenu> ApplicationMenus { get; set; }
    public DbSet<MenuPermission> MenuPermissions { get; set; }
    public DbSet<DmDonVi> DmDonVi { get; set; }
    public DbSet<Permission> Permissions { get; set; }
    public DbSet<RolePermission> RolePermissions { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Tự động áp dụng tất cả các cấu hình entity (IEntityTypeConfiguration)
        modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
    }

    public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        ApplyAuditFields();
        return await base.SaveChangesAsync(cancellationToken);
    }

    public override int SaveChanges()
    {
        ApplyAuditFields();
        return base.SaveChanges();
    }

    /// <summary>
    /// Tự động gán CreatedOnUtc khi thêm mới, UpdatedOnUtc khi cập nhật
    /// cho mọi entity có cột audit (ShadowBaseEntity, ApplicationUser, Role, ...).
    /// </summary>
    private void ApplyAuditFields()
    {
        var now = DateTime.UtcNow;

        foreach (var entry in ChangeTracker.Entries())
        {
            if (entry.State == EntityState.Added)
                SetAuditProperty(entry, "CreatedOnUtc", now);

            if (entry.State == EntityState.Modified)
                SetAuditProperty(entry, "UpdatedOnUtc", now);
        }
    }

    private static void SetAuditProperty(EntityEntry entry, string propertyName, DateTime value)
    {
        if (entry.Metadata.FindProperty(propertyName) is not null)
            entry.Property(propertyName).CurrentValue = value;
    }
}
