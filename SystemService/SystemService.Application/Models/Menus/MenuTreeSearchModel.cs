namespace SystemService.Application.Models.Menus;

public class MenuTreeSearchModel
{
    public bool? IsHorizontalMenu { get; set; }
    public Guid? ParentId { get; set; }
    public int? Type { get; set; }
}

public class MenuTreeItemModel
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Path { get; set; } = string.Empty;
    public string Icon { get; set; } = string.Empty;
    public int Order { get; set; }
    public bool IsActive { get; set; }
    public Guid? ParentId { get; set; }
    public bool? isHorizontal { get; set; }
    public List<MenuTreeItemModel> Children { get; set; } = [];
}
