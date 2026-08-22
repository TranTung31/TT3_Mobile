using MediatR;
using SystemService.Application.Exceptions;
using SystemService.Domain;
using SystemService.Domain.Entities.Common;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Commands;

public class DeleteMenuCommand : IRequest<bool>
{
    public Guid Id { get; set; }
}
public class DeleteMenuCommandHandler : IRequestHandler<DeleteMenuCommand, bool>
{
    private readonly IApplicationMenuRepository _menuRepository;
        private readonly IUnitOfWork _unitOfWork;

    public DeleteMenuCommandHandler(IApplicationMenuRepository menuRepository,
        IUnitOfWork unitOfWork
        )
    {
        _menuRepository = menuRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<bool> Handle(DeleteMenuCommand request, CancellationToken cancellationToken)
    {
        var menuToDelete = await _menuRepository.GetByIdAsync(request.Id) ?? throw new NotFoundException(nameof(ApplicationMenu), request.Id);
        await _menuRepository.DeleteAsync(menuToDelete);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return true;
    }
}
