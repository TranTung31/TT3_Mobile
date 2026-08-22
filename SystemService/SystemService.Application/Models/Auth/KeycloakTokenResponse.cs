using System.Text.Json.Serialization;

namespace SystemService.Application.Models.Auth;

public class KeycloakTokenResponse
{
    [JsonPropertyName("access_token")]
    public string AccessToken { get; set; }
    [JsonPropertyName("expires_in")]
    public int ExpiresIn { get; set; }
    [JsonPropertyName("refresh_expires_in")]
    public int RefreshExpiresIn { get; set; }
    [JsonPropertyName("refresh_token")]
    public string RefreshToken { get; set; }
    [JsonPropertyName("token_type")]
    public string TokenType { get; set; }
    [JsonPropertyName("id_token")]
    public string IdToken { get; set; }
    [JsonPropertyName("scope")]
    public string Scope { get; set; }
    [JsonPropertyName("roles")]
    public IEnumerable<string> Roles { get; set; } = [];
    [JsonPropertyName("don_vi_id")]
    public Guid? DonViId { get; set; }
    [JsonPropertyName("ten_don_vi")]
    public string TenDonVi { get; set; }
    [JsonPropertyName("ma_don_vi")]
    public string MaDonVi { get; set; }
    [JsonPropertyName("full_name")]
    public string FullName { get; set; }
	[JsonPropertyName("first_name")]
	public string FirstName { get; set; }
    [JsonPropertyName("linh_vuc_quan_ly")]
    public int LinhVucQuanLy { get; set; }
    [JsonPropertyName("cap_du_toan")]
    public int CapDuToan { get; set; }
    [JsonPropertyName("la_don_vi_chi_tiet")]
    public bool LaDonViChiTiet { get; set; }
    [JsonPropertyName("user_id")]
    public Guid UserId { get; set; }
    [JsonPropertyName("is_super_admin")]
    public bool IsSuperAdmin { get; set; }
    [JsonPropertyName("duoc_phep_tao_noi_dung_thu_chi")]
    public bool DuocPhepTaoNoiDungThuChi { get; set; }
}