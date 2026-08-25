using MediatR;
using SystemService.Application.Models.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Queries;

public record GetLstUsersQuery : IRequest<List<UserItemModel>>;

public class GetLstUsersQueryHandler : IRequestHandler<GetLstUsersQuery, List<UserItemModel>>
{
    private readonly IUserRepository _repository;

    public GetLstUsersQueryHandler(IUserRepository repository)
    {
        _repository = repository;
    }

    public async Task<List<UserItemModel>> Handle(GetLstUsersQuery request, CancellationToken cancellationToken)
    {
        // Lấy danh sách user chưa bị xóa mềm từ DB, trả về dạng phẳng,
        // sắp xếp theo thứ tự tạo mới nhất trước tiên.
        var users = await _repository.GetAllAsync(
            query => query.Where(u => !u.IsDeleted)
                          .OrderByDescending(u => u.CreatedOnUtc),
            cancellationToken);

        var now = DateTimeOffset.UtcNow;

        return users.Select(u => new UserItemModel
        {
            Id = u.Id,
            UserName = u.UserName ?? string.Empty,
            Email = u.Email ?? string.Empty,
            FullName = u.FullName,
            IsEnabled = u.LockoutEnd == null || u.LockoutEnd <= now,
            DonViId = u.DonViId
        }).ToList();
    }
}
