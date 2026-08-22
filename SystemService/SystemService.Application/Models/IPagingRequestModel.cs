namespace SystemService.Application.Models;

public partial interface IPagingRequestModel
{
    /// <summary>
    /// Gets a page number
    /// </summary>
    int Page { get; set; }

    /// <summary>
    /// Gets a page size
    /// </summary>
    int PageSize { get; set; }
}
