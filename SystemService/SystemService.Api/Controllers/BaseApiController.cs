using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SystemService.Api.Controllers;

/// <summary>
/// Lớp controller cơ sở, chứa các thuộc tính và chức năng chung.
/// </summary>
[Route("api/[controller]")]
[ApiController]
[Authorize]
public abstract partial class BaseApiController : ControllerBase
{
    private ISender _mediator;

    /// <summary>
    /// Lấy instance của MediatR ISender.
    /// Sử dụng lazy loading để tối ưu hiệu suất.
    /// </summary>
    protected ISender Mediator => _mediator ??= HttpContext.RequestServices.GetRequiredService<ISender>();
}
