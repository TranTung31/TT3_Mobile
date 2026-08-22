using MediatR;
using Microsoft.AspNetCore.Identity;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Roles;
using SystemService.Domain;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Commands;

public record UpdateRoleFromDbCommand(Guid Id, RoleModel Model) : IRequest<bool>;

public class UpdateRoleFromDbCommandHandler : IRequestHandler<UpdateRoleFromDbCommand, bool>
{
    private readonly RoleManager<Role> _roleManager;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUnitOfWork _unitOfWork;

    public UpdateRoleFromDbCommandHandler(
        RoleManager<Role> roleManager,
        IRolePermissionRepository rolePermissionRepository,
        IUnitOfWork unitOfWork)
    {
        _roleManager = roleManager;
        _rolePermissionRepository = rolePermissionRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<bool> Handle(
        UpdateRoleFromDbCommand request,
        CancellationToken cancellationToken)
    {
        var role = await _roleManager.FindByIdAsync(request.Id.ToString());
        if (role == null)
            throw new NotFoundException(nameof(Role), request.Id);

        role.Name = request.Model.Name;
        role.Description = request.Model.Description;

        var updateResult = await _roleManager.UpdateAsync(role);
        if (!updateResult.Succeeded)
            throw new BadRequestException(
                string.Join("; ", updateResult.Errors.Select(e => e.Description)));

        if (request.Model.Permissions != null)
        {
            // Đồng bộ permissions: gán đúng danh sách client gửi lên
            // (danh sách rỗng = xoá toàn bộ permissions đang có)
            await _rolePermissionRepository.AssignPermissionsAsync(
            role.Id,
            request.Model.Permissions,
            cancellationToken);
        }
            
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return true;
    }
}
