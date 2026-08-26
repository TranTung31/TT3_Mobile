using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SystemService.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class _171526082026_CreateTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "KenhPhanPhoiDoanhNghieps",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    MaPhanPhoi = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    TenKenhPhanPhoi = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    GhiChu = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    CreatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KenhPhanPhoiDoanhNghieps", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "NhomSanPhamHangHoas",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    MaNhomSanPhamHangHoa = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    TenNhomSanPhamHangHoa = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    Mota = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    LoaiNhom = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    ParentId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TrangThai = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    CreatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NhomSanPhamHangHoas", x => x.Id);
                    table.ForeignKey(
                        name: "FK_NhomSanPhamHangHoas_NhomSanPhamHangHoas_ParentId",
                        column: x => x.ParentId,
                        principalTable: "NhomSanPhamHangHoas",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "NuocXuatXus",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    MaNuocXuatXu = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    TenNuocXuatXu = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    GhiChu = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    CreatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NuocXuatXus", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "QuyCachDongGois",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    MaQuyCach = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    TenQuyCach = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    Description = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    CreatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_QuyCachDongGois", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "TieuChuanQuyChuanKyThuatChungs",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    MaTieuChuanQuyChuan = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    TenTieuChuanQuyChuan = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    LoaiTieuChuanQuyChuan = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    GhiChu = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    CreatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TieuChuanQuyChuanKyThuatChungs", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Products",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TenSanPham = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    MaGTIN = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    MoTa = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ThuongHieu = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    NhaSanXuat = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DiaChiNhaSanXuat = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ThuongNhanNhapKhau = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DiaChiThuongNhanNhapKhau = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    GiaBanNiemYet = table.Column<double>(type: "float", nullable: false),
                    HanSuDung = table.Column<DateTime>(type: "datetime2", nullable: true),
                    TrongLuong = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KichThuoc = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    MoTaChatLieuMauSac = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DoiTacNhapKhau = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DiaChiDoiTacNhapKhau = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LinkWebsiteSp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LinkSanTmdt = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DacTinhCongDung = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    NguyenLieuVatLieuChinh = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DVBHThoiHanBaoHanh = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DVBHThongTinLienHe = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DVBHHauMai = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CanhBaoGiaMao = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LoaiSanPhamId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DongGoiId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    XuatXuId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ThiTruongNhapKhauId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    CreatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Products", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Products_NhomSanPhamHangHoas_LoaiSanPhamId",
                        column: x => x.LoaiSanPhamId,
                        principalTable: "NhomSanPhamHangHoas",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Products_NuocXuatXus_ThiTruongNhapKhauId",
                        column: x => x.ThiTruongNhapKhauId,
                        principalTable: "NuocXuatXus",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Products_NuocXuatXus_XuatXuId",
                        column: x => x.XuatXuId,
                        principalTable: "NuocXuatXus",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Products_QuyCachDongGois_DongGoiId",
                        column: x => x.DongGoiId,
                        principalTable: "QuyCachDongGois",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ProductCertifications",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Tep = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ChungNhanId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ProductId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DonViId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductCertifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ProductCertifications_DmDonVi_DonViId",
                        column: x => x.DonViId,
                        principalTable: "DmDonVi",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ProductCertifications_Products_ProductId",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ProductCertifications_TieuChuanQuyChuanKyThuatChungs_ChungNhanId",
                        column: x => x.ChungNhanId,
                        principalTable: "TieuChuanQuyChuanKyThuatChungs",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "ProductChannelDistributions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    KenhPhanPhoiDoanhNghiepId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ProductId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UpdatedOnUtc = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductChannelDistributions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ProductChannelDistributions_KenhPhanPhoiDoanhNghieps_KenhPhanPhoiDoanhNghiepId",
                        column: x => x.KenhPhanPhoiDoanhNghiepId,
                        principalTable: "KenhPhanPhoiDoanhNghieps",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ProductChannelDistributions_Products_ProductId",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_NhomSanPhamHangHoas_ParentId",
                table: "NhomSanPhamHangHoas",
                column: "ParentId");

            migrationBuilder.CreateIndex(
                name: "IX_ProductCertifications_ChungNhanId",
                table: "ProductCertifications",
                column: "ChungNhanId");

            migrationBuilder.CreateIndex(
                name: "IX_ProductCertifications_DonViId",
                table: "ProductCertifications",
                column: "DonViId");

            migrationBuilder.CreateIndex(
                name: "IX_ProductCertifications_ProductId_ChungNhanId_DonViId",
                table: "ProductCertifications",
                columns: new[] { "ProductId", "ChungNhanId", "DonViId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ProductChannelDistributions_KenhPhanPhoiDoanhNghiepId",
                table: "ProductChannelDistributions",
                column: "KenhPhanPhoiDoanhNghiepId");

            migrationBuilder.CreateIndex(
                name: "IX_ProductChannelDistributions_ProductId_KenhPhanPhoiDoanhNghiepId",
                table: "ProductChannelDistributions",
                columns: new[] { "ProductId", "KenhPhanPhoiDoanhNghiepId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Products_DongGoiId",
                table: "Products",
                column: "DongGoiId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_LoaiSanPhamId",
                table: "Products",
                column: "LoaiSanPhamId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_ThiTruongNhapKhauId",
                table: "Products",
                column: "ThiTruongNhapKhauId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_XuatXuId",
                table: "Products",
                column: "XuatXuId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ProductCertifications");

            migrationBuilder.DropTable(
                name: "ProductChannelDistributions");

            migrationBuilder.DropTable(
                name: "TieuChuanQuyChuanKyThuatChungs");

            migrationBuilder.DropTable(
                name: "KenhPhanPhoiDoanhNghieps");

            migrationBuilder.DropTable(
                name: "Products");

            migrationBuilder.DropTable(
                name: "NhomSanPhamHangHoas");

            migrationBuilder.DropTable(
                name: "NuocXuatXus");

            migrationBuilder.DropTable(
                name: "QuyCachDongGois");
        }
    }
}
