using SystemService.Application.Models.Catalog.DmNganhLinhVuc;

namespace SystemService.Application.Models.Catalog.DmNguonVon
{
    public class DmNguonVonTreeModel
    {
        public Guid Id { get; set; }
        public string Ma { get; set; }
        public string Ten { get; set; }
        public bool IsActive { get; set; }
        public Guid? NguonVonChaId { get; set; }
        public virtual List<DmNguonVonTreeModel> Children { get; set; } = [];
    }
}
