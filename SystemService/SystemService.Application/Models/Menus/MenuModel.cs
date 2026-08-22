using SystemService.Domain.Entities.Enums;

namespace SystemService.Application.Models.Menus
{
    public class MenuModel
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Path { get; set; }
        public Guid? ParentId { get; set; }
        public int Order { get; set; }
        public string? Icon { get; set; }
        public bool? isHorizontal { get; set; }
        public List<MenuModel> Children { get; set; } = new List<MenuModel>();
    }

    public class MenuUpDateModel
    {
        public required string Name { get; set; }
        public string? Path { get; set; }
        public string? Icon { get; set; }
        public int Order { get; set; }
        public bool IsActive { get; set; }
        public Guid? ParentId { get; set; }
        public bool? isHorizontal { get; set; }
        public MenuHeThongType? Type { get; set; }
        public List<string> PermissionNames { get; set; } = new();
    }

    public class MenuUserModel
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Path { get; set; }
        public Guid? ParentId { get; set; }
        public int Order { get; set; }
        public string? Icon { get; set; }
        public List<string> RequiredPermissions { get; set; } = new List<string>();
        public List<MenuUserModel> Children { get; set; } = new List<MenuUserModel>();
    }

    public partial record MenuItemModel : BaseEntityModel<Guid>
    {       
        public required string Name { get; set; }
        public string? Path { get; set; }
        public int Order { get; set; }
        public bool IsActive { get; set; }
        public string? Icon { get; set; }
        public Guid? ParentId { get; set; }
    }

    public partial record MenuItemFullModel 
    {
        public Guid Id { get; set; }
        public required string Name { get; set; }
        public string? Path { get; set; }
        public int Order { get; set; }
        public bool IsActive { get; set; }
        public Guid? ParentId { get; set; }
        public string? Icon { get; set; }
        public bool? isHorizontal { get; set; }
        public MenuHeThongType? Type { get; set; }
        public List<string> PermissionNames { get; set; } = new List<string>();
    }

    public partial record MenuItemPageModel : BasePagedListModel<MenuItemModel>
    {
    }

    public record MenuSearchModel : BaseSearchModel
    {
        public string Keyword { get; set; }
    }
}
