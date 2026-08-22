namespace SystemService.Application.Models;

public abstract record BaseSearchModel : BaseModel, IPagingRequestModel
{
    /// <summary>
    /// Lấy hoặc gán số trang (bắt đầu từ 1).
    /// </summary>
    public int Page { get; set; } = 1;

    /// <summary>
    /// Lấy hoặc gán kích thước trang (số lượng bản ghi mỗi trang).
    /// </summary>
    public int PageSize { get; set; } = 10;

    /// <summary>
    /// Tính toán chỉ số trang (bắt đầu từ 0) để sử dụng với LINQ's Skip().
    /// Thuộc tính này chỉ có get và không phải là một phần của IPagingRequestModel.
    /// </summary>
    public int PageIndex => Page > 0 ? Page - 1 : 0;
}
