using System.ComponentModel;
using System.Reflection;

namespace Shared.Security.Permissions;

/// <summary>
/// Định nghĩa các quyền (permissions) của hệ thống một cách tĩnh.
/// Quy ước: "Permissions.GroupName.Action"
/// </summary>
public static class CorePermissions
{
    [Description("Quản lý hệ thống")]
    public static class QuanLyHeThong
    {
        [Description("Quản lý menu")]
        public static class QuanLyMenu
        {
            [Description("Xem")]
            public const string View = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyMenu)}.View";

            [Description("Thêm mới")]
            public const string Create = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyMenu)}.Create";

            [Description("Sửa")]
            public const string Edit = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyMenu)}.Edit";

            [Description("Xóa")]
            public const string Delete = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyMenu)}.Delete";
        }

        [Description("Quản lý người dùng")]
        public static class QuanLyNguoiDung
        {
            [Description("Xem")]
            public const string View = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyNguoiDung)}.View";

            [Description("Thêm mới")]
            public const string Create = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyNguoiDung)}.Create";

            [Description("Sửa")]
            public const string Edit = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyNguoiDung)}.Edit";

            [Description("Xóa")]
            public const string Delete = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyNguoiDung)}.Delete";
        }

        [Description("Quản lý nhóm người dùng")]
        public static class QuanLyNhomNguoiDung
        {
            [Description("Xem")]
            public const string View = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyNhomNguoiDung)}.View";

            [Description("Thêm mới")]
            public const string Create = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyNhomNguoiDung)}.Create";

            [Description("Sửa")]
            public const string Edit = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyNhomNguoiDung)}.Edit";

            [Description("Xóa")]
            public const string Delete = $"{nameof(CorePermissions)}.{nameof(QuanLyHeThong)}.{nameof(QuanLyNhomNguoiDung)}.Delete";
        }
    }

    [Description("Danh mục đơn vị")]
    public static class DmDonVi
    {
        [Description("Xem")]
        public const string View = $"{nameof(CorePermissions)}.{nameof(DmDonVi)}.View";

        [Description("Thêm mới")]
        public const string Create = $"{nameof(CorePermissions)}.{nameof(DmDonVi)}.Create";

        [Description("Sửa thông tin")]
        public const string Edit = $"{nameof(CorePermissions)}.{nameof(DmDonVi)}.Edit";

        [Description("Xóa")]
        public const string Delete = $"{nameof(CorePermissions)}.{nameof(DmDonVi)}.Delete";
    }
}

public static class PermissionHelper
{
    public static List<PermissionDisplay> GetAllPermissions()
    {
        return GetPermissionsRecursive(typeof(CorePermissions));
    }

    private static List<PermissionDisplay> GetPermissionsRecursive(Type parentType)
    {
        var result = new List<PermissionDisplay>();

        // Lấy tất cả class con (nested class)
        var nestedTypes = parentType.GetNestedTypes(BindingFlags.Public);

        foreach (var type in nestedTypes)
        {
            // Lấy mô tả của nhóm (nếu có)
            var groupDescAttr = type.GetCustomAttributes(typeof(DescriptionAttribute), false)
                                    .FirstOrDefault() as DescriptionAttribute;
            string groupDescription = groupDescAttr?.Description ?? type.Name;

            var groupDisplay = new PermissionDisplay
            {
                Group = type.Name,
                Description = groupDescription
            };

            // Lấy tất cả các quyền (const string) trong nhóm hiện tại
            var fields = type.GetFields(BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy)
                             .Where(f => f.FieldType == typeof(string) && f.IsLiteral);

            foreach (var field in fields)
            {
                var fieldDescAttr = field.GetCustomAttributes(typeof(DescriptionAttribute), false)
                                         .FirstOrDefault() as DescriptionAttribute;

                groupDisplay.Children.Add(new PermissionDisplay
                {
                    Group = type.Name,
                    Value = (string)field.GetRawConstantValue(),
                    Description = fieldDescAttr?.Description ?? field.Name
                });
            }

            // 🔁 Gọi đệ quy nếu nhóm này còn nhóm con
            var childGroups = GetPermissionsRecursive(type);
            groupDisplay.Children.AddRange(childGroups);

            result.Add(groupDisplay);
        }

        return result;
    }

    /// <summary>
    /// Lấy danh sách permission (Cho Select)
    /// </summary>
    /// <param name="rootPermissionType">
    /// Filter theo permission group.
    /// Ví dụ: typeof(CorePermissions.DtnsPermissions)
    /// </param>
    /// <returns></returns>
    public static List<PermissionItemModel> GetAllPermissionOptions(Type? rootPermissionType = null)
    {
        var result = new HashSet<PermissionItemModel>(new PermissionItemModelComparer());

        // Nếu không truyền => lấy tất cả như cũ
        if (rootPermissionType == null)
        {
            var permissionsType = typeof(CorePermissions);

            foreach (var nestedType in permissionsType.GetNestedTypes(BindingFlags.Public | BindingFlags.Static))
            {
                ProcessNestedType(nestedType, result, "CorePermissions", "");
            }
        }
        else
        {
            ProcessNestedType(rootPermissionType, result, "CorePermissions", "");
        }

        return result.ToList();
    }

    /// <summary>
    /// Lấy danh sách các permission con (constants) bên trong một nhóm permission.
    /// Không bao gồm nhóm cha, chỉ bao gồm các quyền cụ thể như BaoCao06, BaoCao11.
    /// </summary>
    /// <param name="rootPermissionType">Ví dụ: typeof(CorePermissions.ReportPermissions)</param>
    /// <returns>Danh sách permission options</returns>
    public static List<PermissionItemModel> GetPermissionChildren(Type rootPermissionType)
    {
        var result = new List<PermissionItemModel>();
        GetPermissionChildrenRecursive(rootPermissionType, result, "");
        return result;
    }

