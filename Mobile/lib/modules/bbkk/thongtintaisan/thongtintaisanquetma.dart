import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/models/loai_bien_dongs.dart';
import 'package:qltstc_kiemke/modules/common_widgets/group_button.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';

class ThongTinTaiSanQuetMa extends StatefulWidget {
  final LoaiBienDongs? taiSan;
  final String? tenDonVi;
  const ThongTinTaiSanQuetMa({Key? key, this.taiSan, this.tenDonVi})
      : super(key: key);

  @override
  _ThongTinTaiSanQuetMaState createState() => _ThongTinTaiSanQuetMaState();
}

class _ThongTinTaiSanQuetMaState extends State<ThongTinTaiSanQuetMa> {
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
          subTitle: "Thông tin tài sản",
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
                            "Chi tiết tài sản",
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
                              _buildInfoRow("Nhóm tài sản",
                                  widget.taiSan?.tenNhomTaiSan ?? "Không có"),
                              SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300, height: 1),
                              SizedBox(height: 12),
                              _buildInfoRow("Mã tài sản",
                                  widget.taiSan?.maTaiSan ?? "Không có"),
                              SizedBox(height: 12),
                              Divider(color: Colors.grey.shade300, height: 1),
                              SizedBox(height: 12),
                              _buildInfoRow("Nguyên giá",
                                  "${NumberFormat().format(widget.taiSan?.nguyenGia ?? 0)} VND"),
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
                pageName: "ThongTinTaiSanQuetMa",
              ),
            ],
            // ),
          ),
        ),
      ),
    );
  }
}
