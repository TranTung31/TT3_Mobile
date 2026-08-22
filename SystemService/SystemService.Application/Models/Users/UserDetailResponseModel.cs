namespace SystemService.Application.Models.Users;

public class UserDetailResponseModel
{
    public Guid Id { get; set; }
    public string Username { get; set; }
    public string Email { get; set; }
    public string FullName { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public bool IsEnabled { get; set; }
    public Guid? DonViId { get; set; }
    public List<string> Roles { get; set; } = [];
}
