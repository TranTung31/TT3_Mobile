using AutoMapper;
using MediatR;
using SystemService.Application.Extensions;
using SystemService.Application.Models;
using SystemService.Application.Models.Menus;
using SystemService.Domain.Entities.Common;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Queries;

public record GetPageListMenuQuery(MenuSearchModel SearchModel)
    : IRequest<MenuItemPageModel>;

public class GetPageListMenuQueryHandler : IRequestHandler<GetPageListMenuQuery, MenuItemPageModel>
{
    private readonly IApplicationMenuRepository _repository;
    private readonly IMapper _mapper;

    public GetPageListMenuQueryHandler(
        IApplicationMenuRepository repository,
        IMapper mapper)
    {
        _repository = repository;
        _mapper = mapper;
    }

    public async Task<MenuItemPageModel> Handle(
        GetPageListMenuQuery request,
        CancellationToken cancellationToken)
    {
        var searchModel = request.SearchModel;
        var pagedEntities = await _repository.SearchAsync(
            searchModel.Keyword,
            searchModel.Page - 1,
            searchModel.PageSize);

        var modelItems = pagedEntities.ToModel<MenuItemModel, ApplicationMenu>(_mapper);

        return new MenuItemPageModel
        {
            Data = modelItems,
            Pagination = new PaginationModel
            {
                CurrentPage = searchModel.Page,
                PageSize = searchModel.PageSize,
                TotalRecords = pagedEntities.TotalCount,
            }
        };
    }
}
