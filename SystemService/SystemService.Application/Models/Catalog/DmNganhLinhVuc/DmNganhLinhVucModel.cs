namespace SystemService.Application.Models.Catalog.DmNganhLinhVuc
{
    public partial record DmNganhLinhVucModel : BaseEntityModel<Guid>
    {
        public string Ma { get; set; }
        public string Ten { get; set; }
        public bool IsActive { get; set; }
        public Guid? NganhLinhVucChaId { get; set; }
    }
}
