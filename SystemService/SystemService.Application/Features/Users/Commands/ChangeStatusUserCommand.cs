using AutoMapper;
using MediatR;
using Microsoft.Extensions.Logging;
using Shared.Redis.Permissions;
using SystemService.Application.Models.Users;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Commands;


public record ChangeStatusUserCommand(ChangeStatusUserModel Model) : IRequest<bool>;

public class ChangeStatusUserCommandHandler : IRequestHandler<ChangeStatusUserCommand, bool>
{
    private readonly IUserRepository _userRepository;
    private readonly ILogger<ChangeStatusUserCommandHandler> _logger;
    public ChangeStatusUserCommandHandler(
        IUserRepository userRepository,
        IApplicationUserRoleRepository userRoleRepository,
        IRoleRepository roleRepository,
        IUnitOfWork unitOfWork,
        IMapper mapper,
        IUserPermissionCacheService userPermissionCacheService,
        ILogger<ChangeStatusUserCommandHandler> logger)
    {
        _userRepository = userRepository;
        _logger = logger;
    }

    public async Task<bool> Handle(ChangeStatusUserCommand request, CancellationToken cancellationToken)
    {
        return true;
    }
}
