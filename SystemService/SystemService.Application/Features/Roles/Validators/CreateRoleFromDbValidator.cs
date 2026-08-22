using FluentValidation;
using SystemService.Application.Features.Roles.Commands;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Roles.Validators;

public class CreateRoleFromDbValidator : AbstractValidator<CreateRoleFromDbCommand>
{
    public CreateRoleFromDbValidator(IRoleRepository roleRepository)
    {
        RuleFor(x => x.Model.Name)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().WithMessage("Tên vai trò không được để trống.")
            .MinimumLength(3).WithMessage("Tên vai trò phải có ít nhất 3 ký tự.")
            .MaximumLength(50).WithMessage("Tên vai trò không được vượt quá 50 ký tự.")
            .MustAsync(async (name, cancellationToken) =>
                await roleRepository.BeUniqueNameAsync(
                    name,
                    cancellationToken: cancellationToken))
            .WithMessage("Mã vai trò đã tồn tại trong hệ thống.");
    }
}