    private static void GetPermissionChildrenRecursive(Type type, List<PermissionItemModel> result, string parentLabel)
    {
        var typeDescription = type.GetCustomAttribute<DescriptionAttribute>()?.Description ?? type.Name;
        var currentLabel = string.IsNullOrEmpty(parentLabel) ? typeDescription : $"{parentLabel} - {typeDescription}";

        // Lấy tất cả các constants (fields) trong class hiện tại
        var fields = type.GetFields(BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy)
                        .Where(f => f.FieldType == typeof(string) && f.IsLiteral && !f.IsInitOnly);

        foreach (var field in fields)
        {
            var fieldDescAttr = field.GetCustomAttribute<DescriptionAttribute>();
            var fieldDescription = fieldDescAttr?.Description ?? field.Name;
            var fieldValue = field.GetValue(null) as string;

            if (!string.IsNullOrEmpty(fieldValue))
            {
                result.Add(new PermissionItemModel
                {
                    Value = fieldValue,
                    Label = $"{currentLabel} - {fieldDescription}"
                });
            }
        }

        // Đệ quy xử lý các nested classes bên trong
        foreach (var nestedType in type.GetNestedTypes(BindingFlags.Public | BindingFlags.Static))
        {
            GetPermissionChildrenRecursive(nestedType, result, currentLabel);
        }
    }

    private static void ProcessNestedType(Type type, HashSet<PermissionItemModel> result, string path, string labelPath)
    {
        // Lấy Description của class hiện tại
        var typeDescription = type.GetCustomAttribute<DescriptionAttribute>()?.Description ?? type.Name;
        var currentPath = $"{path}.{type.Name}";
        var currentLabel = string.IsNullOrEmpty(labelPath) ? typeDescription : $"{labelPath} - {typeDescription}";

        // Kiểm tra xem class này có chứa các constants (View, Create, Edit, Delete) không
        var hasPermissionConstants = type.GetFields(BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy)
            .Any(f => f.IsLiteral && !f.IsInitOnly);

        // Nếu có constants thì đây là một permission group
        if (hasPermissionConstants)
        {
            result.Add(new PermissionItemModel
            {
                Value = currentPath,
                Label = currentLabel
            });
        }

        // Đệ quy xử lý các nested classes bên trong
        foreach (var nestedType in type.GetNestedTypes(BindingFlags.Public | BindingFlags.Static))
        {
            ProcessNestedType(nestedType, result, currentPath, currentLabel);
        }
    }

    private class PermissionItemModelComparer : IEqualityComparer<PermissionItemModel>
    {
        public bool Equals(PermissionItemModel x, PermissionItemModel y)
        {
            if (x == null || y == null) return false;
            return x.Value == y.Value;
        }

        public int GetHashCode(PermissionItemModel obj)
        {
            return obj.Value?.GetHashCode() ?? 0;
        }
    }
}
public static class PermissionDiscovery
{
    public class PermissionInfo
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public List<string> GroupPath { get; set; }
    }

    public static List<PermissionInfo> GetAllPermissions()
    {
        var permissions = new List<PermissionInfo>();
        var rootType = typeof(CorePermissions);

        FindPermissionsRecursive(rootType, permissions, "", []);

        return permissions;
    }

    private static void FindPermissionsRecursive(Type type, List<PermissionInfo> permissions, string parentNamePath, List<string> parentGroupPath)
    {
        // 1. Xây dựng đường dẫn tên cho cấp hiện tại
        var currentNamePath = string.IsNullOrEmpty(parentNamePath) ? type.Name : $"{parentNamePath}.{type.Name}";
        // 2. Xây dựng đường dẫn nhóm cho cấp hiện tại
        var currentGroupPath = new List<string>(parentGroupPath);
        // Bỏ qua việc thêm mô tả của lớp gốc "CorePermissions" vào đường dẫn nhóm
        if (type != typeof(CorePermissions))
        {
            var typeDescription = type.GetCustomAttribute<DescriptionAttribute>()?.Description ?? type.Name;
            currentGroupPath.Add(typeDescription);
        }
        // 3. Lấy tất cả các quyền (const string) trong lớp hiện tại và thêm vào danh sách
        var fields = type.GetFields(BindingFlags.Public | BindingFlags.Static | BindingFlags.FlattenHierarchy)
                         .Where(f => f.IsLiteral && f.FieldType == typeof(string));
        foreach (var field in fields)
        {
            permissions.Add(new PermissionInfo
            {
                Name = $"{currentNamePath}.{field.Name}",
                Description = field.GetCustomAttribute<DescriptionAttribute>()?.Description ?? field.Name,
                GroupPath = currentGroupPath // Gán đường dẫn nhóm đã được xây dựng
            });
        }
        // 4. Luôn luôn đệ quy vào các lớp con (nested types)
        foreach (var nestedType in type.GetNestedTypes(BindingFlags.Public | BindingFlags.Static))
        {
            FindPermissionsRecursive(nestedType, permissions, currentNamePath, currentGroupPath);
        }
    }
}
public class PermissionDisplay
{
    public string Group { get; set; }
    public string Value { get; set; }
    public string Description { get; set; }

    public List<PermissionDisplay> Children { get; set; } = new List<PermissionDisplay>();
}
public class PermissionItemModel
{
    public string Value { get; set; }
    public string Label { get; set; }
}