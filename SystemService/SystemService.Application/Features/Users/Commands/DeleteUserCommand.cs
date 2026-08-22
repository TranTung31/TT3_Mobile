using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Shared.Redis.Permissions;
using SystemService.Application.Exceptions;
using SystemService.Domain.Entities.Users;

namespace SystemService.Application.Features.Users.Commands;

public record DeleteUserCommand(Guid Id) : IRequest<bool>;

public class DeleteUserCommandHandler : IRequestHandler<DeleteUserCommand, bool>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IUserPermissionCacheService _userPermissionCacheService;
    private readonly ILogger<DeleteUserCommandHandler> _logger;

    public DeleteUserCommandHandler(
        UserManager<ApplicationUser> userManager,
        IUserPermissionCacheService userPermissionCacheService,
        ILogger<DeleteUserCommandHandler> logger)
    {
        _userManager = userManager;
        _userPermissionCacheService = userPermissionCacheService;
        _logger = logger;
    }

    public async Task<bool> Handle(DeleteUserCommand request, CancellationToken cancellationToken)
    {
        // 1. Tìm user theo Id (ASP.NET Identity)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      var user = await _userManager.FindByIdAsync(request.Id.ToString());
        if (user == null || user.IsDeleted)
            throw new NotFoundException(nameof(ApplicationUser), request.Id);

        // 2. Không cho phép xoá tài khoản quản trị hệ thống
        if (user.IsSuperAdmin)
            throw new BadRequestException("Không thể xóa tài khoản quản trị hệ thống.");

        // 3. Xoá mềm: giữ bản ghi để truy vết (mọi query đều filter IsDeleted = false)
        //user.IsDeleted = true;
        //user.UpdatedOnUtc = DateTime.UtcNow;

        // 4. Vô hiệu hoá tài khoản (ASP.NET Identity lockout)
        //user.LockoutEnabled = true;
        //user.LockoutEnd = DateTimeOffset.MaxValue;

        //var updateResult = await _userManager.UpdateAsync(user);
        //if (!updateResult.Succeeded)
        //    throw new BadRequestException(
        //        string.Join("; ", updateResult.Errors.Select(e => e.Description)));

        // 5. Xoá cache quyền để user đã xoá không còn quyền truy cập
        //await _userPermissionCacheService.RemovePermissionsAsync(user.Id, cancellationToken);

        await _userManager.DeleteAsync(user);

        _logger.LogInformation("Đã xoá user {UserId} ({UserName}).", user.Id, user.UserName);

        return true;
    }
}
