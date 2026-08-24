using Microsoft.AspNetCore.Authorization;

namespace Shared.Security.Authorization;

public enum LogicalOperator
{
    And,
    Or
}

/// <summary>
/// Attribute để yêu cầu một quyền cụ thể.
/// Kế thừa từ AuthorizeAttribute và thiết lập sẵn Policy.
/// <code>
/// 
///Chỉ cần 1 quyền
///- [RequiredPermission("products.view")]
///Người dùng phải có CẢ hai quyền: "products.edit" VÀ "products.publish"
///
///- [RequiredPermission(LogicalOperator.And, "products.edit", "products.publish")]
///Người dùng chỉ cần có quyền "products.delete" HOẶC "products.archive"
///
///- [RequiredPermission(LogicalOperator.Or, "products.delete", "products.archive")]
///</code>
/// </summary>
public class RequiredPermissionAttribute : AuthorizeAttribute
{
    public string[] Permissions { get; }
    public LogicalOperator Operator { get; }

    /// <summary>
    /// Yêu cầu một hoặc nhiều quyền với toán tử logic.
    /// </summary>
    /// <param name="logicalOperator">Toán tử logic AND hoặc OR.</param>
    /// <param name="permissions">Danh sách các quyền cần kiểm tra.</param>
    public RequiredPermissionAttribute(LogicalOperator logicalOperator, params string[] permissions)
    {
        Policy = "HasPermission";
        Permissions = permissions;
        Operator = logicalOperator;
    }

    /// <summary>
    /// Yêu cầu một quyền duy nhất (mặc định là AND).
    /// </summary>
    /// <param name="permission">Quyền cần kiểm tra.</param>
    public RequiredPermissionAttribute(string permission) : this(LogicalOperator.And, permission)
    {
    }
}

