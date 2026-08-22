using AutoMapper;
using SystemService.Application.Models.Users;
using SystemService.Domain.Entities.Users;

namespace SystemService.Application.Features.Users.Mappings;

public partial class UserProfile : Profile
{
    public UserProfile()
    {
        CreateMap<ApplicationUser, UserItemModel>();

        CreateMap<ApplicationUser, UserModel>()
            .ForMember(dest => dest.Password, opt => opt.Ignore())
            .ForMember(dest => dest.Roles, opt => opt.Ignore());

        CreateMap<UserModel, ApplicationUser>();
        CreateMap<UserCreateModel, ApplicationUser>();
        CreateMap<UserUpdateModel, ApplicationUser>();
    }
}
