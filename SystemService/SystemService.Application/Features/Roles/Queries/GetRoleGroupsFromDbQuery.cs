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
        // Lấy danh sách role đang hoạt động từ DB và trả về dạng phẳng (flat list)
        var roles = await _roleRepository.GetAllAsync(
            query => query.Where(r => r.IsActive)
                          .OrderBy(role => role.Name),
            cancellationToken);

        return [.. roles.Select(role => new RoleItemModel
        {
            Id = role.Id,
            Name = role.Name,
            Description = role.Description
        })];
    }
}
