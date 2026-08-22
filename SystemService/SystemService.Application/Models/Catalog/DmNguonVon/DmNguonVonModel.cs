namespace SystemService.Application.Models.Catalog.DmNguonVon
{
    public partial record DmNguonVonModel : BaseEntityModel<Guid>
    {
        public string Ma { get; set; }
        public string Ten { get; set; }
        public int Loai { get; set; }
        public bool IsActive { get; set; }
        public Guid? NguonVonChaId { get; set; }
    }
}
