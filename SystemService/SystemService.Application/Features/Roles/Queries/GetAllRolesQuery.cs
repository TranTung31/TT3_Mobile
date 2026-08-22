using MediatR;
using SystemService.Application.Models;
using SystemService.Application.Models.Roles;
using SystemService.Application.Models.Users;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Queries;

//public record GetAllRolesQuery(RoleSearchModel SearchModel) : IRequest<RoleListModel>;
//public class GetAllRolesQueryHandler : IRequestHandler<GetAllRolesQuery, RoleListModel>
//{
//    private readonly IKeycloakAdminClient _keycloakAdminClient;
//    public GetAllRolesQueryHandler(IKeycloakAdminClient keycloakAdminClient)
//    {
//        _keycloakAdminClient = keycloakAdminClient;
//    }
//    public async Task<RoleListModel> Handle(GetAllRolesQuery request, CancellationToken cancellationToken)
//    {
//        var searchModel = request.SearchModel;

//        var pagedRoles = await _keycloakAdminClient.GetRealmRolesAsync(
//            searchModel.Keyword,
//            searchModel.Page - 1,
//            searchModel.PageSize,
//            cancellationToken);
//        var resultItems = pagedRoles
//            .Where(r => r.Attributes != null &&
//                        r.Attributes.TryGetValue("role_type", out var type) &&
//                        type.Contains("group"))
//            .Select(r => new RoleItemModel
//            {
//                Id = r.Id,
//                Name = r.Name,
//                Description = r.Description
//            }).ToList();

//        return new RoleListModel
//        {
//            Data = resultItems,
//            Pagination = new PaginationModel
//            {
//                CurrentPage = searchModel.Page,
//                PageSize = searchModel.PageSize,
//                TotalRecords = pagedRoles.TotalCount
//            }
//        };
//    }
//}