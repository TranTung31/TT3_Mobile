using System.Linq.Expressions;

namespace SystemService.Domain;

/// <summary>
/// Đại diện cho một repository chung (generic repository) cho các đối tượng (entities)
/// </summary>
/// <typeparam name="TEntity">Kiểu của đối tượng (entity)</typeparam>
/// <typeparam name="TKey">Kiểu của khóa (key) của đối tượng</typeparam>
public interface IRepository<TEntity, TKey> where TEntity : BaseEntity<TKey>
{
    #region Properties

    /// <summary>
    /// Lấy một bảng (table)
    /// </summary>
    IQueryable<TEntity> Table { get; }

    #endregion

    #region Methods

    /// <summary>
    /// Lấy một đối tượng theo định danh của nó
    /// </summary>
    /// <param name="id">Định danh (Identifier)</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm - soft-deleted entities)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa đối tượng.</returns>
    Task<TEntity?> GetByIdAsync(TKey id, bool includeDeleted = false);

    /// <summary>
    /// Lấy một đối tượng theo định danh của nó
    /// </summary>
    /// <param name="id">Định danh (Identifier)</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác đồng bộ. Kết quả tác vụ chứa đối tượng.</returns>
    TEntity? GetById(TKey id, bool includeDeleted = false);

    /// <summary>
    /// Lấy một đối tượng theo định danh của nó
    /// </summary>
    /// <param name="ids">Định danh (Identifier)</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đối tượng.</returns>
    Task<IList<TEntity>> GetByIdsAsync(IList<TKey> ids, bool includeDeleted = false);


    /// <summary>
    /// Tìm đối tượng đầu tiên (hoặc null) khớp với một điều kiện.
    /// </summary>
    /// <param name="predicate">Điều kiện lọc</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Entity or Null</returns>
    Task<TEntity?> FirstOrDefaultAsync(Expression<Func<TEntity, bool>> predicate, bool includeDeleted = false);

    /// <summary>
    /// Tìm tất cả các đối tượng khớp với một điều kiện.
    /// </summary>
    /// <param name="predicate">Điều kiện lọc</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Entities</returns>
    Task<IList<TEntity>> FindAsync(Expression<Func<TEntity, bool>> predicate, bool includeDeleted = false);

    /// <summary>
    /// Kiểm tra xem có bất kỳ đối tượng nào khớp với điều kiện không.
    /// </summary>
    /// <param name="predicate">Điều kiện lọc</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>True/False</returns>
    Task<bool> AnyAsync(Expression<Func<TEntity, bool>> predicate, bool includeDeleted = false, CancellationToken cancellationToken = default);

    /// <summary>
    /// Đếm số lượng đối tượng khớp với điều kiện.
    /// </summary>
    /// <param name="predicate">Điều kiện lọc</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Số lượng đối tượng</returns>
    Task<int> CountAsync(Expression<Func<TEntity, bool>> predicate, bool includeDeleted = false);

    /// <summary>
    /// Lấy tất cả các đối tượng
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác đồng bộ. Kết quả tác vụ chứa danh sách đối tượng.</returns>
    Task<IList<TEntity>> GetAllAsync(Func<IQueryable<TEntity>, IQueryable<TEntity>>? func = null, bool includeDeleted = false);

    /// <summary>
    /// Lấy tất cả các đối tượng
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đối tượng.</returns>
    Task<IList<TEntity>> GetAllAsync(Func<IQueryable<TEntity>, Task<IQueryable<TEntity>>>? func = null, bool includeDeleted = false);

    /// <summary>
    /// Lấy tất cả các đối tượng
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Danh sách đối tượng.</returns>
    IList<TEntity> GetAll(Func<IQueryable<TEntity>, IQueryable<TEntity>>? func = null, bool includeDeleted = false);

    /// <summary>
    /// Lấy tất cả các đối tượng được phân trang
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="pageIndex">Chỉ số trang</param>
    /// <param name="pageSize">Kích thước trang</param>
    /// <param name="getOnlyTotalCount">Chỉ lấy tổng số bản ghi</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đối tượng đã được phân trang.</returns>
    Task<IPagedList<TEntity>> GetAllPagedAsync(Func<IQueryable<TEntity>, IQueryable<TEntity>>? func = null,
        int pageIndex = 0, int pageSize = int.MaxValue, bool getOnlyTotalCount = false, bool includeDeleted = false);

