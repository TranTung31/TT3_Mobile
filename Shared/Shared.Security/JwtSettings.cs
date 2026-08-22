namespace Shared.Security;

public class JwtSettings
{
    public const string SectionName = "JwtSettings";
    public string? Authority { get; set; }
    public string SecretKey { get; set; } = string.Empty;
    public string Issuer { get; set; } = string.Empty;
    public string Audience { get; set; } = string.Empty;
    public string MetadataAddress { get; set; } = string.Empty;
    public string JwksUri { get; set; } = string.Empty;
    public int ExpirationInMinutes { get; set; }
    public int RefreshTokenExpirationDays { get; set; }
}
