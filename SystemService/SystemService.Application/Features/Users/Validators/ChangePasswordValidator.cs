using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SystemService.Application.Features.Users.Commands;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Users.Validators
{
    public class ChangePasswordValidator: AbstractValidator<ChangePasswordCommand>
    {

        public ChangePasswordValidator(IUserRepository repository)
        {


            RuleFor(x => x.Model.NewPassword)
                .NotEmpty().WithMessage("Mật khẩu không được để trống.")
                .MinimumLength(6).WithMessage("Mật khẩu phải có ít nhất 6 ký tự.")
                // Bạn có thể thêm các rule phức tạp hơn cho mật khẩu nếu cần,
                // ví dụ: .Matches("[A-Z]").WithMessage("Mật khẩu phải chứa ít nhất 1 chữ hoa.")
                // Tuy nhiên, các rule này thường đã được cấu hình trong AddIdentity ở Program.cs
                // và sẽ được UserManager kiểm tra khi gọi CreateAsync.
                // Việc validate ở đây chỉ là một lớp bảo vệ sớm.
                ;


        }
    }
}
