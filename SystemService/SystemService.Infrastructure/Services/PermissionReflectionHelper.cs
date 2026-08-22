using Shared.Security.Permissions;
using System.ComponentModel;
using System.Reflection;

namespace SystemService.Infrastructure.Services;

public sealed record PermissionSeed(string Name, string Description, string GroupPath);

public static class PermissionReflectionHelper
{
    public static List<PermissionSeed> GetAll()
    {
        var result = new List<PermissionSeed>();
        foreach (var group in typeof(CorePermissions).GetNestedTypes())
            Walk(group, parentPath: null, result);
        return result;
    }

    private static void Walk(Type type, string? parentPath, List<PermissionSeed> result)
    {
        var groupName = type.GetCustomAttribute<DescriptionAttribute>()?.Description ?? type.Name;
        var groupPath = parentPath is null ? groupName : $"{parentPath}|{groupName}";

        foreach (var child in type.GetNestedTypes().Where(t => t.IsClass))
            Walk(child, groupPath, result);

        foreach (var field in type
                     .GetFields(BindingFlags.Public | BindingFlags.Static)
                     .Where(f => f.IsLiteral && f.FieldType == typeof(string)))
        {
            var name = (string?)field.GetValue(null);
            if (string.IsNullOrEmpty(name)) continue;

            var description = field.GetCustomAttribute<DescriptionAttribute>()?.Description ?? field.Name;
            result.Add(new PermissionSeed(name, description, groupPath));
        }
    }
}
