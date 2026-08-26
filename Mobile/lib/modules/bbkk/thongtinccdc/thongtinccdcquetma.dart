import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/quetmaccdc.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';

class ThongTinCCDCQuetMa extends StatefulWidget {
  final QuetMaCCDC? taiSan;
  final String? tenDonVi;
  const ThongTinCCDCQuetMa({Key? key, this.taiSan, this.tenDonVi})
      : super(key: key);

  @override
  _ThongTinCCDCQuetMaState createState() => _ThongTinCCDCQuetMaState();
}

class _ThongTinCCDCQuetMaState extends State<ThongTinCCDCQuetMa> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountHeader(subTitle: "Thông tin Biến động CCDC"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Mã công cụ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          TextSpan(
                            text: ": ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          TextSpan(
                            text: widget.taiSan?.maCongCu ?? "Không có",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          )
                        ]),
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Tên công cụ",
                              style: Theme.of(context).textTheme.headlineSmall),
                          TextSpan(
                              text: ": ",
                              style:
                                  Theme.of(context).textTheme.headlineSmall!),
                          TextSpan(
                              text: widget.taiSan?.tenCongCu ?? "Không có",
                              style: Theme.of(context).textTheme.bodyMedium)
                        ]),
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Tên nhóm công cụ",
                              style: Theme.of(context).textTheme.headlineSmall),
                          TextSpan(
                              text: ": ",
                              style:
                                  Theme.of(context).textTheme.headlineSmall!),
                          TextSpan(
                              text: widget.taiSan?.tenNhomCongCu ?? "Không có",
                              style: Theme.of(context).textTheme.bodyMedium)
                        ]),
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Tên BPSD tài sản",
                              style: Theme.of(context).textTheme.headlineSmall),
                          TextSpan(
                              text: ": ",
                              style:
                                  Theme.of(context).textTheme.headlineSmall!),
                          TextSpan(
                              text: widget.taiSan?.tenBPSDTS,
                              style: Theme.of(context).textTheme.bodyMedium)
                        ]),
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Số lượng",
                              style: Theme.of(context).textTheme.headlineSmall),
                          TextSpan(
                              text: ": ",
                              style:
                                  Theme.of(context).textTheme.headlineSmall!),
                          TextSpan(
                              text: NumberFormat()
                                  .format(widget.taiSan?.soLuong)
                                  .toString(),
                              style: Theme.of(context).textTheme.bodyMedium)
                        ]),
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Đơn giá",
                              style: Theme.of(context).textTheme.headlineSmall),
                          TextSpan(
                              text: ": ",
                              style:
                                  Theme.of(context).textTheme.headlineSmall!),
                          TextSpan(
                              text: NumberFormat()
                                  .format(widget.taiSan?.donGia)
                                  .toString(),
                              style: Theme.of(context).textTheme.bodyMedium)
                        ]),
                      ),
                      SizedBox(height: 15),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Ngày phân bổ",
                              style: Theme.of(context).textTheme.headlineSmall),
                          TextSpan(
                              text: ": ",
                              style:
                                  Theme.of(context).textTheme.headlineSmall!),
                          TextSpan(
                              text:
                                  _formatNgaySuDung(widget.taiSan?.ngayPhanBo),
                              style: Theme.of(context).textTheme.bodyMedium)
                        ]),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  SizedBox(width: Config.BASE_PADDING),
                  Expanded(
                    child: MaterialButton(
                      height: 40,
                      onPressed: () => Get.back(),
                      child: Text(
                        "Đóng".toUpperCase(),
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      color: ColorUtils.gray,
                    ),
                  ),
                  SizedBox(width: Config.BASE_PADDING),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
