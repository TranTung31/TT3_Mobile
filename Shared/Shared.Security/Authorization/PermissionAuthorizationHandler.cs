using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Shared.Security.Constants;
using System.Security.Claims;

namespace Shared.Security.Authorization;

/// <summary>
/// Kiểm tra quyền dựa trên danh sách permission đã được nhúng vào claim của JWT
/// (sinh ra lúc login / refresh). Không truy cập DB, không dùng Redis cache.
/// </summary>
public class PermissionAuthorizationHandler : AuthorizationHandler<PermissionRequirement>
{
    private readonly ILogger<PermissionAuthorizationHandler> _logger;

    public PermissionAuthorizationHandler(ILogger<PermissionAuthorizationHandler> logger)
    {
        _logger = logger;
    }

    protected override Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        PermissionRequirement requirement)
    {
        if (context.User.Identity?.IsAuthenticated != true)
            return Task.CompletedTask;

        // SuperAdmin luôn được phép
        if (context.User.HasClaim(c =>
                c.Type == CustomClaimTypes.IsSuperAdmin &&
                string.Equals(c.Value, "true", StringComparison.OrdinalIgnoreCase)))
        {
            context.Succeed(requirement);
            return Task.CompletedTask;
        }

        var httpContext = context.Resource as HttpContext;
        var attribute = httpContext?
            .GetEndpoint()?
            .Metadata
            .GetMetadata<RequiredPermissionAttribute>();
        if (attribute == null || attribute.Permissions == null || !attribute.Permissions.Any())
        {
            context.Succeed(requirement);
            return Task.CompletedTask;
        }

        var requiredPermissions = attribute.Permissions
            .Where(static permission => !string.IsNullOrWhiteSpace(permission))
            .Select(static permission => permission.Trim())
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
        if (requiredPermissions.Length == 0)
        {
            context.Succeed(requirement);
            return Task.CompletedTask;
        }

        // Lấy danh sách permission từ claim (đã nhúng vào token lúc login/refresh)
        var userPermissions = context.User
            .FindAll(CustomClaimTypes.Permissions)
            .Select(static c => c.Value?.Trim() ?? string.Empty)
            .Where(static p => !string.IsNullOrWhiteSpace(p))
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        var authorized = attribute.Operator == LogicalOperator.And
            ? requiredPermissions.All(userPermissions.Contains)
            : requiredPermissions.Any(userPermissions.Contains);

        if (authorized)
        {
            context.Succeed(requirement);
            return Task.CompletedTask;
        }

        _logger.LogWarning(
            "[AUTH] 403 permission denied | userId={UserId} | path={Path} | operator={Operator} | required={Required} | hasRequired={HasRequired}",
            context.User.FindFirstValue(CustomClaimTypes.UserId),
            httpContext?.Request.Path.Value,
            attribute.Operator,
            string.Join(", ", requiredPermissions),
            requiredPermissions.Any(userPermissions.Contains));

        return Task.CompletedTask;
    }
}
