using MediatR;
using SystemService.Application.Models.Keycloak;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Queries;

//public record GetRolesQuery : IRequest<IEnumerable<KeycloakRoleInfo>>;
//public class GetRolesQueryHandler : IRequestHandler<GetRolesQuery, IEnumerable<KeycloakRoleInfo>>
//{
//    private readonly IKeycloakAdminClient _keycloakAdminClient;
//    public GetRolesQueryHandler(IKeycloakAdminClient keycloakAdminClient)
//    {
//        _keycloakAdminClient = keycloakAdminClient;
//    }
//    public async Task<IEnumerable<KeycloakRoleInfo>> Handle(GetRolesQuery request, CancellationToken cancellationToken)
//    {
//        var rolesFromKeycloak = await _keycloakAdminClient.GetRealmRolesAsync(cancellationToken: cancellationToken);

//        return [.. rolesFromKeycloak];
//    }
//}
