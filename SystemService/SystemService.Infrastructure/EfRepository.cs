using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using SystemService.Domain;
using SystemService.Infrastructure.Extensions;
using SystemService.Infrastructure.Persistence;

namespace SystemService.Infrastructure;

/// <summary>
/// Đại diện cho việc triển khai repository (kho lưu trữ) cho đối tượng (entity)
/// </summary>
/// <typeparam name="TEntity">Kiểu đối tượng (Entity type)</typeparam>
/// <typeparam name="TKey">Kiểu của khóa đối tượng</typeparam>
public class EfRepository<TEntity, TKey> : IRepository<TEntity, TKey> where TEntity : BaseEntity<TKey>
{
    #region Fields

    protected readonly SystemDbContext _context;
    private DbSet<TEntity>? _entities;

    #endregion


    #region Ctor

    public EfRepository(SystemDbContext context)
    {
        _context = context ?? throw new ArgumentNullException(nameof(context));
    }

    #endregion

    #region Properties

    protected virtual DbSet<TEntity> Entities => _entities ??= _context.Set<TEntity>();

    /// <summary>
    /// Lấy một bảng (table)
    /// </summary>
    public virtual IQueryable<TEntity> Table => Entities;

    #endregion

    #region Utilities

    protected virtual IQueryable<TEntity> AddDeletedFilter(IQueryable<TEntity> query, bool includeDeleted)
    {
        if (includeDeleted)
            return query;

        if (typeof(ISoftDeletedEntity).IsAssignableFrom(typeof(TEntity)))
            query = query.Where(e => !((ISoftDeletedEntity)e).IsDeleted);

        return query;
    }

    #endregion

    #region Methods

    /// <summary>
    /// Lấy một đối tượng theo định danh của nó
    /// </summary>
    /// <param name="id">Định danh (Identifier)</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm - soft-deleted entities)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa đối tượng.</returns>
    public virtual async Task<TEntity?> GetByIdAsync(TKey id, bool includeDeleted = false)
    {
        if (id == null)
            return null;

        var entity = await Entities.FindAsync(id);

        if (entity == null)
            return null;

        if (!includeDeleted && entity is ISoftDeletedEntity soft && soft.IsDeleted)
            return null;

        return entity;
    }

    /// <summary>
    /// Lấy một đối tượng theo định danh của nó
    /// </summary>
    /// <param name="id">Định danh (Identifier)</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác đồng bộ. Kết quả tác vụ chứa đối tượng.</returns>
    public virtual TEntity? GetById(TKey id, bool includeDeleted = false)
    {
        if (id == null)
            return null;

        var entity = Entities.Find(id);

        if (entity == null)
            return null;

        if (!includeDeleted && entity is ISoftDeletedEntity soft && soft.IsDeleted)
            return null;

        return entity;
    }

    /// <summary>
    /// Lấy một đối tượng theo định danh của nó
    /// </summary>
    /// <param name="ids">Định danh (Identifier)</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đối tượng.</returns>
    public virtual async Task<IList<TEntity>> GetByIdsAsync(IList<TKey> ids, bool includeDeleted = false)
    {
        if (ids == null || ids.Count == 0)
            return new List<TEntity>();

        var query = AddDeletedFilter(Table, includeDeleted);
        return await query.Where(e => ids.Contains(e.Id)).ToListAsync();
    }

    /// <summary>
    /// Tìm đối tượng đầu tiên (hoặc null) khớp với một điều kiện.
    /// </summary>
    /// <param name="predicate">Điều kiện lọc</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Entity or Null</returns>
    public virtual async Task<TEntity?> FirstOrDefaultAsync(Expression<Func<TEntity, bool>> predicate, bool includeDeleted = false)
    {
        var query = AddDeletedFilter(Table, includeDeleted);
        return await query.FirstOrDefaultAsync(predicate);
    }

