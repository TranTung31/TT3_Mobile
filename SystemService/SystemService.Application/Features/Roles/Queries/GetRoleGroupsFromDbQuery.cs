using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Queries;

public record GetRoleGroupsFromDbQuery : IRequest<IEnumerable<RoleItemModel>>;

public class GetRoleGroupsFromDbQueryHandler
    : IRequestHandler<GetRoleGroupsFromDbQuery, IEnumerable<RoleItemModel>>
{
    private readonly IRoleRepository _roleRepository;

    public GetRoleGroupsFromDbQueryHandler(IRoleRepository roleRepository)
    {
        _roleRepository = roleRepository;
    }

    public async Task<IEnumerable<RoleItemModel>> Handle(
        GetRoleGroupsFromDbQuery request,
        CancellationToken cancellationToken)
    {
        //var roles = await _roleRepository.GetAllAsync(
        //    query => query.OrderBy(role => role.Name));

        //return [.. roles.Select(role => new RoleItemModel
        //{
        //    Id = role.Id,
        //    Name = role.Name,
        //    Description = role.Description
        //})];

        return new List<RoleItemModel>();
    }
}
