namespace SystemService.Application.Models.Catalog.DmMaCtmt
{
    public partial record DmMaCtmtModel : BaseEntityModel<Guid>
    {
        public string Ma { get; set; }
        public string Ten { get; set; }
        public bool IsActive { get; set; }
        public Guid? MaCtmtChaId { get; set; }
    }
}
