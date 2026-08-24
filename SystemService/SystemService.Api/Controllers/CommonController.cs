using Microsoft.AspNetCore.Mvc;
using Shared.Security.Permissions;
using SystemService.Application.Extensions;
using SystemService.Application.Models.Common;
using SystemService.Domain.Entities.Enums;

namespace SystemService.Api.Controllers;

[Route("api/quan-ly-he-thong/common")]
public class CommonController : BaseApiController
{
    /// <summary>
    /// Lấy danh sách các loại trạng thái để hiển thị trên dropdown.
    /// </summary>
    [HttpGet("permissions")]
    [ProducesResponseType(typeof(ApiResponseModel<List<PermissionDisplay>>), StatusCodes.Status200OK)]
    public IActionResult GetAllPermissions()
    {
        var permissions = PermissionHelper.GetAllPermissions();
        return Ok(ApiResponseModel.Success(permissions));
    }

    /// <summary>
    /// Lấy danh sách các loại trạng thái để hiển thị trên dropdown.
    /// </summary>
    [HttpGet("permission-options")]
    [ProducesResponseType(typeof(ApiResponseModel<List<PermissionItemModel>>), StatusCodes.Status200OK)]
    public IActionResult GetAllPermissionOptions()
    {
        var permissions = PermissionHelper.GetAllPermissionOptions();
        return Ok(ApiResponseModel.Success(permissions));
    }

    [HttpGet("menu-he-thong-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetMenuHeThongTypes()
    {
        var list = EnumExtensions.ToSelectList<MenuHeThongType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("hieu-luc-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetHieuLucTypes()
    {
        var list = EnumExtensions.ToSelectList<HieuLucType>();
        return Ok(ApiResponseModel.Success(list));
    }

    /// <summary>
    /// Endpoint giả lập trả về danh sách Value, Label cho Antd Select.
    /// </summary>
    [HttpGet("sample-options")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetSampleOptions()
    {
        var list = new[]
        {
            new { Value = 1, Label = "Tùy chọn 1" },
            new { Value = 2, Label = "Tùy chọn 2" },
            new { Value = 3, Label = "Tùy chọn 3" },
            new { Value = 4, Label = "Tùy chọn 4" },
            new { Value = 5, Label = "Tùy chọn 5" }
        };
        return Ok(ApiResponseModel.Success(list));
    }
}