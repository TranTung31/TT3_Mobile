namespace SystemService.Application.Models.Catalog.DmMaCtmt
{
    public record DmMaCtmtSearchModel : BaseSearchModel
    {
        /// <summary>
        /// Từ khóa tìm kiếm.
        /// </summary>
        public string Keyword { get; set; }
    }
}