    /// <summary>
    /// Tìm tất cả các đối tượng khớp với một điều kiện.
    /// </summary>
    /// <param name="predicate">Điều kiện lọc</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Entities</returns>
    public virtual async Task<IList<TEntity>> FindAsync(Expression<Func<TEntity, bool>> predicate, bool includeDeleted = false)
    {
        var query = AddDeletedFilter(Table, includeDeleted);
        return await query.Where(predicate).ToListAsync();
    }

    /// <summary>
    /// Kiểm tra xem có bất kỳ đối tượng nào khớp với điều kiện không.
    /// </summary>
    /// <param name="predicate">Điều kiện lọc</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>True/False</returns>
    public virtual async Task<bool> AnyAsync(Expression<Func<TEntity, bool>> predicate, bool includeDeleted = false, CancellationToken cancellationToken = default)
    {
        var query = AddDeletedFilter(Table, includeDeleted);
        return await query.AnyAsync(predicate, cancellationToken);
    }

    /// <summary>
    /// Đếm số lượng đối tượng khớp với điều kiện.
    /// </summary>
    /// <param name="predicate">Điều kiện lọc</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Số lượng đối tượng</returns>
    public virtual async Task<int> CountAsync(Expression<Func<TEntity, bool>> predicate, bool includeDeleted = false)
    {
        var query = AddDeletedFilter(Table, includeDeleted);
        return await query.CountAsync(predicate);
    }

    /// <summary>
    /// Lấy tất cả các đối tượng
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác đồng bộ. Kết quả tác vụ chứa danh sách đối tượng.</returns>
    public virtual async Task<IList<TEntity>> GetAllAsync(Func<IQueryable<TEntity>, IQueryable<TEntity>>? func = null, bool includeDeleted = false)
    {
        var query = AddDeletedFilter(Table, includeDeleted);
        query = func != null ? func(query) : query;

        return await query.ToListAsync();
    }

    /// <summary>
    /// Lấy tất cả các đối tượng
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đối tượng.</returns>
    public virtual async Task<IList<TEntity>> GetAllAsync(Func<IQueryable<TEntity>, Task<IQueryable<TEntity>>>? func = null, bool includeDeleted = false)
    {
        var query = AddDeletedFilter(Table, includeDeleted);

        query = func != null ? await func(query) : query;

        return await query.ToListAsync();
    }

    /// <summary>
    /// Lấy tất cả các đối tượng
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Danh sách đối tượng.</returns>
    public virtual IList<TEntity> GetAll(Func<IQueryable<TEntity>, IQueryable<TEntity>>? func = null, bool includeDeleted = false)
    {
        var query = AddDeletedFilter(Table, includeDeleted);

        query = func != null ? func(query) : query;

        return query.ToList();
    }

    /// <summary>
    /// Lấy tất cả các đối tượng được phân trang
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="pageIndex">Chỉ số trang</param>
    /// <param name="pageSize">Kích thước trang</param>
    /// <param name="getOnlyTotalCount">Chỉ lấy tổng số bản ghi</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đối tượng đã được phân trang.</returns>
    public virtual async Task<IPagedList<TEntity>> GetAllPagedAsync(Func<IQueryable<TEntity>, IQueryable<TEntity>>? func = null, int pageIndex = 0, int pageSize = int.MaxValue, bool getOnlyTotalCount = false, bool includeDeleted = false)
    {
        var query = AddDeletedFilter(Table, includeDeleted);

        query = func != null ? func(query) : query;

        return await query.ToPagedListAsync(pageIndex, pageSize, getOnlyTotalCount);
    }

