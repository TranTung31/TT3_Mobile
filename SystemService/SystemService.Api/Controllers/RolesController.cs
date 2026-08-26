using Microsoft.AspNetCore.Mvc;
using SystemService.Application.Features.Roles.Commands;
using SystemService.Application.Features.Roles.Queries;
using SystemService.Application.Models.Common;
using SystemService.Application.Models.Roles;

namespace SystemService.Api.Controllers;

/// <summary>
/// Api này đang gọi các service của keycloak. Tạm thời không sử dụng
/// </summary>
[Route("api/quan-ly-he-thong/roles")]
public class RolesController : BaseApiController
{
    /// <summary>
    /// Lấy danh sách role có phân trang và tìm kiếm.
    /// </summary>
    [HttpPost("search")]
    //[RequiredPermission(TcdtPermissions.DmDonVi.View)]
    [ProducesResponseType(typeof(ApiResponseModel<RoleListModel>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetRoles([FromBody] RoleSearchModel searchModel)
    {
        //var result = await Mediator.Send(new GetAllRolesQuery(searchModel));
        var result = await Mediator.Send(new GetAllRolesFromDbQuery(searchModel)); // Lấy role từ dưới DB
        return Ok(ApiResponseModel.Success(result));
    }

    /// <summary>
    /// Lấy chi tiết theo tên
    /// </summary>
    /// <param name="name">Tên role</param>
    /// <returns>Dữ liệu bản ghi</returns>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(ApiResponseModel<RoleDetailResponseModel>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetRoleById(Guid id)
    {
        //var result = await Mediator.Send(new GetRoleByNameQuery(name));
        var result = await Mediator.Send(new GetRoleByNameFromDbQuery(id)); // Lấy role từ dưới DB
        if (result == null)
        {
            return NotFound(ApiResponseModel.Fail($"Không tìm thấy vai trò với id = '{id}'"));
        }
        return Ok(ApiResponseModel.Success(result));
    }

    [HttpGet("groups")]
    [ProducesResponseType(typeof(ApiResponseModel<IEnumerable<RoleItemModel>>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetRoleGroups()
    {
        //var result = await Mediator.Send(new GetRoleGroupsQuery());
        var result = await Mediator.Send(new GetRoleGroupsFromDbQuery()); // Lấy role từ dưới DB
        return Ok(ApiResponseModel.Success(result));
    }

    //[HttpGet("permissions")]
    //[ProducesResponseType(typeof(ApiResponseModel<IEnumerable<RoleItemModel>>), StatusCodes.Status200OK)]
    //public async Task<IActionResult> GetPermissions()
    //{
    //    var result = await Mediator.Send(new GetPermissionsQuery());
    //    return Ok(ApiResponseModel.Success(result));
    //}

    //[HttpGet("permissions-tree")]
    //[ProducesResponseType(typeof(ApiResponseModel<List<PermissionGroup>>), StatusCodes.Status200OK)]
    //public async Task<IActionResult> GetPermissionsAsTree()
    //{
    //    var result = await Mediator.Send(new GetPermissionsAsTreeQuery());
    //    return Ok(ApiResponseModel.Success(result));
    //}

    /// <summary>
    /// Lấy cây quyền từ cơ sở dữ liệu theo GroupPath.
    /// </summary>
    [HttpGet("permissions-tree-from-db")]
    [ProducesResponseType(typeof(ApiResponseModel<List<PermissionGroup>>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPermissionsAsTreeFromDb()
    {
        var result = await Mediator.Send(new GetPermissionsAsTreeFromDbQuery());
        return Ok(ApiResponseModel.Success(result));
    }

    /// <summary>
    /// Lấy danh sách quyền từ DB theo dạng phẳng:
    /// mỗi permission được gộp vào nhóm cuối (leaf) của GroupPath, không tạo subGroups phân cấp.
    /// </summary>
    [HttpGet("permissions-flat-from-db")]
    [ProducesResponseType(typeof(ApiResponseModel<List<PermissionGroup>>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPermissionsFlatFromDb()
    {
        var result = await Mediator.Send(new GetPermissionsFlatFromDbQuery());
        return Ok(ApiResponseModel.Success(result));
    }

    /// <summary>
    /// Thêm mới role
    /// </summary>
    /// <param name="model">Đối tượng</param>
    /// <returns>Id role</returns>
    [HttpPost]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status201Created)]
    public async Task<IActionResult> Create([FromBody] RoleModel model)
    {
        //await Mediator.Send(new CreateRoleCommand(model));
        await Mediator.Send(new CreateRoleFromDbCommand(model)); // Tạo mới ở dưới DB
        return Ok(ApiResponseModel.Success("Tạo vai trò thành công."));
    }

    /// <summary>
    /// Cập nhật role
    /// </summary>
    /// <param name="name">Tên role cần cập nhật</param>
    /// <param name="model">Đối tượng</param>
    /// <returns>Thông báo thành công/lỗi</returns>
    [HttpPut("{id:guid}")]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status200OK)]
    public async Task<IActionResult> Update(Guid id, [FromBody] RoleModel model)
    {
        //await Mediator.Send(new UpdateRoleCommand(name, model));
        await Mediator.Send(new UpdateRoleFromDbCommand(id, model)); // Update ở dưới DB
        return Ok(ApiResponseModel.Success("Cập nhật vai trò thành công."));
    }

    /// <summary>
    /// Xóa role
    /// </summary>
    /// <param name="name">Tên role cần xóa</param>
    /// <returns>Thông báo thành công/lỗi</returns>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(typeof(ApiResponseModel), StatusCodes.Status200OK)]
    public async Task<IActionResult> Delete(Guid id)
    {
        //await Mediator.Send(new DeleteRoleCommand(name));
        await Mediator.Send(new DeleteRoleFromDbCommand(id)); // Xóa ở dưới DB
        return Ok(ApiResponseModel.Success("Xóa vai trò thành công."));
    }
}
