using MediatR;
using Microsoft.AspNetCore.Mvc;
using SystemService.Application.Features.Menus.Commands;
using SystemService.Application.Features.Menus.Queries;
using SystemService.Application.Models.Menus;

namespace SystemService.Api.Controllers;

[ApiController]
[Route("api/menus")]
public class MenusController : BaseApiController
{
    private readonly IMediator _mediator;

    public MenusController(IMediator mediator)
    {
        _mediator = mediator;
    }

    [HttpPost]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create(CreateMenuCommand command)
    {
        var menuId = await _mediator.Send(command);
        return Ok(menuId);
    }

    [HttpPost("search")]
    [ProducesResponseType(typeof(MenuItemPageModel), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> GetPagedList(MenuSearchModel searchModel)
    {
        var query = new GetPageListMenuQuery(searchModel);
        var result = await _mediator.Send(query);

        return Ok(result);
    }

    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll()
    {
        var menus = await _mediator.Send(new GetAllMenusQuery());
        return Ok(menus);
    }

    [HttpGet("user")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAllMenuForUser()
    {
        var menus = await _mediator.Send(new GetAllMenusUserQuery());
        return Ok(menus);
    }

    [HttpPut("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(Guid id, [FromBody] MenuUpDateModel model)
    {
        // Tạo command từ id trên route và model từ body
        var command = new UpdateMenuCommand(id, model);

        // Gửi command đến handler để xử lý
        await _mediator.Send(command);

        return NoContent();
    }

    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(MenuItemModel), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> GetMenuByIdAsync(Guid id)
    {
        var query = new GetMenuByIdQuery(id);

        var result = await _mediator.Send(query);

        if (result == null)
            return NotFound();

        return Ok(result);
    }

    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var command = new DeleteMenuCommand { Id = id };
        await _mediator.Send(command);
        return NoContent();
    }

    [HttpGet("horizontal")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetLstHorizontalMenu([FromQuery] int? type)
    {
        var searchModel = new MenuTreeSearchModel
        {
            IsHorizontalMenu = true,
            ParentId = null,
            Type = type
        };

        var query = new GetAllMenuTreeQuery(searchModel);
        var result = await _mediator.Send(query);

        return Ok(result);
    }

    [HttpPost("vertical/{parentId:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetLstVerticalMenu(Guid parentId,
        [FromBody] MenuTreeSearchModel searchModel)
    {
        searchModel.IsHorizontalMenu = false;
        searchModel.ParentId = parentId;

        var query = new GetAllMenuTreeQuery(searchModel);
        var result = await _mediator.Send(query);

        return Ok(result);
    }
}
