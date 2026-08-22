using System.ComponentModel;
using System.Reflection;

namespace SystemService.Application.Extensions;

public static class EnumExtensions
{
    /// <summary>
    /// Lấy mô tả (Description) của một giá trị enum.
    /// <example>
    /// <code>
    /// public enum MyEnum { [Description("Giá trị đầu tiên")] Value1 }
    /// var description = MyEnum.Value1.GetDescription(); // Kết quả: "Giá trị đầu tiên"
    /// </code>
    /// </example>
    /// </summary>
    /// <param name="value">Giá trị enum.</param>
    /// <returns>Chuỗi mô tả từ [DescriptionAttribute] hoặc tên của enum nếu không có.</returns>

    public static string GetDescription(this Enum value)
    {
        // Lấy thông tin của thành viên enum
        FieldInfo? fieldInfo = value.GetType().GetField(value.ToString());

        if (fieldInfo == null)
            return value.ToString();

        // Lấy DescriptionAttribute
        var attributes = (DescriptionAttribute[])fieldInfo.GetCustomAttributes(typeof(DescriptionAttribute), false);

        // Nếu có attribute, trả về giá trị Description, nếu không, trả về tên của thành viên enum
        return attributes.Length > 0 ? attributes[0].Description : value.ToString();
    }

    /// <summary>
    /// Chuyển đổi một kiểu Enum thành một danh sách các đối tượng để dùng cho select list.
    /// <example>
    /// <code>
    /// var selectList = EnumExtensions.ToSelectList<MyEnum>();
    /// </code>
    /// </example>
    /// </summary>
    /// <typeparam name="TEnum">Kiểu Enum cần chuyển đổi.</typeparam>
    /// <returns>Một danh sách các đối tượng, mỗi đối tượng chứa Value (số) và Text (description).</returns>
    public static IEnumerable<object> ToSelectList<TEnum>() where TEnum : struct, Enum
    {
        return Enum.GetValues<TEnum>()
            .Select(e => new { Value = Convert.ToInt32(e), Text = e.GetDescription() });
    }

    /// <summary>
    /// Chuyển đổi một kiểu Enum thành một danh sách các đối tượng để dùng cho select list, loại trừ một số giá trị.
    /// <example>
    /// <code>
    /// // Bỏ qua một giá trị
    /// var list1 = EnumExtensions.ToSelectList<MyEnum>(MyEnum.ValueToIgnore);
    /// // Bỏ qua nhiều giá trị
    /// var list2 = EnumExtensions.ToSelectList<MyEnum>(MyEnum.Value1, MyEnum.Value2);
    /// </code>
    /// </example>
    /// </summary>
    /// <typeparam name="TEnum">Kiểu Enum cần chuyển đổi.</typeparam>
    /// <param name="valuesToIgnore">Các giá trị enum cần loại bỏ khỏi danh sách.</param>
    /// <returns>Một danh sách các đối tượng, mỗi đối tượng chứa Value (số) và Text (description).</returns>
    public static IEnumerable<object> ToSelectList<TEnum>(params TEnum[] valuesToIgnore) where TEnum : struct, Enum
    {
        if (valuesToIgnore == null || valuesToIgnore.Length == 0)
            return ToSelectList<TEnum>();

        var ignoredValues = new HashSet<TEnum>(valuesToIgnore);

        return Enum.GetValues<TEnum>()
            .Where(e => !ignoredValues.Contains(e))
            .Select(e => new { Value = Convert.ToInt32(e), Text = e.GetDescription() });
    }
}