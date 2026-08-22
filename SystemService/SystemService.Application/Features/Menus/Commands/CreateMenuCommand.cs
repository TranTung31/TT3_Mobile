using AutoMapper;
using MediatR;
using SystemService.Domain;
using SystemService.Domain.Entities.Common;
using SystemService.Domain.Entities.Enums;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Commands;


public record CreateMenuCommand : IRequest<Guid>
{
    public string Name { get; set; }
    public string Path { get; set; }
    public string Icon { get; set; }
    public Guid? ParentId { get; set; }
    public bool? isHorizontal { get; set; }
    public List<string> PermissionNames { get; set; }
    public int Order { get; set; }
    public bool IsActive { get; set; }
    public MenuHeThongType? Type { get; set; }
}

public class CreateMenuCommandHandler : IRequestHandler<CreateMenuCommand, Guid>
{

    private readonly IApplicationMenuRepository _menuRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public CreateMenuCommandHandler(IApplicationMenuRepository menuRepository,
        IUnitOfWork unitOfWork,
        IMapper mapper
        )
    {
        _menuRepository = menuRepository;
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Guid> Handle(CreateMenuCommand request, CancellationToken cancellationToken)
    {
        
        var newMenu = _mapper.Map<ApplicationMenu>(request);

        if (request.PermissionNames != null && request.PermissionNames.Count > 0)
        {
            // Lặp qua danh sách các tên quyền được cung cấp
            foreach (var permissionName in request.PermissionNames)
            {
                var newPermission = new MenuPermission
                {
                    PermissionName = permissionName
                };
                newMenu.RequiredPermissions.Add(newPermission);
            }
        }

        await _menuRepository.InsertAsync(newMenu);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return newMenu.Id;
    }
}

