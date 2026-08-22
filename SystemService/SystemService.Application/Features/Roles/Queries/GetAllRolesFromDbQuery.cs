using MediatR;
using SystemService.Application.Models;
using SystemService.Application.Models.Roles;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Queries;

public record GetAllRolesFromDbQuery(RoleSearchModel SearchModel) : IRequest<RoleListModel>;

public class GetAllRolesFromDbQueryHandler : IRequestHandler<GetAllRolesFromDbQuery, RoleListModel>
{
    private readonly IRoleRepository _roleRepository;

    public GetAllRolesFromDbQueryHandler(IRoleRepository roleRepository)
    {
        _roleRepository = roleRepository;
    }

    public async Task<RoleListModel> Handle(
        GetAllRolesFromDbQuery request,
        CancellationToken cancellationToken)
    {
        var searchModel = request.SearchModel;
        var pagedRoles = await _roleRepository.SearchAsync(
            keyword: searchModel.Keyword,
            name: searchModel.Name,
            desciption: searchModel.Description,
            pageIndex: searchModel.Page - 1,
            pageSize: searchModel.PageSize);

        var resultItems = pagedRoles
            .Select(role => new RoleItemModel
            {
                Id = role.Id,
                Name = role.Name,
                Description = role.Description
            })
            .ToList();

        return new RoleListModel
        {
            Data = resultItems,
            Pagination = new PaginationModel
            {
                CurrentPage = searchModel.Page,
                PageSize = searchModel.PageSize,
                TotalRecords = pagedRoles.TotalCount
            }
        };
    }
}
