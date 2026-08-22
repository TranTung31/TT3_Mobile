using MediatR;
using Microsoft.AspNetCore.Identity;
using SystemService.Application.Exceptions;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Commands;

public record DeleteRoleFromDbCommand(Guid Id) : IRequest<bool>;

public class DeleteRoleFromDbCommandHandler : IRequestHandler<DeleteRoleFromDbCommand, bool>
{
    private readonly RoleManager<Role> _roleManager;
    private readonly IRolePermissionRepository _rolePermissionRepository;

    public DeleteRoleFromDbCommandHandler(
        RoleManager<Role> roleManager,
        IRolePermissionRepository rolePermissionRepository)
    {
        _roleManager = roleManager;
        _rolePermissionRepository = rolePermissionRepository;
    }

    public async Task<bool> Handle(
        DeleteRoleFromDbCommand request,
        CancellationToken cancellationToken)
    {
        var role = await _roleManager.FindByIdAsync(request.Id.ToString());
        if (role == null)
            throw new NotFoundException(nameof(Role), request.Id);

        // Xóa liên kết role-permission trước (bảng tự định nghĩa, không thuộc Identity)
        await _rolePermissionRepository.DeleteByRoleIdAsync(role.Id, cancellationToken);

        // Xóa role bằng RoleManager (Identity)
        // Các liên kết ApplicationUserRole (IdentityUserRole) sẽ cascade xóa theo Identity
        var deleteResult = await _roleManager.DeleteAsync(role);
        if (!deleteResult.Succeeded)
            throw new BadRequestException(
                string.Join("; ", deleteResult.Errors.Select(e => e.Description)));

        return true;
    }
}
