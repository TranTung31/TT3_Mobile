namespace SystemService.Application.Models;

/// <summary>
/// Đại diện cho thông tin phân trang trả về cho client.
/// </summary>
public partial record PaginationModel
{
    /// <summary>
    /// Trang hiện tại.
    /// </summary>
    public int CurrentPage { get; init; }

    /// <summary>
    /// Kích thước trang.
    /// </summary>
    public int PageSize { get; init; }

    /// <summary>
    /// Tổng số bản ghi.
    /// </summary>
    public int TotalRecords { get; init; }

    /// <summary>
    /// Tổng số trang.
    /// </summary>
    public int TotalPages => (int)Math.Ceiling(TotalRecords / (double)PageSize);
}
