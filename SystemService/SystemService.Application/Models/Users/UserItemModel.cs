namespace SystemService.Application.Models.Users;

public record UserItemModel : BaseModel
{
    public Guid Id { get; set; }
    public string UserName { get; set; }
    public string Email { get; set; }
    public string FullName { get; set; }
    public bool IsEnabled { get; set; }
    public Guid? DonViId { get; set; }
}
