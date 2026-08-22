namespace SystemService.Application.Models.Roles;

public record RoleSearchModel : BaseSearchModel
{
    /// <summary>
    /// Từ khóa tìm kiếm.
    /// </summary>
    public string Keyword { get; set; }

    public string? Name { get; set; }

    public string? Description { get; set; }

}