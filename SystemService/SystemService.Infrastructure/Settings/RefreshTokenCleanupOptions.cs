namespace SystemService.Infrastructure.Settings;

/// <summary>
/// Cấu hình cho worker dọn dẹp bảng RefreshToken.
/// </summary>
public class RefreshTokenCleanupOptions
{
    public const string SectionName = "RefreshTokenCleanup";

    /// <summary>Bật/tắt worker (mặc định bật).</summary>
    public bool Enabled { get; set; } = true;

    /// <summary>Khoảng thời gian giữa các lần dọn dẹp (phút, mặc định 60).</summary>
    public int IntervalMinutes { get; set; } = 60;
}
