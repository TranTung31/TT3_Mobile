using FluentValidation;
using Shared.Security.Permissions;
using SystemService.Application.Features.Menus.Commands;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Validators
{
    public class CreateMenuValidator : AbstractValidator<CreateMenuCommand>
    {
        private readonly IApplicationMenuRepository _menuRepository;

        public CreateMenuValidator(IApplicationMenuRepository menuRepository)
        {
            _menuRepository = menuRepository;

            RuleFor(v => v.Name)
                .NotEmpty().WithMessage("Tên menu là bắt buộc.");

            RuleForEach(v => v.PermissionNames)
                .NotEmpty().WithMessage("Tên quyền không được để trống.")
                .Must(p => GetAllPermissionOptions().Contains(p)) // Giả sử bạn có hàm này
                .WithMessage("'{PropertyValue}' không phải là một quyền hợp lệ.");

            // Kiểm tra tên menu là duy nhất trong cùng một cấp (cùng ParentId)
            //RuleFor(v => v)
            //    .MustAsync(async (model, cancellation) =>
            //    {
            //        // Id = 0 nghĩa là đang tạo mới, không cần bỏ qua bản ghi nào
            //        return await _menuRepository.IsNameUniqueAsync(model.Name, model.ParentId, null, cancellation);
            //    })
            //    .WithMessage("Tên menu đã tồn tại ở cấp này. Vui lòng chọn tên khác.");
        }

        private HashSet<string> GetAllPermissionOptions()
        {
            var permissionItems = PermissionHelper.GetAllPermissionOptions();
            var flatList = new HashSet<string>();

            foreach (var permission in permissionItems)
            {
                flatList.Add(permission.Value);
            }
            
            return flatList;
        }

        /// <summary>
        /// Lấy danh sách phẳng tất cả các giá trị quyền hợp lệ từ TcdtPermissions.
        /// </summary>
        private HashSet<string> GetAllPermissionValues()
        {
            var permissionTree = PermissionHelper.GetAllPermissions();
            var flatList = new HashSet<string>();
            FlattenPermissions(permissionTree, flatList);
            return flatList;
        }

        private void FlattenPermissions(IEnumerable<PermissionDisplay> permissions, HashSet<string> flatList)
        {
            foreach (var p in permissions)
            {
                // Nếu có giá trị (là một quyền cụ thể) thì thêm vào list
                if (!string.IsNullOrEmpty(p.Value))
                {
                    flatList.Add(p.Value);
                }

                // Nếu có children, gọi đệ quy
                if (p.Children.Any())
                {
                    FlattenPermissions(p.Children, flatList);
                }
            }
        }
    }
}
