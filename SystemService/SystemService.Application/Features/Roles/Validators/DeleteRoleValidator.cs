using FluentValidation;
using SystemService.Application.Features.Roles.Commands;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Validators;

//public class DeleteRoleValidator : AbstractValidator<DeleteRoleCommand>
//{
//    public DeleteRoleValidator(IRoleRepository roleRepository, IApplicationUserRoleRepository applicationUserRoleRepository)
//    {
//        RuleFor(x => x.Name)
//            .MustAsync(async (name, cancellation) =>
//            {
//                var existRole = await roleRepository.GetByNameAsync(name);
//                if (existRole == null)
//                    return false;

//                var list = await applicationUserRoleRepository.GetUsersByRoleIdAsync(existRole.Id);

//                if (list.Any())
//                    return false;

//                return true;
//            })
//        .WithMessage("Vai trò đã được gán cho người dùng không thể xóa!");
//    }
//}

