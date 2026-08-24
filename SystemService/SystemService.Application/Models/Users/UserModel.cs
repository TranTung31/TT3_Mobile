using System.Text.Json.Serialization;

namespace SystemService.Application.Models.Users;

public record UserModel : BaseEntityModel<Guid>
{
    public string UserName { get; set; }

    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
    public string Password { get; set; }
    public string Email { get; set; }
    public string FullName { get; set; }
    public Guid? DonViId { get; set; }
    public bool IsEnabled { get; set; } = true;
    public List<string> Roles { get; set; } = [];
    public int LinhVucQuanLy { get; set; }
    public bool IsChangePassword { get; set; } = false;
}

public record UserCreateModel : BaseEntityModel<Guid>
{
    public string UserName { get; set; }

    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingDefault)]
    public string Password { get; set; }
    public string Email { get; set; }
    public string FullName { get; set; }
    public Guid? DonViId { get; set; }
    public bool IsEnabled { get; set; } = true;
    public List<string> Roles { get; set; } = [];
    public bool IsChangePassword { get; set; } = false;
}

public record UserUpdateModel : BaseEntityModel<Guid>
{
    public string UserName { get; set; }
    public string Email { get; set; }
    public string FullName { get; set; }
    public Guid? DonViId { get; set; }
    public bool IsEnabled { get; set; } = true;
    public List<string> Roles { get; set; } = [];
    public int LinhVucQuanLy { get; set; }
    public bool IsChangePassword { get; set; } = false;
}

public record ChangePasswordModel
{
    public string NewPassword { get; set; }
    public string OldPassword { get; set; }
}

public record ChangePasswordByAdminModel
{
    public string NewPassword { get; set; }
    public Guid userId { get; set; }
}

public record ChangeStatusUserModel: BaseEntityModel<Guid>
{
    public bool IsEnabled { get; set; } = true;
}

public record ImportedUserModel
{
    public List<Guid>? UserIds { get; set; }
}
