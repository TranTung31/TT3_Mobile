using AutoMapper;
using MediatR;
using SystemService.Application.Models.Users;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Commands;

public record ChangePasswordByAdminCommand(ChangePasswordByAdminModel Model) : IRequest<Guid>;

public class ChangePasswordByAdminCommandHandler : IRequestHandler<ChangePasswordByAdminCommand, Guid>
{
    private readonly IUserRepository _userRepository;
    private readonly IApplicationUserRoleRepository _userRoleRepository;
    private readonly IRoleRepository _roleRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;
    private readonly ICurrentUserService _currentUserService;
    public ChangePasswordByAdminCommandHandler(
        IUserRepository userRepository,
        IApplicationUserRoleRepository userRoleRepository,
        IRoleRepository roleRepository,
        IUnitOfWork unitOfWork,
        IMapper mapper,
        ICurrentUserService currentUserService)
    {
        _userRepository = userRepository;
        _userRoleRepository = userRoleRepository;
        _roleRepository = roleRepository;
        _unitOfWork = unitOfWork;
        _mapper = mapper;
        _currentUserService = currentUserService;
    }

    public async Task<Guid> Handle(ChangePasswordByAdminCommand request, CancellationToken cancellationToken)
    {
        return Guid.NewGuid();
    }
}
