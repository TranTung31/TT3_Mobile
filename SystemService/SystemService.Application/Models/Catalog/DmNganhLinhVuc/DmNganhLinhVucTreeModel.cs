namespace SystemService.Application.Models.Catalog.DmNganhLinhVuc
{
    public class DmNganhLinhVucTreeModel
    {
        public Guid Id { get; set; }
        public string Ma { get; set; }
        public string Ten { get; set; }
        public bool IsActive { get; set; }
        public Guid? NganhLinhVucChaId { get; set; }
        public virtual List<DmNganhLinhVucTreeModel> Children { get; set; } = [];
    }
}
