using Microsoft.EntityFrameworkCore;
using SystemService.Domain;

namespace SystemService.Infrastructure.Extensions;

public static class QueryableExtensions
{


    /// <summary>
    /// Tạo một danh sách được phân trang (paged list) từ một nguồn IQueryable.
    /// </summary>
    /// <typeparam name="T">Kiểu đối tượng (Entity type)</typeparam>
    /// <param name="source">Nguồn có thể truy vấn (Queryable source)</param>
    /// <param name="pageIndex">Chỉ mục trang (bắt đầu từ 0)</param>
    /// <param name="pageSize">Kích thước trang</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đã được phân trang.</returns>
    public static async Task<IPagedList<T>> ToPagedListAsync<T>(this IQueryable<T> source, int pageIndex, int pageSize, bool getOnlyTotalCount = false)
    {
        if (source == null)
            return new PagedList<T>(new List<T>(), pageIndex, pageSize);

        //min allowed page size is 1
        pageSize = Math.Max(pageSize, 1);

        var count = await source.CountAsync();

        var data = new List<T>();

        if (!getOnlyTotalCount)
            data.AddRange(await source.Skip(pageIndex * pageSize).Take(pageSize).ToListAsync());

        return new PagedList<T>(data, pageIndex, pageSize, count);
    }
}