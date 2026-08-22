using Grpc.Core;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Shared.Redis.Permissions;
using Shared.Security.Constants;
using System.Security.Claims;

namespace Shared.Security.Authorization;

public class PermissionAuthorizationHandler : AuthorizationHandler<PermissionRequirement>
{
    private readonly ILogger<PermissionAuthorizationHandler> _logger;
    private readonly IUserPermissionCacheService _userPermissionCacheService;

    public PermissionAuthorizationHandler(
        ILogger<PermissionAuthorizationHandler> logger,
        IUserPermissionCacheService userPermissionCacheService)
    {
        _logger = logger;
        _userPermissionCacheService = userPermissionCacheService;
    }

    protected override async Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        PermissionRequirement requirement)
    {
        if (context.User.Identity?.IsAuthenticated != true)
        {
            return;
        }

        var httpContext = context.Resource as HttpContext;
        var cancellationToken = httpContext?.RequestAborted ?? CancellationToken.None;
        var sub = context.User.FindFirst("sub")?.Value;
        var nameIdentifier = context.User.FindFirstValue(ClaimTypes.NameIdentifier);
        var path = httpContext?.Request.Path.Value;

        if (context.User.HasClaim(c =>
                c.Type == CustomClaimTypes.IsSuperAdmin &&
                string.Equals(c.Value, "true", StringComparison.OrdinalIgnoreCase)))
        {
            context.Succeed(requirement);
            return;
        }

        var attribute = httpContext?
            .GetEndpoint()?
            .Metadata
            .GetMetadata<RequiredPermissionAttribute>();
        if (attribute == null || attribute.Permissions == null || !attribute.Permissions.Any())
        {
            context.Succeed(requirement);
            return;
        }

        var requiredPermissions = attribute.Permissions
            .Where(static permission => !string.IsNullOrWhiteSpace(permission))
            .Select(static permission => permission.Trim())
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
        if (requiredPermissions.Length == 0)
        {
            context.Succeed(requirement);
            return;
        }

        var userIdClaim = context.User.FindFirstValue(CustomClaimTypes.UserId);
        var hasLocalUserId = Guid.TryParse(userIdClaim, out var localUserId);
        IReadOnlyCollection<string> effectivePermissions = null;
        if (hasLocalUserId)
        {
            try
            {
                // Đầu tiên cố gắng lấy permissions từ Redis cache
                effectivePermissions = await _userPermissionCacheService.GetPermissionsAsync(
                    localUserId,
                    cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogWarning(
                    ex,
                    "[AUTH DEBUG] Failed to read permissions from Redis | userId={UserId} | sub={Sub} | path={Path}",
                    localUserId,
                    sub,
                    path);
            }
        }
        else
        {
            _logger.LogWarning(
                "[AUTH DEBUG] Missing or invalid user_id claim before Redis lookup | sub={Sub} | nameIdentifier={NameIdentifier} | path={Path} | userIdClaim={UserIdClaim}",
                sub,
                nameIdentifier,
                path,
                userIdClaim);
        }

        if (effectivePermissions == null)
        {
            // Nếu không có permissions trong Redis (có thể do cache miss hoặc lỗi), fallback sang gRPC để lấy permissions trực tiếp từ database
            effectivePermissions = await LoadPermissionsFromGrpcFallbackAsync(
                context,
                requirement,
                localUserId,
                hasLocalUserId,
                sub,
                nameIdentifier,
                path,
                cancellationToken);
        }

        if (context.HasSucceeded)
        {
            return;
        }

        if (effectivePermissions == null)
        {
            return;
        }

        var userPermissions = effectivePermissions
            .Where(static permission => !string.IsNullOrWhiteSpace(permission))
            .Select(static permission => permission.Trim())
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        var authorized = attribute.Operator == LogicalOperator.And
            ? requiredPermissions.All(userPermissions.Contains)
            : requiredPermissions.Any(userPermissions.Contains);

        if (authorized)
        {
            context.Succeed(requirement);
            return;
        }

        _logger.LogWarning(
            "[AUTH DEBUG] 403 permission denied | userId={UserId} | sub={Sub} | nameIdentifier={NameIdentifier} | path={Path} | operator={Operator} | required={Required} | userPermissionCount={UserPermissionCount} | hasRequired={HasRequired} | sampleUserPermissions={Sample}",
            hasLocalUserId ? localUserId : null,
            sub,
            nameIdentifier,
            path,
            attribute.Operator,
            string.Join(", ", requiredPermissions),
            userPermissions.Count,
            requiredPermissions.Any(userPermissions.Contains),
            string.Join(", ", userPermissions.Take(10)));
    }

    private async Task<IReadOnlyCollection<string>> LoadPermissionsFromGrpcFallbackAsync(
        AuthorizationHandlerContext context,
        PermissionRequirement requirement,
        Guid localUserId,
        bool hasLocalUserId,
        string sub,
        string nameIdentifier,
        string path,
        CancellationToken cancellationToken)
    {
        var keycloakId = sub ?? nameIdentifier;
        if (string.IsNullOrWhiteSpace(keycloakId))
        {
            _logger.LogWarning(
                "[AUTH DEBUG] Cannot fallback to gRPC because sub/nameIdentifier is missing | path={Path}",
                path);
            return null;
        }

        return [];
    }
}
