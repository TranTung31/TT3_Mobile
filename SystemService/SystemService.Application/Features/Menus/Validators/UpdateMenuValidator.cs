using FluentValidation;
using Shared.Security.Permissions;
using SystemService.Application.Features.Menus.Commands;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Menus.Validators
{
    public class UpdateMenuValidator : AbstractValidator<UpdateMenuCommand>
    {
        private readonly IApplicationMenuRepository _menuRepository;

        public UpdateMenuValidator(IApplicationMenuRepository menuRepository)
        {
            _menuRepository = menuRepository;

            RuleFor(v => v.Model.Name)
                .NotEmpty().WithMessage("Tên menu là bắt buộc.");

            RuleForEach(v => v.Model.PermissionNames)
                .NotEmpty().WithMessage("Tên quyền không được để trống.")
                .Must(p => GetAllPermissionOptions().Contains(p))
                .WithMessage("'{PropertyValue}' không phải là một quyền hợp lệ.");

            // RuleFor bây giờ áp dụng cho toàn bộ command (v), không chỉ v.Model
            // để có thể truy cập cả command.Id và command.Model
            //RuleFor(v => v)
            //    .MustAsync(async (command, cancellation) =>
            //    {
            //        // Truyền command.Id vào làm tham số idToIgnore
            //        return await _menuRepository.IsNameUniqueAsync(
            //            command.Model.Name,
            //            command.Model.ParentId,
            //            command.Id,
            //            cancellation);
            //    })
            //    // WithMessage có thể cần chỉ định thuộc tính gây lỗi để hiển thị trên UI
            //    .WithMessage("Tên menu đã tồn tại ở cấp này. Vui lòng chọn tên khác.")
            //    .WithName("Name"); // Gán lỗi này cho thuộc tính 'Name'
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
