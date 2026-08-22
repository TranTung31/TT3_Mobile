using AutoMapper;
using SystemService.Application.Features.Menus.Commands;
using SystemService.Application.Models.Menus;
using SystemService.Domain.Entities.Common;

namespace SystemService.Application.Features.Menus.Mappings
{
    public class MenuMap : Profile
    {
        public MenuMap()
        {
            CreateMap<CreateMenuModel, ApplicationMenu>();
            CreateMap<CreateMenuCommand, ApplicationMenu>();
            CreateMap<ApplicationMenu, MenuModel>().ForMember(dest => dest.Children, opt => opt.Ignore());

            CreateMap<MenuUpDateModel, ApplicationMenu>();
            CreateMap<ApplicationMenu, MenuUserModel>()
                .ForMember(
                    dest => dest.RequiredPermissions,
                    opt => opt.MapFrom(src => src.RequiredPermissions.Select(p => p.PermissionName).ToList())
                ).ForMember(dest => dest.Children, opt => opt.Ignore());

            CreateMap<ApplicationMenu, MenuItemModel>();

            CreateMap<ApplicationMenu, MenuItemFullModel>()
                .ForMember(
                dest => dest.PermissionNames,
                opt => opt.MapFrom(src => src.RequiredPermissions.Select(p => p.PermissionName).ToList()));

            CreateMap<ApplicationMenu, MenuTreeItemModel>();
        }
    }
}
