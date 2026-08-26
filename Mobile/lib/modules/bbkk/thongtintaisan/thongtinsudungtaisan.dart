import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/models/loai_bien_dongs.dart';
import 'package:qltstc_kiemke/modules/common_widgets/group_button.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';

class ThongTinSuDungTaiSan extends StatefulWidget {
  final LoaiBienDongs? taiSan;
  final String? tenDonVi;
  const ThongTinSuDungTaiSan({Key? key, this.taiSan, this.tenDonVi})
      : super(key: key);

  @override
  _ThongTinSuDungTaiSanState createState() => _ThongTinSuDungTaiSanState();
}

class _ThongTinSuDungTaiSanState extends State<ThongTinSuDungTaiSan> {
  String _formatNgaySuDung(String? ngaySuDung) {
    if (ngaySuDung == null || ngaySuDung.isEmpty) {
      return "Không có thông tin";
    }

    try {
      // Xử lý format ISO 8601: 2022-12-16T00:00:00
      DateTime dateTime = DateTime.parse(ngaySuDung);
      return DateFormat("dd/MM/yyyy").format(dateTime);
    } catch (e) {
      try {
        // Fallback: thử parse với format dd/MM/yyyy nếu có
        DateTime dateTime = DateFormat("dd/MM/yyyy").parse(ngaySuDung);
        return DateFormat("dd/MM/yyyy").format(dateTime);
      } catch (e2) {
        return ngaySuDung; // Trả về nguyên bản nếu không parse được
      }
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        appBar: AccountHeader(
          subTitle: "Thông tin sử dụng tài sản",
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Chi tiết",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              _buildInfoRow("Tên tài sản",
                                  widget.taiSan?.tenTaiSan ?? "Không có"),
                              SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300, height: 1),
                              SizedBox(height: 12),
                              _buildInfoRow("Đơn vị sử dụng",
                                  widget.tenDonVi ?? "Không có"),
                              SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300, height: 1),
                              SizedBox(height: 12),
                              _buildInfoRow("Ngày đưa vào sử dụng",
                                  _formatNgaySuDung(widget.taiSan?.ngaySuDung)),
                              SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300, height: 1),
                              SizedBox(height: 12),
                              _buildInfoRow("Lý do tăng",
                                  widget.taiSan?.lyDoTang ?? "Không có"),
                              SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300, height: 1),
                              SizedBox(height: 12),
                              _buildInfoRow("Bộ phận sử dụng",
                                  widget.taiSan?.tenBPSDTS ?? "Không có"),
                              SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300, height: 1),
                              SizedBox(height: 12),
                              _buildInfoRow("Người sử dụng",
                                  widget.taiSan?.nguoiSuDung ?? "Không có"),
                              SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300, height: 1),
                              SizedBox(height: 12),
                              _buildInfoRow(
                                  "Tình trạng sử dụng",
                                  widget.taiSan?.maTinhTrangSuDung ??
                                      "Không có"),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GroupButton(
                taiSan: widget.taiSan,
                tenDonVi: widget.tenDonVi,
                pageName: "ThongTinSuDungTaiSan",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
