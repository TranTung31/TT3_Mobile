using Shared.Contracts.Authentication;

namespace SystemService.Application.Services;

public interface ICurrentUserService
{
    CurrentUser? User { get; }
    Guid? GetUserId();
    Guid? GetDonViId();
    bool IsSuperAdmin();
}
