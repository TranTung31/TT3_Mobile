using System.Security.Cryptography;
using System.Text;

namespace SystemService.Application.Services;

public static class RefreshTokenHelper
{
    /// <summary>Sinh chuỗi token ngẫu nhiên 64 bytes (đủ mạnh, không đoán được).</summary>
    public static string Generate()
        => Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));

    /// <summary>Hash SHA-256 — chỉ lưu hash vào DB.</summary>
    public static string Hash(string token)
        => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(token)));
}
