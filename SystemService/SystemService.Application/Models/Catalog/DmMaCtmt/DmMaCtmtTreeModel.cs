namespace SystemService.Application.Models.Catalog.DmMaCtmt
{
    public class DmMaCtmtTreeModel
    {
        public Guid Id { get; set; }
        public string Ma { get; set; }
        public string Ten { get; set; }
        public bool IsActive { get; set; }
        public Guid? MaCtmtChaId { get; set; }
        public virtual List<DmMaCtmtTreeModel> Children { get; set; } = [];
    }
}
