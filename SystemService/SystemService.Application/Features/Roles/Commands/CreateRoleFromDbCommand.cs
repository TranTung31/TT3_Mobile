using MediatR;
using Microsoft.AspNetCore.Identity;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Roles;
using SystemService.Domain;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Commands;

public record CreateRoleFromDbCommand(RoleModel Model) : IRequest<bool>;

public class CreateRoleFromDbCommandHandler : IRequestHandler<CreateRoleFromDbCommand, bool>
{
    private readonly RoleManager<Role> _roleManager;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUnitOfWork _unitOfWork;

    public CreateRoleFromDbCommandHandler(
        RoleManager<Role> roleManager,
        IRolePermissionRepository rolePermissionRepository,
        IUnitOfWork unitOfWork)
    {
        _roleManager = roleManager;
        _rolePermissionRepository = rolePermissionRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<bool> Handle(
        CreateRoleFromDbCommand request,
        CancellationToken cancellationToken)
    {
        var model = request.Model;

        // Tạo role bằng RoleManager (ASP.NET Identity)
        var role = new Role
        {
            Id = Guid.NewGuid(),
            Name = model.Name,
            Description = model.Description,
            IsActive = true
        };

        var createResult = await _roleManager.CreateAsync(role);
        if (!createResult.Succeeded)
            throw new BadRequestException(
                string.Join("; ", createResult.Errors.Select(e => e.Description)));

        // Gán permissions (bảng RolePermission - tự định nghĩa, không thuộc Identity)
        if (model.Permissions.Count > 0)
        {
            await _rolePermissionRepository.AssignPermissionsAsync(
                role.Id,
                model.Permissions,
                cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);
        }

        return true;
    }
}
