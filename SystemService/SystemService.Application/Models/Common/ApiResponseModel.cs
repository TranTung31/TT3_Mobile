namespace SystemService.Application.Models.Common;

/// <summary>
/// Lớp cơ sở cho cấu trúc response chuẩn của API.
/// </summary>
public partial class ApiResponseModel
{
    /// <summary>
    /// Cho biết request có thành công hay không.
    /// </summary>
    public bool IsSuccess { get; set; }

    /// <summary>
    /// Danh sách các thông điệp lỗi chung (nếu có).
    /// </summary>
    public List<string> Errors { get; set; } = new();

    /// <summary>
    /// Dictionary chứa các lỗi validation theo từng trường.
    /// </summary>
    public object? ValidationErrors { get; set; }

    // --- Các phương thức factory tiện lợi ---

    /// <summary>
    /// Tạo một response thành công không có dữ liệu.
    /// </summary>
    public static ApiResponseModel Success()
    {
        return new ApiResponseModel { IsSuccess = true };
    }

    /// <summary>
    /// Tạo một response thành công với dữ liệu.
    /// </summary>
    public static ApiResponseModel<T> Success<T>(T data)
    {
        return new ApiResponseModel<T> { IsSuccess = true, Result = data };
    }

    /// <summary>
    /// Tạo một response thất bại với một hoặc nhiều thông điệp lỗi.
    /// </summary>
    public static ApiResponseModel Fail(params string[] errorMessages)
    {
        return new ApiResponseModel { IsSuccess = false, Errors = errorMessages.ToList() };
    }

    /// <summary>
    /// Tạo một response thất bại với một hoặc nhiều thông điệp lỗi cho một kiểu dữ liệu cụ thể.
    /// </summary>
    public static ApiResponseModel<T> Fail<T>(params string[] errorMessages)
    {
        return new ApiResponseModel<T> { IsSuccess = false, Errors = errorMessages.ToList() };
    }

    /// <summary>
    /// Tạo một response thất bại với các lỗi validation.
    /// </summary>
    public static ApiResponseModel Fail(object validationErrors)
    {
        return new ApiResponseModel { IsSuccess = false, ValidationErrors = validationErrors };
    }
}

/// <summary>
/// Lớp response chuẩn của API có chứa dữ liệu trả về.
/// </summary>
/// <typeparam name="T">Kiểu của dữ liệu trả về.</typeparam>
public class ApiResponseModel<T> : ApiResponseModel
{
    /// <summary>
    /// Dữ liệu kết quả của request.
    /// </summary>
    public T? Result { get; set; }
}