namespace SystemService.Domain;

/// <summary>
/// Đại diện cho một đơn vị công việc (Unit of Work).
/// </summary>
public interface IUnitOfWork : IAsyncDisposable
{
    /// <summary>
    /// Lưu tất cả các thay đổi được theo dõi trong DbContext vào cơ sở dữ liệu.
    /// </summary>
    /// <param name="cancellationToken">Token để hủy bỏ thao tác.</param>
    /// <returns>Số lượng bản ghi bị ảnh hưởng.</returns>
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Bắt đầu một transaction mới.
    /// </summary>
    Task BeginTransactionAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Commit transaction hiện tại.
    /// </summary>
    Task CommitTransactionAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Rollback transaction hiện tại.
    /// </summary>
    Task RollbackTransactionAsync(CancellationToken cancellationToken = default);
}