using SystemService.Domain;

namespace SystemService.Application.Services;

/// <summary>
/// Cung cấp một client để gửi yêu cầu ghi nhật ký hoạt động đến một service từ xa.
/// </summary>
public interface IActivityLoggerClient
{
    /// <summary>
    /// Gửi yêu cầu ghi lại một hoạt động.
    /// </summary>
    /// <param name="systemName">Tên hệ thống của loại hoạt động.</param>
    /// <param name="comment">Nội dung, mô tả chi tiết về hoạt động.</param>
    /// <param name="userId">ID của người dùng thực hiện (tùy chọn).</param>
    /// <param name="ipAddress">Địa chỉ IP (tùy chọn).</param>
    /// <param name="entityId">Định danh của thực thể bị tác động (tùy chọn).</param>
    /// <param name="entityName">Tên của loại thực thể bị tác động (tùy chọn).</param>
    /// <returns>Task.</returns>
    Task LogActivityAsync(string systemName, string comment, Guid? userId = null, string ipAddress = null, string entityId = null, string entityName = null);

    /// <summary>
    /// Ghi lại một hoạt động liên quan đến một thực thể cụ thể.
    /// </summary>
    /// <typeparam name="T">Loại của BaseEntity.</typeparam>
    /// <param name="systemName">Tên hệ thống của loại hoạt động.</param>
    /// <param name="comment">Nội dung, mô tả chi tiết về hoạt động.</param>
    /// <param name="entity">Thực thể bị tác động.</param>
    /// <returns>Task.</returns>
    Task LogActivityAsync<T>(string systemName, string comment, BaseEntity<T> entity) where T : notnull;
}
