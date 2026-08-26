import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/KeyValueModel.dart';
import 'package:qltstc_kiemke/models/taisanbosung.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/number_utils.dart';

class XemTaiSanBoSung extends StatefulWidget {
  final TSBS taiSanBoSung;

  const XemTaiSanBoSung({Key? key, required this.taiSanBoSung})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _XemTaiSanBoSung();
  }
}

class _XemTaiSanBoSung extends State<XemTaiSanBoSung> {
  Map<String, String> _tinhtrangDatas = Map<String, String>();

  @override
  void initState() {
    super.initState();

    // Initialize status data
    _tinhtrangDatas["Đang sử dụng"] = "001";
    _tinhtrangDatas["Không sử dụng"] = "002";
    _tinhtrangDatas["Không có nhu cầu sử dụng (chờ xử lý, hỏng)"] = "003";
    _tinhtrangDatas["Khác"] = "004";
    _tinhtrangDatas["Hư hỏng"] = "005";
    _tinhtrangDatas["Không sử dụng chờ xử lý"] = "006";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AccountHeader(
          subTitle: "Chi tiết Tài sản bổ sung",
          pageName: "ThemMoi",
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Config.BASE_PADDING,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên tài sản
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Tên tài sản",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  TextSpan(
                                    text: " *",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                widget.taiSanBoSung.ten?.isEmpty == true
                                    ? "Chưa có dữ liệu"
                                    : widget.taiSanBoSung.ten ??
                                        "Chưa có dữ liệu",
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      widget.taiSanBoSung.ten?.isEmpty != false
                                          ? Colors.grey[600]
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Nhóm tài sản
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Nhóm tài sản",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  TextSpan(
                                    text: " *",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                widget.taiSanBoSung.nhomtaisan?.title ??
                                    "Chưa có dữ liệu",
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      widget.taiSanBoSung.nhomtaisan?.title ==
                                              null
                                          ? Colors.grey[600]
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Bộ phận sử dụng
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bộ phận sử dụng",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                widget.taiSanBoSung.bophansudung?.title ??
                                    "Chưa có dữ liệu",
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      widget.taiSanBoSung.bophansudung?.title ==
                                              null
                                          ? Colors.grey[600]
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Nguyên giá
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nguyên giá",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                widget.taiSanBoSung.nguyengia != null
                                    ? NumberUtils.formatCurrency(
                                        widget.taiSanBoSung.nguyengia!, 0)
                                    : "0",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Giá trị còn lại
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Giá trị còn lại",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                widget.taiSanBoSung.giaTriConLai != null
                                    ? NumberUtils.formatCurrency(
                                        widget.taiSanBoSung.giaTriConLai!, 0)
                                    : "0",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Tình trạng sử dụng
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Tình trạng sử dụng",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  TextSpan(
                                    text: " *",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                getTinhTrangText(
                                    widget.taiSanBoSung.tinhtrangsudung),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: getTinhTrangText(widget
                                              .taiSanBoSung.tinhtrangsudung) ==
                                          "Chưa có dữ liệu"
                                      ? Colors.grey[600]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Đề xuất xử lý
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Đề xuất xử lý",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                getHinhThucXuLyText(
                                    widget.taiSanBoSung.maHinhThucXuLy),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: getHinhThucXuLyText(widget
                                              .taiSanBoSung.maHinhThucXuLy) ==
                                          "Chưa có dữ liệu"
                                      ? Colors.grey[600]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Kết quả xử lý
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kết quả xử lý",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Text(
                                getKetQuaXuLyText(
                                    widget.taiSanBoSung.maKetQuaXuLy),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: getKetQuaXuLyText(widget
                                              .taiSanBoSung.maKetQuaXuLy) ==
                                          "Chưa có dữ liệu"
                                      ? Colors.grey[600]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),

              // Nút đóng
              Container(
                padding: EdgeInsets.all(Config.BASE_PADDING),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: () => Get.back(),
                  child: Text(
                    "Đóng",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  color: ColorUtils.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to get text for tinh trang su dung
  String getTinhTrangText(String? tinhTrangCode) {
    if (tinhTrangCode == null || tinhTrangCode.isEmpty) {
      return "Chưa có dữ liệu";
    }

    for (var entry in _tinhtrangDatas.entries) {
      if (entry.value == tinhTrangCode) {
        return entry.key;
      }
    }
    return "Chưa có dữ liệu";
  }

  // Helper function to get text for hinh thuc xu ly
  String getHinhThucXuLyText(String? maHinhThuc) {
    if (maHinhThuc == null || maHinhThuc.isEmpty) {
      return "Chưa có dữ liệu";
    }

    try {
      int key = int.parse(maHinhThuc);
      var result = getHinhThucXuLyByKey(key);
      return result?.value ?? "Chưa có dữ liệu";
    } catch (e) {
      return "Chưa có dữ liệu";
    }
  }

  // Helper function to get text for ket qua xu ly
  String getKetQuaXuLyText(String? maKetQua) {
    if (maKetQua == null || maKetQua.isEmpty) {
      return "Chưa có dữ liệu";
    }

    try {
      int key = int.parse(maKetQua);
      var result = getKetQuaXuLyByKey(key);
      return result?.value ?? "Chưa có dữ liệu";
    } catch (e) {
      return "Chưa có dữ liệu";
    }
  }

  // Helper function to get KeyValueModel by key for Hinh thuc xu ly
  KeyValueModel? getHinhThucXuLyByKey(int key) {
    Map<int, String> hinhThucMap = {
      0: "Điều chuyển",
      1: "Do điều chỉnh sau kiểm kê",
      2: "Thu hồi",
      3: "Giảm khác",
      4: "Thanh lý",
      5: "Bán chuyển nhượng",
    };

    if (hinhThucMap.containsKey(key)) {
      return KeyValueModel(key, hinhThucMap[key]!);
    }
    return null;
  }

  // Helper function to get KeyValueModel by key for Ket qua xu ly
  KeyValueModel? getKetQuaXuLyByKey(int key) {
    Map<int, String> ketQuaMap = {
      0: "Điều chuyển",
      1: "Do điều chỉnh sau kiểm kê",
      2: "Thu hồi",
      3: "Giảm khác",
      4: "Thanh lý",
      5: "Bán chuyển nhượng",
    };

    if (ketQuaMap.containsKey(key)) {
      return KeyValueModel(key, ketQuaMap[key]!);
    }
    return null;
  }
}
