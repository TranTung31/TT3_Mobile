using MediatR;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Auth.Commands;

public record LogoutCommand() : IRequest<bool>;

public class LogoutCommandHandler : IRequestHandler<LogoutCommand, bool>
{
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ICurrentUserService _currentUserService;

    public LogoutCommandHandler(
        IRefreshTokenRepository refreshTokenRepository,
        IUnitOfWork unitOfWork,
        ICurrentUserService currentUserService)
    {
        _refreshTokenRepository = refreshTokenRepository;
        _unitOfWork = unitOfWork;
        _currentUserService = currentUserService;
    }

    public async Task<bool> Handle(LogoutCommand request, CancellationToken cancellationToken)
    {
        var currentUserId = _currentUserService.GetUserId();
        if (currentUserId == null)
            return false;

        // Thu hồi toàn bộ refresh token còn hiệu lực của user
        foreach (var refreshToken in await _refreshTokenRepository.GetActiveByUserIdAsync(currentUserId.Value, cancellationToken))
            _refreshTokenRepository.Revoke(refreshToken);

        await _unitOfWork.SaveChangesAsync(cancellationToken);
        return true;
    }
}
