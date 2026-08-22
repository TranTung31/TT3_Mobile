using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shared.Contracts.ElasticSearch.Event.DtnsManagementService.ThongBao
{
    public class ThongBaoCreatedEvent : IElasticEvent
    {
        public Guid Id { get; set; }
        public int? NamDuToan { get; set; }
        public int? LoaiDuToan { get; set; }
        public string TenLoaiDuToan { get; set; }
        public int? TrangThaiId { get; set; }
        public string TenTrangThai { get; set; }
        public DateTime CreatedOnUtc { get; set; }
        public DateTime? UpdatedOnUtc { get; set; }
    }
}
