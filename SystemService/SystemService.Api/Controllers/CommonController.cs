using Microsoft.AspNetCore.Mvc;
using Shared.Security.Permissions;
using SystemService.Application.Extensions;
using SystemService.Application.Models.Common;
using SystemService.Domain.Entities.DanhMucDungRiengDonVi.Enums;
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

    /// <summary>
    /// Lấy danh sách các loại thuế để hiển thị trên dropdown.
    /// </summary>
    [HttpGet("loai-thue-types")]
	[ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
	public IActionResult GetLoaiThueType() {
        var list = EnumExtensions.ToSelectList<LoaiThueType>();
		return Ok(ApiResponseModel.Success(list));
	}

	/// <summary>
	/// Lấy danh sách các loại đối tượng để hiển thị trên dropdown.
	/// </summary>
	[HttpGet("loai-doi-tuong-types")]
	[ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
	public IActionResult GetLoaiLoaiDoiType() {
		var list = EnumExtensions.ToSelectList<LoaiDoiTuongType>();
		return Ok(ApiResponseModel.Success(list));
	}

    [HttpGet("loai-kho-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetLoaiKhoTypes()
    {
        var list = EnumExtensions.ToSelectList<LoaiKhoType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("menu-he-thong-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetMenuHeThongTypes()
    {
        var list = EnumExtensions.ToSelectList<MenuHeThongType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("nhom-ngach-cong-chuc-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetNhomNgachCongChucTypes()
    {
        var list = EnumExtensions.ToSelectList<NhomNgachCongChucType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("nhom-chuc-vu-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetNhomChucVuTypes()
    {
        var list = EnumExtensions.ToSelectList<NhomChucVuType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("nhom-loai-lam-them-gio-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetNhomLoaiLamThemGioTypes()
    {
        var list = EnumExtensions.ToSelectList<NhomLoaiLamThemGioType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("loai-bao-hiem-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetLoaiBaoHiemTypes()
    {
        var list = EnumExtensions.ToSelectList<LoaiBaoHiemType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("muc-xep-loai-lao-dong-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetMucXepLoaiLaoDongTypes()
    {
        var list = EnumExtensions.ToSelectList<MucXepLoaiLaoDongTypes>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("nhom-trinh-do-hoc-van-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetNhomTrinhDoHocVanTypes()
    {
        var list = EnumExtensions.ToSelectList<NhomTrinhDoHocVanType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("loai-khoan-luong-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetLoaiKhoanLuongTypes()
    {
        var list = EnumExtensions.ToSelectList<LoaiKhoanLuongType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("nhom-khoan-luong-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetNhomKhoanLuongTypes()
    {
        var list = EnumExtensions.ToSelectList<NhomKhoanLuongType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("loai-quy-dinh-luong-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetLoaiQuyDinhLuongTypes()
    {
        var list = EnumExtensions.ToSelectList<LoaiQuyDinhLuongType>();
        return Ok(ApiResponseModel.Success(list));
    }

	[HttpGet("loai-kho-bac-ngan-hang-types")]
	[ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
	public IActionResult GetLoaiKhoBacNganHangTypes() {
		var list = EnumExtensions.ToSelectList<LoaiKhoBacNganHangType>();
		return Ok(ApiResponseModel.Success(list));
	}

    [HttpGet("nhom-lao-dong-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetNhomLaoDongTypes()
    {
        var list = EnumExtensions.ToSelectList<NhomLaoDongType>();
        return Ok(ApiResponseModel.Success(list));
    }


    [HttpGet("ket-qua-phan-loai-lao-dong-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetKetQuaPhanLoaiLaoDongTypes()
    {
        var list = EnumExtensions.ToSelectList<KetQuaPhanLoaiLaoDongType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("loai-nguon-von-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetLoaiNguonVonTypes()
    {
        var list = EnumExtensions.ToSelectList<LoaiNguonVonType>();
        return Ok(ApiResponseModel.Success(list));
    }

    [HttpGet("trinh-do-dao-tao-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetTrinhDoDaoTaoTypes()
    {
        var list = EnumExtensions.ToSelectList<TrinhDoDaoTaoType>();
        return Ok(ApiResponseModel.Success(list));
    }
    [HttpGet("muc-do-tu-chu-tai-chinh-types")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<object>>), StatusCodes.Status200OK)]
    public IActionResult GetMucDoTuChuTaiChinhTypes()
    {
        var list = EnumExtensions.ToSelectList<MucDoTuChuTaiChinhType>();
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