    /// <summary>
    /// Lấy tất cả các đối tượng được phân trang
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="pageIndex">Chỉ số trang</param>
    /// <param name="pageSize">Kích thước trang</param>
    /// /// <param name="getOnlyTotalCount">Chỉ lấy tổng số bản ghi</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đối tượng đã được phân trang.</returns>
    public virtual async Task<IPagedList<TEntity>> GetAllPagedAsync(Func<IQueryable<TEntity>, Task<IQueryable<TEntity>>>? func = null, int pageIndex = 0, int pageSize = int.MaxValue, bool getOnlyTotalCount = false, bool includeDeleted = false)
    {
        var query = AddDeletedFilter(Table, includeDeleted);

        query = func != null ? await func(query) : query;

        return await query.ToPagedListAsync(pageIndex, pageSize, getOnlyTotalCount);
    }

    /// <summary>
    /// Chèn một đối tượng mới
    /// </summary>
    /// <param name="entity">Đối tượng cần chèn</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    public virtual async Task InsertAsync(TEntity entity)
    {
        ArgumentNullException.ThrowIfNull(entity);
        await Entities.AddAsync(entity);
    }

    /// <summary>
    /// Chèn một đối tượng mới
    /// </summary>
    /// <param name="entity">Đối tượng cần chèn</param>
    public virtual void Insert(TEntity entity)
    {
        ArgumentNullException.ThrowIfNull(entity);
        Entities.Add(entity);
    }

    /// <summary>
    /// Chèn nhiều đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần chèn</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    public virtual async Task InsertAsync(IEnumerable<TEntity> entities)
    {
        ArgumentNullException.ThrowIfNull(entities);
        await Entities.AddRangeAsync(entities);
    }

    /// <summary>
    /// Chèn nhiều đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần chèn</param>
    public virtual void Insert(IEnumerable<TEntity> entities)
    {
        ArgumentNullException.ThrowIfNull(entities);
        Entities.AddRange(entities);
    }

    /// <summary>
    /// Cập nhật một đối tượng hiện có
    /// </summary>
    /// <param name="entity">Đối tượng cần cập nhật</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    public virtual Task UpdateAsync(TEntity entity)
    {
        ArgumentNullException.ThrowIfNull(entity);
        Entities.Update(entity);
        return Task.CompletedTask;
    }

    /// <summary>
    /// Cập nhật đối tượng
    /// </summary>
    /// <param name="entity">Đối tượng</param>
    public virtual void Update(TEntity entity)
    {
        ArgumentNullException.ThrowIfNull(entity);
        Entities.Update(entity);
    }

    /// <summary>
    /// Cập nhật nhiều đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần cập nhật</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    public virtual Task UpdateAsync(IEnumerable<TEntity> entities)
    {
        ArgumentNullException.ThrowIfNull(entities);

        Entities.UpdateRange(entities);
        return Task.CompletedTask;
    }

    /// <summary>
    /// Cập nhật các đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng</param>
    public virtual void Update(IEnumerable<TEntity> entities)
    {
        ArgumentNullException.ThrowIfNull(entities);
        Entities.UpdateRange(entities);
    }

    /// <summary>
    /// Xóa một đối tượng
    /// </summary>
    /// <param name="entity">Đối tượng cần xóa</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    public virtual Task DeleteAsync(TEntity entity)
    {
        ArgumentNullException.ThrowIfNull(entity);
        switch (entity)
        {
            case ISoftDeletedEntity softDeletedEntity:
                softDeletedEntity.IsDeleted = true;
                Entities.Update(entity);
                break;

            default:
                Entities.Remove(entity);
                break;
        }
        return Task.CompletedTask;
    }

    /// <summary>
    /// Xóa một đối tượng
    /// </summary>
    /// <param name="entity">Đối tượng cần xóa</param>
    public virtual void Delete(TEntity entity)
    {
        ArgumentNullException.ThrowIfNull(entity);
        switch (entity)
        {
            case ISoftDeletedEntity softDeletedEntity:
                softDeletedEntity.IsDeleted = true;
                Entities.Update(entity);
                break;

            default:
                Entities.Remove(entity);
                break;
        }
    }

