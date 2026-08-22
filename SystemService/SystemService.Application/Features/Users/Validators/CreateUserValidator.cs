using FluentValidation;
using SystemService.Application.Features.Users.Commands;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Validators;

public class CreateUserValidator : AbstractValidator<CreateUserCommand> {

	public CreateUserValidator(IUserRepository repository) {
		RuleFor(x => x.Model.UserName)
			.NotEmpty().WithMessage("Tên đăng nhập không được để trống.")
			.MinimumLength(3).WithMessage("Tên đăng nhập phải có ít nhất 3 ký tự.")
			.MaximumLength(50).WithMessage("Tên đăng nhập không được vượt quá 50 ký tự.")
			.Matches("^[a-zA-Z0-9_.-]*$").WithMessage("Tên đăng nhập chỉ được chứa chữ cái, số, và các ký tự '_', '.', '-'.")
			.MustAsync(async (userName, cancellation) => {
				return await repository.BeUniqueUserName(userName, cancellationToken: cancellation);
			}).WithMessage("Tên đăng nhập đã tồn tại.");

		//RuleFor(x => x.Model.Email)
		//    .NotEmpty().WithMessage("Email không được để trống.")
		//    .EmailAddress().WithMessage("Email không đúng định dạng.")
		//    .MaximumLength(256).WithMessage("Email không được vượt quá 256 ký tự.")
		//    .MustAsync(async (email, cancellation) =>
		//    {
		//        return await repository.BeUniqueEmail(email, cancellationToken: cancellation);
		//    }).WithMessage("Email đã được sử dụng.");

		RuleFor(x => x.Model.Password)
			.NotEmpty().WithMessage("Mật khẩu không được để trống.")
			.MinimumLength(6).WithMessage("Mật khẩu phải có ít nhất 6 ký tự.")
			// Bạn có thể thêm các rule phức tạp hơn cho mật khẩu nếu cần,
			// ví dụ: .Matches("[A-Z]").WithMessage("Mật khẩu phải chứa ít nhất 1 chữ hoa.")
			// Tuy nhiên, các rule này thường đã được cấu hình trong AddIdentity ở Program.cs
			// và sẽ được UserManager kiểm tra khi gọi CreateAsync.
			// Việc validate ở đây chỉ là một lớp bảo vệ sớm.
			;

		RuleFor(x => x.Model.FullName)
			.NotEmpty().WithMessage("Họ không được để trống.")
			.MaximumLength(256).WithMessage("Họ không được vượt quá 256 ký tự.");

		//RuleFor(x => x.Model.DonViId)
		//    .GreaterThan(0).WithMessage("Đơn vị không hợp lệ.");

	}
}