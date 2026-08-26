import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/models/loai_bien_dongs.dart';
import 'package:qltstc_kiemke/modules/common_widgets/group_button.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';

class ThongTinBienDongTaiSan extends StatefulWidget {
  final LoaiBienDongs? taiSanGoc;
  final List<LoaiBienDongItem>? taiSan;
  final String? tenDonVi;
  const ThongTinBienDongTaiSan(
      {Key? key, this.taiSan, this.tenDonVi, this.taiSanGoc})
      : super(key: key);

  @override
  _ThongTinBienDongTaiSanState createState() => _ThongTinBienDongTaiSanState();
}

class _ThongTinBienDongTaiSanState extends State<ThongTinBienDongTaiSan> {
  Map<int, bool> _expandedStates = {};

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
        appBar: AccountHeader(subTitle: "Thông tin Biến động Tài sản"),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 0, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        if (widget.taiSan != null && widget.taiSan!.isNotEmpty)
                          ...widget.taiSan!
                              .map((item) => _buildBienDongItem(item))
                              .toList(),
                      ],
                    ),
                  ),
                ),
              ),
              GroupButton(
                taiSan: widget.taiSanGoc,
                tenDonVi: widget.tenDonVi,
                pageName: "ThongTinBienDongTaiSan",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBienDongItem(LoaiBienDongItem item) {
    final int itemHash = item.hashCode;
    final bool isExpanded = _expandedStates[itemHash] ?? false;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _expandedStates[itemHash] = !isExpanded;
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.tenLoaiBienDong ?? "Không có thông tin",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.blue.shade700,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isExpanded ? null : 0,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: isExpanded ? 1.0 : 0.0,
            child: isExpanded
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Ngày biến động",
                            _formatNgaySuDung(item.bienDong?.ngayBienDong)),
                        SizedBox(height: 12),
                        Divider(color: Colors.grey.shade300, height: 1),
                        SizedBox(height: 12),
                        _buildInfoRow(
                            "Lý do", item.bienDong?.lyDoBienDong ?? "Không có"),
                        SizedBox(height: 12),
                        Divider(color: Colors.grey.shade300, height: 1),
                        SizedBox(height: 12),
                        _buildInfoRow(
                            "Giá trị",
                            NumberFormat()
                                .format(item.bienDong?.nguyenGia ?? 0)
                                .toString()),
                        SizedBox(height: 12),
                        Divider(color: Colors.grey.shade300, height: 1),
                        SizedBox(height: 12),
                        _buildInfoRow(
                            "Luỹ kế HM/KH",
                            NumberFormat()
                                .format(item.bienDong?.haoMonLuyKe ?? 0)
                                .toString()),
                        SizedBox(height: 12),
                        Divider(color: Colors.grey.shade300, height: 1),
                        SizedBox(height: 12),
                        _buildInfoRow(
                          "Đơn vị sử dụng",
                          item.bienDong?.tenDonVi ?? "Không có",
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
