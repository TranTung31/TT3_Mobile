using MediatR;
using SystemService.Application.Models.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Queries;

public record GetUserByIdQuery(Guid Id) : IRequest<UserDetailResponseModel>;

public class GetUserByIdQueryHandler : IRequestHandler<GetUserByIdQuery, UserDetailResponseModel>
{
    private readonly IUserRepository _userRepository;
    private readonly IApplicationUserRoleRepository _userRoleRepository;

    public GetUserByIdQueryHandler(
        IUserRepository userRepository,
        IApplicationUserRoleRepository userRoleRepository)
    {
        _userRepository = userRepository;
        _userRoleRepository = userRoleRepository;
    }

    public async Task<UserDetailResponseModel> Handle(GetUserByIdQuery request, CancellationToken cancellationToken)
    {
        var user = await _userRepository.GetByIdAsync(request.Id, cancellationToken);
        if (user == null)
            return null;

        var roles = await _userRoleRepository.GetRolesByUserIdAsync(user.Id, cancellationToken);

        return new UserDetailResponseModel
        {
            Id = user.Id,
            Username = user.UserName ?? string.Empty,
            Email = user.Email ?? string.Empty,
            FullName = user.FullName,
            FirstName = user.FullName,
            LastName = string.Empty,
            IsEnabled = user.LockoutEnd == null || user.LockoutEnd <= DateTimeOffset.UtcNow,
            DonViId = user.DonViId,
            Roles = roles.Select(r => r.Id.ToString()).ToList()
        };
    }
}
