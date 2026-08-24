using Microsoft.AspNetCore.Mvc;
using Shared.Security.Authorization;
using Shared.Security.Permissions;
using SystemService.Application.Features.Users.Commands;
using SystemService.Application.Features.Users.Queries;
using SystemService.Application.Models.Common;
using SystemService.Application.Models.Users;

namespace SystemService.Api.Controllers;

[Route("api/quan-ly-he-thong/users")]
//[Authorize]
public class UsersController : BaseApiController
{
    /// <summary>
    /// Lấy danh sách user có phân trang và tìm kiếm.
    /// </summary>
    [HttpPost("search")]
    [ProducesResponseType(typeof(ApiResponseModel<UserListModel>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetUsers([FromBody] UserSearchModel searchModel)
    {
        var result = await Mediator.Send(new GetAllUsersQuery(searchModel));
        return Ok(ApiResponseModel.Success(result));
    }

    /// <summary>
    /// Lấy chi tiết theo id
    /// </summary>
    /// <param name="id">Id user</param>
    /// <returns>Dữ liệu bản ghi</returns>
    [HttpGet("{id:guid}")]
    [RequiredPermission(CorePermissions.QuanLyHeThong.QuanLyNguoiDung.View)]
    [ProducesResponseType(typeof(ApiResponseModel<UserDetailResponseModel>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(Guid id)
    {
        var result = await Mediator.Send(new GetUserByIdQuery(id));
        if (result == null)
        {
            return NotFound(ApiResponseModel.Fail($"Không tìm thấy người dùng với ID = {id}"));
        }
        return Ok(ApiResponseModel.Success(result));
    }

    /// <summary>
    /// Thêm mới user
    /// </summary>
    /// <param name="model">Đối tượng</param>
    /// <returns>Id user</returns>
    [HttpPost]
    [RequiredPermission(CorePermissions.QuanLyHeThong.QuanLyNguoiDung.Create)]
    [ProducesResponseType(typeof(ApiResponseModel<Guid>), StatusCodes.Status201Created)]
    public async Task<IActionResult> CreateUser([FromBody] UserCreateModel model)
    {
        var newId = await Mediator.Send(new CreateUserCommand(model));
        var response = ApiResponseModel.Success(newId);
        return CreatedAtAction(nameof(GetById), new { id = newId }, response);
    }

    /// <summary>
    /// Cập nhật user
    /// </summary>
    /// <param name="id">Id user cần cập nhật</param>
    /// <param name="model">Đối tượng</param>
    /// <returns>Thông báo thành công/lỗi</returns>
    [HttpPut("{id:guid}")]
    [RequiredPermission(CorePermissions.QuanLyHeThong.QuanLyNguoiDung.Edit)]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status200OK)]
    public async Task<IActionResult> UpdateUser(Guid id, [FromBody] UserUpdateModel model)
    {
        if (id != model.Id)
        {
            return BadRequest(ApiResponseModel.Fail("ID trong URL và trong body không khớp."));
        }
        await Mediator.Send(new UpdateUserCommand(model));
        return Ok(ApiResponseModel.Success("Cập nhật người dùng thành công."));
    }

    /// <summary>
    /// Xóa user
    /// </summary>
    /// <param name="id">Id user cần xóa</param>
    /// <returns>Thông báo thành công/lỗi</returns>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status200OK)]
    public async Task<IActionResult> DeleteUser(Guid id)
    {
        await Mediator.Send(new DeleteUserCommand(id));
        return Ok(ApiResponseModel.Success("Xóa người dùng thành công."));
    }

    /// <summary>
    /// Lấy tất cả permissions của người dùng hiện tại từ local DB.
    /// </summary>
    [HttpGet("current/permissions")]
    [ProducesResponseType(typeof(ApiResponseModel<UserPermissionsModel>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetCurrentUserPermissions()
    {
        var result = await Mediator.Send(new GetCurrentUserPermissionsQuery());
        return Ok(ApiResponseModel.Success(result));
    }

    [HttpPut("change-password")]
    [RequiredPermission(CorePermissions.QuanLyHeThong.QuanLyNguoiDung.Edit)]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status200OK)]
    public async Task<IActionResult> changePassword([FromBody] ChangePasswordModel model)
    {
        await Mediator.Send(new ChangePasswordCommand(model));
        return Ok(ApiResponseModel.Success("Cập nhật người dùng thành công."));
    }

    [HttpPut("change-password-by-admin")]
    [RequiredPermission(CorePermissions.QuanLyHeThong.QuanLyNguoiDung.Edit)]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status200OK)]
    public async Task<IActionResult> changePassword([FromBody] ChangePasswordByAdminModel model)
    {
        await Mediator.Send(new ChangePasswordByAdminCommand(model));
        return Ok(ApiResponseModel.Success("Cập nhật người dùng thành công."));
    }

    [HttpPut("change-status/{id:guid}")]
    [RequiredPermission(CorePermissions.QuanLyHeThong.QuanLyNguoiDung.Edit)]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status200OK)]
    public async Task<IActionResult> ChangeStatusUser(Guid id, [FromBody] ChangeStatusUserModel model)
    {
        if (id != model.Id)
        {
            return BadRequest(ApiResponseModel.Fail("ID trong URL và trong body không khớp."));
        }
        await Mediator.Send(new ChangeStatusUserCommand(model));
        return Ok(ApiResponseModel.Success("Cập nhật người dùng thành công."));
    }
}