    /// <summary>
    /// Xóa các đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần xóa</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ</returns>
    public virtual Task DeleteAsync(IEnumerable<TEntity> entities)
    {
        ArgumentNullException.ThrowIfNull(entities);

        if (!entities.Any())
            return Task.CompletedTask;

        var softDeleteList = new List<TEntity>();
        var hardDeleteList = new List<TEntity>();

        foreach (var entity in entities)
        {
            if (entity is ISoftDeletedEntity soft)
            {
                soft.IsDeleted = true;
                softDeleteList.Add(entity);
            }
            else
                hardDeleteList.Add(entity);
        }
        if (softDeleteList.Any())
            Entities.UpdateRange(softDeleteList);

        if (hardDeleteList.Any())
            Entities.RemoveRange(hardDeleteList);

        return Task.CompletedTask;
    }

    /// <summary>
    /// Xóa các đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần xóa</param>
    public virtual void Delete(IEnumerable<TEntity> entities)
    {
        ArgumentNullException.ThrowIfNull(entities);

        if (!entities.Any())
            return;

        var softDeleteList = new List<TEntity>();
        var hardDeleteList = new List<TEntity>();

        foreach (var entity in entities)
        {
            if (entity is ISoftDeletedEntity soft)
            {
                soft.IsDeleted = true;
                softDeleteList.Add(entity);
            }
            else
                hardDeleteList.Add(entity);
        }

        if (softDeleteList.Any())
            Entities.UpdateRange(softDeleteList);

        if (hardDeleteList.Any())
            Entities.RemoveRange(hardDeleteList);
    }

    /// <summary>
    /// Xóa các đối tượng theo điều kiện được truyền vào
    /// </summary>
    /// <param name="predicate">Một hàm để kiểm tra điều kiện cho từng phần tử</param>
    /// <returns>
    /// Một tác vụ đại diện cho thao tác bất đồng bộ
    /// Kết quả tác vụ chứa số lượng bản ghi đã bị xóa
    /// </returns>
    public virtual async Task<int> DeleteAsync(Expression<Func<TEntity, bool>> predicate)
    {
        ArgumentNullException.ThrowIfNull(predicate);

        var entities = await AddDeletedFilter(Table, true).Where(predicate).ToListAsync();
        if (!entities.Any())
            return 0;

        await DeleteAsync(entities);
        return entities.Count;
    }

    /// <summary>
    /// Xóa các đối tượng theo điều kiện được truyền vào
    /// </summary>
    /// <param name="predicate">Một hàm để kiểm tra điều kiện cho từng phần tử</param>
    /// <returns>
    /// Số lượng bản ghi đã bị xóa
    /// </returns>
    public virtual int Delete(Expression<Func<TEntity, bool>> predicate)
    {
        ArgumentNullException.ThrowIfNull(predicate);

        var entities = AddDeletedFilter(Table, true).Where(predicate).ToList();
        if (!entities.Any())
            return 0;

        Delete(entities);
        return entities.Count;
    }

    /// <summary>
    /// Lấy các đối tượng bằng cách sử dụng một câu lệnh SQL thô
    /// </summary>
    /// <param name="sql">Câu lệnh SQL thô</param>
    /// <param name="parameters">Các tham số áp dụng cho câu lệnh SQL thô</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách các đối tượng.</returns>
    public virtual async Task<IList<TEntity>> GetFromSqlAsync(string sql, params object[] parameters)
    {
        return await Entities.FromSqlRaw(sql, parameters).ToListAsync();
    }

    /// <summary>
    /// Thực thi một câu lệnh SQL thô (non-query) hoặc gọi một stored procedure
    /// </summary>
    /// <param name="sql">Câu lệnh SQL thô</param>
    /// <param name="parameters">Các tham số áp dụng cho câu lệnh SQL thô</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa số lượng bản ghi bị ảnh hưởng.</returns>
    public virtual async Task<int> ExecuteSqlAsync(string sql, params object[] parameters)
    {
        return await _context.Database.ExecuteSqlRawAsync(sql, parameters);
    }
    #endregion

}