namespace SystemService.Application.Models.Catalog.DmNguonVon
{
    public record DmNguonVonSearchModel : BaseSearchModel
    {
        /// <summary>
        /// Từ khóa tìm kiếm.
        /// </summary>
        public string Keyword { get; set; }
    }
}
