using MediatR;
using SystemService.Application.Models.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Queries;

public record GetUsersQuery : IRequest<IEnumerable<UserItemModel>>;
public class GetUsersQueryHandler : IRequestHandler<GetUsersQuery, IEnumerable<UserItemModel>>
{
    private readonly IUserRepository _userRepository;
    public GetUsersQueryHandler(IUserRepository userRepository)
    {
        _userRepository = userRepository;
    }
    public async Task<IEnumerable<UserItemModel>> Handle(GetUsersQuery request, CancellationToken cancellationToken)
    {
        return new List<UserItemModel>();
    }
}
