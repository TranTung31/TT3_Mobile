using FluentValidation;
using SystemService.Application.Features.Users.Commands;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Validators;

public class UpdateUserValidator : AbstractValidator<UpdateUserCommand>
{
    public UpdateUserValidator(IUserRepository repository)
    {
        RuleFor(x => x.Model.FullName)
            .NotEmpty().WithMessage("Họ không được để trống.")
            .MaximumLength(256).WithMessage("Họ không được vượt quá 256 ký tự.");
    }
}
