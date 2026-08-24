using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Users;
using SystemService.Domain.Entities.Users;

namespace SystemService.Application.Features.Users.Commands;

public record ChangeStatusUserCommand(ChangeStatusUserModel Model) : IRequest<bool>;

public class ChangeStatusUserCommandHandler : IRequestHandler<ChangeStatusUserCommand, bool>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ILogger<ChangeStatusUserCommandHandler> _logger;

    public ChangeStatusUserCommandHandler(
        UserManager<ApplicationUser> userManager,
        ILogger<ChangeStatusUserCommandHandler> logger)
    {
        _userManager = userManager;
        _logger = logger;
    }

    public async Task<bool> Handle(ChangeStatusUserCommand request, CancellationToken cancellationToken)
    {
        var model = request.Model;

        // 1. Tìm user theo Id (ASP.NET Identity)
        var user = await _userManager.FindByIdAsync(model.Id.ToString());
        if (user == null || user.IsDeleted)
            throw new NotFoundException(nameof(ApplicationUser), model.Id);

        // 2. Cập nhật trạng thái kích hoạt bằng cơ chế lockout của ASP.NET Identity.
        //    ApplicationUser không có cột IsEnabled, nên:
        //    - Kích hoạt   : bỏ khóa (LockoutEnd = null) + reset số lần đăng nhập sai.
        //    - Vô hiệu hoá : khóa vĩnh viễn (LockoutEnabled = true, LockoutEnd = MaxValue).
        if (model.IsEnabled)
        {
            user.LockoutEnd = null;
            user.AccessFailedCount = 0;
        }
        else
        {
            user.LockoutEnabled = true;
            user.LockoutEnd = DateTimeOffset.MaxValue;
        }

        var updateResult = await _userManager.UpdateAsync(user);
        if (!updateResult.Succeeded)
            throw new BadRequestException(
                string.Join("; ", updateResult.Errors.Select(e => e.Description)));

        _logger.LogInformation(
            "Đã cập nhật trạng thái user {UserId} -> IsEnabled={IsEnabled}.",
            user.Id,
            model.IsEnabled);

        return true;
    }
}
