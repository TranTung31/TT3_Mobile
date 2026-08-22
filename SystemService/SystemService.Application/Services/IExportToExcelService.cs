namespace SystemService.Application.Services
{
    public interface IExportToExcelService
    {
        Task<byte[]> ExportToExcel<T>(
            IEnumerable<T> data,
            Dictionary<string, Func<T, object>> columnMappings,
            bool isIncludeSerialNumber,
            string? fileName,
            string? note,
            string? reportTitle = null
        );

        Task<byte[]> ExportToExcelHierarchy<T>(
            IEnumerable<T> treeData,
            Func<T, IEnumerable<T>?> childrenSelector,
            Dictionary<string, Func<T, int, object>> columnMappings,
            bool isIncludeSerialNumber,
            string? fileName,
            string? note,
            string? reportTitle = null
        );
    }
}
