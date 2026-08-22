namespace SystemService.Application.Models.Catalog.DmNganhLinhVuc
{
    public record DmNganhLinhVucSearchModel : BaseSearchModel
    {
        /// <summary>
        /// Từ khóa tìm kiếm.
        /// </summary>
        public string Keyword { get; set; }

        public string? Ma { get; set; }
        public string? Ten { get; set; }
        public int? TrangThaiId { get; set; }
    }
}
