namespace Shared.Contracts.Authentication;

public class CurrentUser
{
    public Guid Id { get; init; }
    public string KeycloakUserId { get; set; }
    public string UserName { get; init; }
    public string FullName { get; init; }
    public Guid? DonViId { get; init; }
    public bool IsSuperAdmin { get; set; }
    public int LinhVucQuanLy { get; set; }
    public IReadOnlyList<string> Permissions { get; init; } = [];
}
