namespace SystemService.Application.Models.Menus;

public partial record CreateMenuModel : BaseEntityModel<Guid>
{
    public required string Name { get; set; }
    public string? Path { get; set; }
    public string? Icon { get; set; }
    public int Order { get; set; }
    public bool IsActive { get; set; }
    public Guid? ParentId { get; set; }

    // Thay đổi từ string sang List<string>
    public List<string> PermissionNames { get; set; } = [];
}
