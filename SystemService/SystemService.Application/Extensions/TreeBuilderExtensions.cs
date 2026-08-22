using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SystemService.Application.Extensions;

public static class TreeBuilderExtensions
{
    /// <summary>
    /// Xây dựng một cấu trúc cây từ một danh sách phẳng các đối tượng.
    /// </summary>
    /// <typeparam name="TEntity">Kiểu của đối tượng trong danh sách (ví dụ: DmDonVi).</typeparam>
    /// <typeparam name="TKey">Kiểu của khóa chính (ví dụ: int, Guid).</typeparam>
    /// <param name="allItems">Danh sách phẳng tất cả các đối tượng.</param>
    /// <param name="idSelector">Một hàm để lấy Id từ một đối tượng.</param>
    /// <param name="parentIdSelector">Một hàm để lấy Id của đối tượng cha.</param>
    /// <param name="addChildAction">Một hành động để thêm một đối tượng con vào danh sách con của đối tượng cha.</param>
    /// <returns>Một danh sách chỉ chứa các đối tượng gốc (root nodes).</returns>
    public static List<TEntity> BuildTree<TEntity, TKey>(
        IEnumerable<TEntity> allItems,
        Func<TEntity, TKey> idSelector,
        Func<TEntity, TKey?> parentIdSelector=null,
        Action<TEntity, TEntity> addChildAction = null)
        where TKey : struct 
    {
        if (parentIdSelector == null || addChildAction == null)
        {
            return [.. allItems];
        }

        var lookup = allItems.ToDictionary(idSelector);
        var rootNodes = new List<TEntity>();

        foreach (var item in allItems)
        {
            var parentId = parentIdSelector(item);

            if (parentId.HasValue && lookup.TryGetValue(parentId.Value, out var parent))
            {
                addChildAction(parent, item);
            }
            else
            {
                rootNodes.Add(item);
            }
        }

        return rootNodes;
    }
}
