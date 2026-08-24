using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.DependencyInjection;
using Shared.Security.Constants;

namespace Shared.Security.Authorization;

public static class AuthorizationExtensions
{
    public static IServiceCollection AddPermissionAuthorization(this IServiceCollection services)
    {

        services.AddScoped<IAuthorizationHandler, PermissionAuthorizationHandler>();

        services.AddAuthorization(options =>
        {
            // Policy để kiểm tra quyền hạn cụ thể
            options.AddPolicy("HasPermission", policy =>
                policy.AddRequirements(new PermissionRequirement("")));

            // Policy cho Super Admin
            options.AddPolicy("SuperAdmin", policy =>
                policy.RequireClaim(CustomClaimTypes.IsSuperAdmin, "true"));

            // Cấu hình DefaultPolicy để nó kết hợp cả hai
            // Điều này có nghĩa là một request sẽ được cho phép nếu:
            // 1. Người dùng là SuperAdmin, HOẶC
            // 2. Người dùng đáp ứng yêu cầu của policy "HasPermission"
            options.DefaultPolicy = new AuthorizationPolicyBuilder()
                .RequireAuthenticatedUser()
                .AddRequirements(new PermissionRequirement(""))
                .Build();
        });

        return services;
    }
}