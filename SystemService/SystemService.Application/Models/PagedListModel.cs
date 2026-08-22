using System.Collections.Generic;
using SystemService.Domain;

namespace SystemService.Application.Models;

/// <summary>
/// Một triển khai cụ thể của IPagedList<T> để sử dụng trong tầng Application,
/// đặc biệt là sau khi ánh xạ từ Entity sang Model.
/// Lớp này đóng vai trò là một Data Transfer Object (DTO) để chứa dữ liệu đã được xử lý.
/// </summary>
/// <typeparam name="T">Kiểu của các đối tượng trong danh sách.</typeparam>
public class PagedListModel<T> : List<T>, IPagedList<T>
{
    /// <summary>
    /// Chỉ số trang (bắt đầu từ 0).
    /// </summary>
    public int PageIndex { get; }

    /// <summary>
    /// Kích thước trang.
    /// </summary>
    public int PageSize { get; }

    /// <summary>
    /// Tổng số bản ghi.
    /// </summary>
    public int TotalCount { get; }

    /// <summary>
    /// Tổng số trang.
    /// </summary>
    public int TotalPages { get; }

    /// <summary>
    /// Có trang trước đó hay không.
    /// </summary>
    public bool HasPreviousPage => PageIndex > 0;

    /// <summary>
    /// Có trang tiếp theo hay không.
    /// </summary>
    public bool HasNextPage => PageIndex + 1 < TotalPages;

    /// <summary>
    /// Hàm khởi tạo để tạo một danh sách đã phân trang từ một danh sách đã có và thông tin phân trang.
    /// </summary>
    /// <param name="source">Danh sách các mục đã được ánh xạ sang Model.</param>
    /// <param name="pageIndex">Chỉ số trang (bắt đầu từ 0).</param>
    /// <param name="pageSize">Kích thước trang.</param>
    /// <param name="totalCount">Tổng số bản ghi.</param>
    public PagedListModel(IEnumerable<T> source, int pageIndex, int pageSize, int totalCount)
    {
        TotalCount = totalCount;
        TotalPages = (int)Math.Ceiling(totalCount / (double)pageSize);
        PageSize = pageSize;
        PageIndex = pageIndex;
        AddRange(source);
    }
}