    /// <summary>
    /// Lấy tất cả các đối tượng được phân trang
    /// </summary>
    /// <param name="func">Một hàm để xây dựng truy vấn</param>
    /// <param name="pageIndex">Chỉ số trang</param>
    /// <param name="pageSize">Kích thước trang</param>
    /// /// <param name="getOnlyTotalCount">Chỉ lấy tổng số bản ghi</param>
    /// <param name="includeDeleted">Một giá trị cho biết có bao gồm các bản ghi đã xóa hay không (đối với các đối tượng bị xóa mềm)</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách đối tượng đã được phân trang.</returns>
    Task<IPagedList<TEntity>> GetAllPagedAsync(Func<IQueryable<TEntity>, Task<IQueryable<TEntity>>>? func = null,
        int pageIndex = 0, int pageSize = int.MaxValue, bool getOnlyTotalCount = false, bool includeDeleted = false);

    /// <summary>
    /// Chèn một đối tượng mới
    /// </summary>
    /// <param name="entity">Đối tượng cần chèn</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    Task InsertAsync(TEntity entity);

    /// <summary>
    /// Chèn một đối tượng mới
    /// </summary>
    /// <param name="entity">Đối tượng cần chèn</param>
    void Insert(TEntity entity);

    /// <summary>
    /// Chèn nhiều đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần chèn</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    Task InsertAsync(IEnumerable<TEntity> entities);

    /// <summary>
    /// Chèn nhiều đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần chèn</param>
    void Insert(IEnumerable<TEntity> entities);

    /// <summary>
    /// Cập nhật một đối tượng hiện có
    /// </summary>
    /// <param name="entity">Đối tượng cần cập nhật</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    Task UpdateAsync(TEntity entity);

    /// <summary>
    /// Cập nhật đối tượng
    /// </summary>
    /// <param name="entity">Đối tượng</param>
    void Update(TEntity entity);

    /// <summary>
    /// Cập nhật nhiều đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần cập nhật</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    Task UpdateAsync(IEnumerable<TEntity> entities);

    /// <summary>
    /// Cập nhật các đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng</param>
    void Update(IEnumerable<TEntity> entities);

    /// <summary>
    /// Xóa một đối tượng
    /// </summary>
    /// <param name="entity">Đối tượng cần xóa</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ.</returns>
    Task DeleteAsync(TEntity entity);

    /// <summary>
    /// Xóa một đối tượng
    /// </summary>
    /// <param name="entity">Đối tượng cần xóa</param>
    void Delete(TEntity entity);

    /// <summary>
    /// Xóa các đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần xóa</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ</returns>
    Task DeleteAsync(IEnumerable<TEntity> entities);

    /// <summary>
    /// Xóa các đối tượng
    /// </summary>
    /// <param name="entities">Các đối tượng cần xóa</param>
    void Delete(IEnumerable<TEntity> entities);

    /// <summary>
    /// Xóa các đối tượng theo điều kiện được truyền vào
    /// </summary>
    /// <param name="predicate">Một hàm để kiểm tra điều kiện cho từng phần tử</param>
    /// <returns>
    /// Một tác vụ đại diện cho thao tác bất đồng bộ
    /// Kết quả tác vụ chứa số lượng bản ghi đã bị xóa
    /// </returns>
    Task<int> DeleteAsync(Expression<Func<TEntity, bool>> predicate);

    /// <summary>
    /// Xóa các đối tượng theo điều kiện được truyền vào
    /// </summary>
    /// <param name="predicate">Một hàm để kiểm tra điều kiện cho từng phần tử</param>
    /// <returns>
    /// Số lượng bản ghi đã bị xóa
    /// </returns>
    int Delete(Expression<Func<TEntity, bool>> predicate);


    /// <summary>
    /// Lấy các đối tượng bằng cách sử dụng một câu lệnh SQL thô
    /// </summary>
    /// <param name="sql">Câu lệnh SQL thô</param>
    /// <param name="parameters">Các tham số áp dụng cho câu lệnh SQL thô</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa danh sách các đối tượng.</returns>
    Task<IList<TEntity>> GetFromSqlAsync(string sql, params object[] parameters);

    /// <summary>
    /// Thực thi một câu lệnh SQL thô (non-query) hoặc gọi một stored procedure
    /// </summary>
    /// <param name="sql">Câu lệnh SQL thô</param>
    /// <param name="parameters">Các tham số áp dụng cho câu lệnh SQL thô</param>
    /// <returns>Một tác vụ đại diện cho thao tác bất đồng bộ. Kết quả tác vụ chứa số lượng bản ghi bị ảnh hưởng.</returns>
    Task<int> ExecuteSqlAsync(string sql, params object[] parameters);
    #endregion
}