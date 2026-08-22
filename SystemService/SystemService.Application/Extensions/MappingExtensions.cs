using AutoMapper;
using SystemService.Application.Models;
using SystemService.Domain;
using SystemService.Domain.Shadow;

namespace SystemService.Application.Extensions;

/// <summary>
/// Chứa các phương thức mở rộng để ánh xạ giữa Entity và Model.
/// </summary>
public static class MappingExtensions
{
    #region Model-Entity mapping

    /// <summary>
    /// Ánh xạ một Entity sang một Model mới.
    /// </summary>
    /// <typeparam name="TModel">Kiểu Model đích.</typeparam>
    /// <param name="entity">Entity nguồn.</param>
    /// <param name="mapper">Instance của IMapper.</param>
    /// <returns>Model mới đã được ánh xạ.</returns>
    public static TModel ToModel<TModel>(this ShadowBaseEntity entity, IMapper mapper) where TModel : BaseModel
    {
        ArgumentNullException.ThrowIfNull(entity);
        return mapper.Map<TModel>(entity);
    }

    /// <summary>
    /// Ánh xạ một Entity vào một Model đã tồn tại.
    /// </summary>
    /// <typeparam name="TEntity">Kiểu Entity nguồn.</typeparam>
    /// <typeparam name="TModel">Kiểu Model đích.</typeparam>
    /// <param name="entity">Entity nguồn.</param>
    /// <param name="model">Model đích đã tồn tại.</param>
    /// <param name="mapper">Instance của IMapper.</param>
    /// <returns>Model đích đã được cập nhật.</returns>
    public static TModel ToModel<TEntity, TModel>(this TEntity entity, TModel model, IMapper mapper)
        where TEntity : ShadowBaseEntity where TModel : BaseModel
    {
        ArgumentNullException.ThrowIfNull(entity);
        ArgumentNullException.ThrowIfNull(model);
        return mapper.Map(entity, model);
    }

    /// <summary>
    /// Ánh xạ một IEnumerable của Entity sang một List của Model.
    /// </summary>
    /// <typeparam name="TModel">Kiểu Model đích.</typeparam>
    /// <param name="entities">Danh sách các Entity nguồn.</param>
    /// <param name="mapper">Instance của IMapper.</param>
    /// <returns>Một List các Model đã được ánh xạ.</returns>
    public static IList<TModel> ToModel<TModel>(this IEnumerable<ShadowBaseEntity> entities, IMapper mapper) where TModel : BaseModel
    {
        ArgumentNullException.ThrowIfNull(entities);
        return mapper.Map<List<TModel>>(entities);
    }

    /// <summary>
    /// Ánh xạ một Model sang một Entity mới.
    /// </summary>
    /// <typeparam name="TEntity">Kiểu Entity đích.</typeparam>
    /// <param name="model">Model nguồn.</param>
    /// <param name="mapper">Instance của IMapper.</param>
    /// <returns>Entity mới đã được ánh xạ.</returns>
    public static TEntity ToEntity<TEntity>(this BaseModel model, IMapper mapper) where TEntity : ShadowBaseEntity
    {
        ArgumentNullException.ThrowIfNull(model);
        return mapper.Map<TEntity>(model);
    }

    /// <summary>
    /// Ánh xạ một Model vào một Entity đã tồn tại.
    /// </summary>
    /// <typeparam name="TEntity">Kiểu Entity đích.</typeparam>
    /// <typeparam name="TModel">Kiểu Model nguồn.</typeparam>
    /// <param name="model">Model nguồn.</param>
    /// <param name="entity">Entity đích đã tồn tại.</param>
    /// <param name="mapper">Instance của IMapper.</param>
    /// <returns>Entity đích đã được cập nhật.</returns>
    public static TEntity ToEntity<TEntity, TModel>(this TModel model, TEntity entity, IMapper mapper)
        where TEntity : ShadowBaseEntity where TModel : BaseModel
    {
        ArgumentNullException.ThrowIfNull(model);
        ArgumentNullException.ThrowIfNull(entity);
        return mapper.Map(model, entity);
    }

    #endregion

    #region PagedList mapping

    /// <summary>
    /// Ánh xạ một IPagedList của Entity sang một IPagedList của Model.
    /// </summary>
    /// <typeparam name="TModel">Kiểu Model đích.</typeparam>
    /// <typeparam name="TEntity">Kiểu Entity nguồn.</typeparam>
    /// <param name="pagedList">Danh sách Entity đã phân trang.</param>
    /// <param name="mapper">Instance của IMapper.</param>
    /// <returns>Danh sách Model đã được phân trang.</returns>
    public static IPagedList<TModel> ToModel<TModel, TEntity>(this IPagedList<TEntity> pagedList, IMapper mapper)
        where TModel : BaseModel
        where TEntity : ShadowBaseEntity
    {
        var destinationData = mapper.Map<IEnumerable<TModel>>(pagedList);
        return new PagedListModel<TModel>(destinationData, pagedList.PageIndex, pagedList.PageSize, pagedList.TotalCount);
    }

    /// <summary>
    /// Ánh xạ một <see cref="IPagedList{TEntity}"/> sang một <see cref="IPagedList{TModel}"/> 
    /// bằng cách map từng phần tử riêng lẻ thay vì map toàn bộ danh sách.
    /// </summary>
    /// <typeparam name="TModel">Kiểu Model đích.</typeparam>
    /// <typeparam name="TEntity">Kiểu Entity nguồn.</typeparam>
    /// <param name="pagedList">Danh sách Entity đã được phân trang.</param>
    /// <param name="mapper">Instance của <see cref="IMapper"/> dùng để thực hiện ánh xạ.</param>
    /// <returns>
    /// Trả về một <see cref="PagedListModel{TModel}"/> chứa các phần tử đã được ánh xạ, 
    /// cùng với thông tin phân trang (<c>PageIndex</c>, <c>PageSize</c>, <c>TotalCount</c>).
    /// </returns>
    /// <remarks>
    /// Hàm này được thiết kế để thay thế cho <see cref="ToModel{TModel, TEntity}(IPagedList{TEntity}, IMapper)"/>
    /// trong trường hợp AutoMapper không hỗ trợ ánh xạ trực tiếp từ <see cref="IPagedList{TEntity}"/> 
    /// sang <see cref="IEnumerable{TModel}"/>. 
    /// 
    /// Thay vì map toàn bộ danh sách, hàm này sẽ thực hiện ánh xạ từng phần tử riêng lẻ,
    /// đảm bảo kết quả luôn hợp lệ ngay cả khi cấu hình AutoMapper chưa đầy đủ.
    /// </remarks>
    public static IPagedList<TModel> ToModelSafe<TModel, TEntity>(
        this IPagedList<TEntity> pagedList,
        IMapper mapper)
        where TModel : BaseModel
        where TEntity : ShadowBaseEntity
    {
        if (pagedList == null)
            return new PagedListModel<TModel>(new List<TModel>(), 0, 0, 0);

        var destinationData = pagedList
            .Select(entity => mapper.Map<TModel>(entity))
            .ToList();

        return new PagedListModel<TModel>(
            destinationData,
            pagedList.PageIndex,
            pagedList.PageSize,
            pagedList.TotalCount
        );
    }



    #endregion
}