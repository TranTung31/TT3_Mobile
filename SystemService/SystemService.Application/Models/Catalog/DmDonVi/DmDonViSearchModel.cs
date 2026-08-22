namespace SystemService.Application.Models.Catalog.DmDonVi
{
    public record DmDonViSearchModel : BaseSearchModel
    {
        /// <summary>
        /// Từ khóa tìm kiếm.
        /// </summary>
        public string Keyword { get; set; }
    }
}
