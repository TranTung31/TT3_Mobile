using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.Common;

namespace SystemService.Infrastructure.Persistence.Configurations;

public class ApplicationMenuConfiguration : IEntityTypeConfiguration<ApplicationMenu>
{
    public void Configure(EntityTypeBuilder<ApplicationMenu> builder)
    {
        builder.ToTable("ApplicationMenu");

        builder.HasKey(a => a.Id);

        builder.HasOne(t => t.Parent)
            .WithMany(p => p.Children)
            .HasForeignKey(t => t.ParentId)
            .OnDelete(deleteBehavior: DeleteBehavior.Restrict);
    }
}