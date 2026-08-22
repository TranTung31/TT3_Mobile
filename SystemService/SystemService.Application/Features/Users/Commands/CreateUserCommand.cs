using AutoMapper;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Shared.Redis.Permissions;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Users;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Commands;

public record CreateUserCommand(UserCreateModel Model) : IRequest<Guid>;

public class CreateUserCommandHandler : IRequestHandler<CreateUserCommand, Guid>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IRoleRepository _roleRepository;
    private readonly IUserPermissionCacheService _userPermissionCacheService;
    private readonly IMapper _mapper;

    public CreateUserCommandHandler(
        UserManager<ApplicationUser> userManager,
        IRoleRepository roleRepository,
        IUserPermissionCacheService userPermissionCacheService,
        IMapper mapper)
    {
        _userManager = userManager;
        _roleRepository = roleRepository;
        _userPermissionCacheService = userPermissionCacheService;
        _mapper = mapper;
    }

    public async Task<Guid> Handle(CreateUserCommand request, CancellationToken cancellationToken)
    {
        // 1. Tạo user local bằng Identity (password bắt buộc)
        var user = _mapper.Map<ApplicationUser>(request.Model);
        user.Id = Guid.NewGuid();
        user.IsDeleted = false;

        var createResult = await _userManager.CreateAsync(user, request.Model.Password);
        if (!createResult.Succeeded)
            throw new BadRequestException(
                string.Join("; ", createResult.Errors.Select(e => e.Description)));

        // 2. Gán role
        if (request.Model.Roles.Any())
        {
            var roleIds = request.Model.Roles
                .Select(roleId => Guid.Parse(roleId)).Distinct().ToList();
            var roles = new HashSet<Role>();

            foreach (var id in roleIds)
            {
                var role = await _roleRepository.GetByIdAsync(id, cancellationToken);
                if (role != null)
                    roles.Add(role);
            }

            await _userManager.AddToRolesAsync(user, roles.Select(r => r.Name!));
        }

        return user.Id;
    }
}
