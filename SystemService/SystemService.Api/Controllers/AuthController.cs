using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SystemService.Application.Features.Auth.Commands;
using SystemService.Application.Models.Auth;
using SystemService.Application.Models.Common;

namespace SystemService.Api.Controllers;

[Route("api/quan-ly-he-thong/auth")]
public class AuthController : BaseApiController
{
    [HttpPost("login")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(ApiResponseModel<AuthTokenResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> Login([FromBody] LoginCommand command)
    {
        var result = await Mediator.Send(command);
        return Ok(ApiResponseModel.Success(result));
    }

    [HttpPost("refresh")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(ApiResponseModel<AuthTokenResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> Refresh([FromBody] RefreshTokenCommand command)
    {
        var result = await Mediator.Send(command);
        return Ok(ApiResponseModel.Success(result));
    }

    [HttpPost("logout")]
    [ProducesResponseType(typeof(ApiResponseModel<bool>), StatusCodes.Status200OK)]
    public async Task<IActionResult> Logout()
    {
        var result = await Mediator.Send(new LogoutCommand());
        if (result)
            return Ok(ApiResponseModel.Success(result));
        return Ok(ApiResponseModel.Fail(result));
    }
}

