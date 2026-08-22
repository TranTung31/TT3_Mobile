using MediatR;
using SystemService.Application.Models;
using SystemService.Application.Models.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Queries;

public record GetAllUsersQuery(UserSearchModel SearchModel) : IRequest<UserListModel>;

public class GetAllUsersQueryHandler : IRequestHandler<GetAllUsersQuery, UserListModel>
{
    private readonly IUserRepository _repository;

    public GetAllUsersQueryHandler(IUserRepository repository)
    {
        _repository = repository;
    }

    public async Task<UserListModel> Handle(GetAllUsersQuery request, CancellationToken cancellationToken)
    {
        var searchModel = request.SearchModel;

        var pagedUsers = await _repository.SearchAsync(
            keyword: searchModel.Keyword,
            userName: searchModel.UserName,
            fullName: searchModel.FullName,
            email: searchModel.Email,
            isEnabled: searchModel.IsEnabled,
            donViId: searchModel.DonViId,
            pageIndex: searchModel.Page - 1,
            pageSize: searchModel.PageSize,
            cancellationToken: cancellationToken);

        var now = DateTimeOffset.UtcNow;
        var items = pagedUsers.Select(u => new UserItemModel
        {
            Id = u.Id,
            UserName = u.UserName ?? string.Empty,
            Email = u.Email ?? string.Empty,
            FullName = u.FullName,
            IsEnabled = u.LockoutEnd == null || u.LockoutEnd <= now,
            DonViId = u.DonViId
        }).ToList();

        return new UserListModel
        {
            Data = items,
            Pagination = new PaginationModel
            {
                CurrentPage = searchModel.Page,
                PageSize = searchModel.PageSize,
                TotalRecords = pagedUsers.TotalCount
            }
        };
    }
}
