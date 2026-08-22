using FluentValidation;
using SystemService.Application.Features.Roles.Commands;

namespace SystemService.Application.Features.Roles.Validators;

//public class CreateRoleValidator : AbstractValidator<CreateRoleCommand>
//{
//    public CreateRoleValidator()
//    {
//        RuleFor(x => x.Model.Name)
//            .NotEmpty().WithMessage("Tên vai trò không được để trống.")
//            .MinimumLength(3).WithMessage("Tên vai trò phải có ít nhất 3 ký tự.")
//            .MaximumLength(50).WithMessage("Tên vai trò không được vượt quá 50 ký tự.");
//    }
//}