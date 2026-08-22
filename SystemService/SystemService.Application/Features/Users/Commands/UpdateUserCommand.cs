using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Shared.Redis.Permissions;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Users;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Commands;

public record UpdateUserCommand(UserUpdateModel Model) : IRequest<bool>;

public class UpdateUserCommandHandler : IRequestHandler<UpdateUserCommand, bool>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IUserRepository _userRepository;
    private readonly IRoleRepository _roleRepository;
    private readonly IUserPermissionCacheService _userPermissionCacheService;
    private readonly IMapper _mapper;
    private readonly ILogger<UpdateUserCommandHandler> _logger;

    public UpdateUserCommandHandler(
        UserManager<ApplicationUser> userManager,
        IUserRepository userRepository,
        IRoleRepository roleRepository,
        IUserPermissionCacheService userPermissionCacheService,
        IMapper mapper,
        ILogger<UpdateUserCommandHandler> logger)
    {
        _userManager = userManager;
        _userRepository = userRepository;
        _roleRepository = roleRepository;
        _userPermissionCacheService = userPermissionCacheService;
        _mapper = mapper;
        _logger = logger;
    }

    public async Task<bool> Handle(UpdateUserCommand request, CancellationToken cancellationToken)
    {
        var model = request.Model;

        // 1. Tìm user theo Id (ASP.NET Identity)
        var user = await _userManager.FindByIdAsync(model.Id.ToString());
        if (user == null || user.IsDeleted)
            throw new NotFoundException(nameof(ApplicationUser), model.Id);

        // 2. Kiểm tra UserName / Email không được trùng với user khác
        if (!await _userRepository.BeUniqueUserName(model.UserName, user.Id, cancellationToken))
            throw new UserAlreadyExistsException($"Username '{model.UserName}' đã tồn tại.");

        if (!await _userRepository.BeUniqueEmail(model.Email, user.Id, cancellationToken))
            throw new UserAlreadyExistsException($"Email '{model.Email}' đã được sử dụng bởi người dùng khác.");

        // 3. Cập nhật thông tin cơ bản (AutoMapper map các trường cùng tên)
        //    UpdateAsync của Identity sẽ tự chuẩn hoá lại NormalizedUserName / NormalizedEmail
        _mapper.Map(model, user);
        user.UpdatedOnUtc = DateTime.UtcNow;

        // 4. Trạng thái kích hoạt - dùng cơ chế lockout của ASP.NET Identity.
        //    ApplicationUser không có cột IsEnabled, nên vô hiệu hoá = khoá tài khoản
        if (!model.IsEnabled)
        {
            user.LockoutEnabled = true;
            user.LockoutEnd = DateTimeOffset.MaxValue;
        }
        else
        {
            user.LockoutEnd = null;
        }

        var updateResult = await _userManager.UpdateAsync(user);
        if (!updateResult.Succeeded)
            throw new BadRequestException(
                string.Join("; ", updateResult.Errors.Select(e => e.Description)));

        if (model.Roles != null)
        {
            // 5. Đồng bộ roles (danh sách role id trong model)
            await SyncRolesAsync(user, model.Roles, cancellationToken);
        }

        // 6. Xoá cache quyền để role/trạng thái mới có hiệu lực ngay lập tức
        //await _userPermissionCacheService.RemovePermissionsAsync(user.Id, cancellationToken);

        _logger.LogInformation("Đã cập nhật user {UserId} ({UserName}) thành công.", user.Id, user.UserName);

        return true;
    }

    /// <summary>
    /// Đồng bộ role của user theo danh sách role id mong muốn.
    /// Phần tử trong model.Roles là Id (Guid) của role.
    /// </summary>
    private async Task SyncRolesAsync(ApplicationUser user, List<string> roleIds, CancellationToken cancellationToken)
    {
        var desiredRoleNames = new HashSet<string>();

        foreach (var roleIdString in roleIds)
        {
            if (!Guid.TryParse(roleIdString, out var roleId))
                continue;

            var role = await _roleRepository.GetByIdAsync(roleId, cancellationToken);
            if (role != null && !string.IsNullOrEmpty(role.Name))
                desiredRoleNames.Add(role.Name);
        }

        var currentRoleNames = await _userManager.GetRolesAsync(user);

        var rolesToRemove = currentRoleNames.Except(desiredRoleNames).ToList();
        if (rolesToRemove.Count > 0)
        {
            var removeResult = await _userManager.RemoveFromRolesAsync(user, rolesToRemove);
            if (!removeResult.Succeeded)
                throw new BadRequestException(
                    string.Join("; ", removeResult.Errors.Select(e => e.Description)));
        }

        var rolesToAdd = desiredRoleNames.Except(currentRoleNames).ToList();
        if (rolesToAdd.Count > 0)
        {
            var addResult = await _userManager.AddToRolesAsync(user, rolesToAdd);
            if (!addResult.Succeeded)
                throw new BadRequestException(
                    string.Join("; ", addResult.Errors.Select(e => e.Description)));
        }
    }
}
