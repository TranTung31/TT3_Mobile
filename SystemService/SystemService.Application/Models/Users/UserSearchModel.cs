namespace SystemService.Application.Models.Users;

public record UserSearchModel : BaseSearchModel
{
    /// <summary>
    /// Từ khóa tìm kiếm.
    /// </summary>
    public string? Keyword { get; set; }
    public string? UserName { get; set; }
    public string? FullName { get; set; }
    public string? Email { get; set; }
    public bool?  IsEnabled { get; set; }

    public Guid? DonViId { get; set; }


}
