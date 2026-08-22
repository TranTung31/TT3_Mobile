using SystemService.Domain.Entities.Enums;

namespace SystemService.Application.Models.Catalog.DmDonVi
{
    public partial record DmDonViModel : BaseEntityModel<Guid>
    {
        /// <summary>
        /// Mã đơn vị
        /// </summary>
        public string MaDonVi { get; set; }

        /// <summary>
        /// Tên đơn vị
        /// </summary>
        public string TenDonVi { get; set; }

        /// <summary>
        /// Mã địa bàn
        /// </summary>
        public string MaDiaBan { get; set; }

        /// <summary>
        /// Địa chỉ
        /// </summary>
        public string DiaChi { get; set; }

        /// <summary>
        /// Điện thoại
        /// </summary>
        public string DienThoai { get; set; }

        public int CapDuToan { get; set; }

        public bool LaDonViChiTiet { get; set; }

        public bool LaDonViSuNghiep { get; set; } = false;

        public Guid? LoaiId { get; set; }

        public MucDoTuChuTaiChinhType? MucDoTuChuTaiChinh { get; set; }

        public TrinhDoDaoTaoType? TrinhDoDaoTao { get; set; }

        /// <summary>
        /// Đơn vị cha id
        /// </summary>
        public Guid? DonViChaId { get; set; }

        public bool? LaCucLoaiHai { set; get; } = false;

        /// <summary>
        /// Trạng thái
        /// </summary>
        public int TrangThai { get; set; }


    }
    public partial record DmDonViVaConModel : BaseEntityModel<Guid>
    {

        public string TenDonVi { get; set; }

        public Guid? DonViChaId { get; set; }

    }

}
