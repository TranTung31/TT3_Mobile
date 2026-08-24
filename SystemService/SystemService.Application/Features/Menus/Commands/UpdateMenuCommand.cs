using AutoMapper;
using MediatR;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Menus;
using SystemService.Domain;
using SystemService.Domain.Entities.Common;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Commands;

public record UpdateMenuCommand(Guid Id, MenuUpDateModel Model) : IRequest<bool>;

public class UpdateMenuCommandHandler : IRequestHandler<UpdateMenuCommand, bool>
{
    private readonly IApplicationMenuRepository _menuRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;
    // Có thể bạn sẽ cần inject DbContext hoặc một IMenuPermissionRepository để xóa
    private readonly IMenuPermissionRepository _permissionRepository;

    public UpdateMenuCommandHandler(
        IApplicationMenuRepository menuRepository,
        IUnitOfWork unitOfWork,
        IMapper mapper,
        IMenuPermissionRepository permissionRepository) // Thêm vào
    {
        _menuRepository = menuRepository;
        _unitOfWork = unitOfWork;
        _mapper = mapper;
        _permissionRepository = permissionRepository;
    }

    public async Task<bool> Handle(UpdateMenuCommand request, CancellationToken cancellationToken)
    {
        try
        {
            await _unitOfWork.BeginTransactionAsync(cancellationToken);
            var menuToUpdate = await _menuRepository.GetByIdWithPermissionsAsync(request.Id) ?? throw new NotFoundException(nameof(ApplicationMenu), request.Id);
            _mapper.Map(request.Model, menuToUpdate);

            // --- Logic đồng bộ hóa Permission ---

            var newPermissionNames = request.Model.PermissionNames.ToHashSet();
            var existingPermissions = menuToUpdate.RequiredPermissions;

            // 1. Tìm những permission cần XÓA
            // Là những permission đang có trong DB nhưng không có trong danh sách mới
            var permissionsToRemove = existingPermissions
                .Where(p => !newPermissionNames.Contains(p.PermissionName))
                .ToList();

            // 2. Tìm những tên permission cần THÊM
            // Là những tên có trong danh sách mới nhưng không có trong danh sách DB hiện tại
            var existingPermissionNames = existingPermissions.Select(p => p.PermissionName).ToHashSet();
            var permissionNamesToAdd = newPermissionNames
                .Where(name => !existingPermissionNames.Contains(name))
                .ToList();

            // 3. Thực hiện XÓA
            if (permissionsToRemove.Any())
            {
                // Giả sử bạn có repository cho MenuPermission để xóa
                await _permissionRepository.DeleteAsync(permissionsToRemove);
            }

            // 4. Thực hiện THÊM
            foreach (var nameToAdd in permissionNamesToAdd)
            {
                menuToUpdate.RequiredPermissions.Add(new MenuPermission { PermissionName = nameToAdd });
            }

            await _unitOfWork.SaveChangesAsync(cancellationToken);
            await _unitOfWork.CommitTransactionAsync(cancellationToken);

            return true;
        }
        catch (Exception ex)
        {
            await _unitOfWork.RollbackTransactionAsync(cancellationToken);
            return false;
        }
    }
}
