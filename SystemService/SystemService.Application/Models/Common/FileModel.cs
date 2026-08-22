namespace SystemService.Application.Models.Common;

/// <summary>
/// DTO để biểu diễn một file được upload, không phụ thuộc vào tầng Web.
/// </summary>
public record FileModel
{
    /// <summary>
    /// Tên file gốc.
    /// </summary>
    public string FileName { get; init; }

    /// <summary>
    /// Kiểu nội dung (MIME type).
    /// </summary>
    public string ContentType { get; init; }

    /// <summary>
    /// Nội dung file dưới dạng một Stream.
    /// </summary>
    public Stream Content { get; init; }
}