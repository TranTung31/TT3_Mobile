namespace SystemService.Application.Models;

/// <summary>
/// Lớp cơ sở cho các model trả về một danh sách dữ liệu có phân trang.
/// </summary>
/// <typeparam name="TModel">Kiểu của các model trong danh sách.</typeparam>
public abstract record BasePagedListModel<TModel> : BaseModel where TModel : BaseModel
{
    /// <summary>
    /// Danh sách các bản ghi cho trang hiện tại.
    /// </summary>
    public IEnumerable<TModel> Data { get; set; }

    /// <summary>
    /// Thông tin phân trang.
    /// </summary>
    public PaginationModel Pagination { get; set; }
}
