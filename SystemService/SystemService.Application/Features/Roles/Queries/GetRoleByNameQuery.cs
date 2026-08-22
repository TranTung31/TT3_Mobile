using MediatR;
using SystemService.Application.Models.Roles;
using SystemService.Application.Services;

namespace SystemService.Application.Features.Roles.Queries;

//public record GetRoleByNameQuery(string Name) : IRequest<RoleDetailResponseModel>;
//// Thay đổi kiểu trả về của Handler
//public class GetRoleByNameQueryHandler : IRequestHandler<GetRoleByNameQuery, RoleDetailResponseModel>
//{
//    private readonly IKeycloakAdminClient _keycloakAdminClient;
//    public GetRoleByNameQueryHandler(IKeycloakAdminClient keycloakAdminClient)
//    {
//        _keycloakAdminClient = keycloakAdminClient;
//    }
//    public async Task<RoleDetailResponseModel> Handle(GetRoleByNameQuery request, CancellationToken cancellationToken)
//    {
//        // Lấy thông tin cơ bản của "Nhóm Quyền" và các "Quyền" con song song
//        var roleTask = _keycloakAdminClient.GetRealmRoleByNameAsync(request.Name, cancellationToken);
//        var compositesTask = _keycloakAdminClient.GetRealmRoleCompositesAsync(request.Name, cancellationToken);
//        await Task.WhenAll(roleTask, compositesTask);
//        var roleInfo = await roleTask;

//        if (roleInfo == null)
//            return null; 

//        var compositeRoles = await compositesTask;
//        // Tổng hợp kết quả
//        var result = new RoleDetailResponseModel
//        {
//            Id = roleInfo.Id,
//            Name = roleInfo.Name,
//            Description = roleInfo.Description, 
//            Permissions = [.. compositeRoles.Select(c => c.Name)]
//        };
//        return result;
//    }
//}
