using AutoMapper;
using MediatR;
using SystemService.Application.Models.Menus;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Queries
{
    public record GetMenuByIdQuery(Guid Id) : IRequest<MenuItemFullModel>;

    public class GetMenuByIdQueryHandler : IRequestHandler<GetMenuByIdQuery, MenuItemFullModel>
    {
        private readonly IApplicationMenuRepository _menuRepository;
        private readonly IMapper _mapper;

        public GetMenuByIdQueryHandler(IApplicationMenuRepository menuRepository, IMapper mapper)
        {
            _menuRepository = menuRepository;
            _mapper = mapper;
        }

        public async Task<MenuItemFullModel> Handle(GetMenuByIdQuery request, CancellationToken cancellationToken)
        {
            var entity = await _menuRepository.GetByIdWithPermissionsAsync(request.Id);

            if (entity == null)
                return null;

            return _mapper.Map<MenuItemFullModel>(entity);
        }
    }
}

