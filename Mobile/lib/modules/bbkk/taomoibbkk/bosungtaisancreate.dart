import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:qltstc_kiemke/models/bpsd.dart';
import 'package:qltstc_kiemke/models/taisanbosung.dart';
import 'package:qltstc_kiemke/modules/bbkk/quetqrtaisan/taisannhapbosung.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/number_utils.dart';

// ignore: must_be_immutable
class BoSungTaiSanCreatePage extends StatefulWidget {
  const BoSungTaiSanCreatePage({Key? key}) : super(key: key);

  @override
  _BoSungTaiSanCreatePageState createState() => _BoSungTaiSanCreatePageState();
}

class _BoSungTaiSanCreatePageState extends State<BoSungTaiSanCreatePage> {
  Future<void> getBPSD(context) async {
    UserService.sharedInstance().getBPSD().then((value) {
      if (value.length > 0) {
        _bpsdDatas.addAll(value);
      } else {
        // DialogUtils.alert(context, "Không tìm thấy bộ phận sử dụng");
      }
    });
  }

  final _bpsdDatas = <BPSD>[].obs;
  final _bbkk = BBKKService.sharedInstance().currentRecord!;
  final _taiSanTamThoiList = <TSBS>[].obs;

  @override
  void initState() {
    super.initState();
    getBPSD(context);
    if (_bbkk.ListTaiSanTamThoi != null) {
      _taiSanTamThoiList.assignAll(_bbkk.ListTaiSanTamThoi!);
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          subTitle: "Thông tin Tài sản bổ sung",
          pageName: "ThongTin",
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          IconsaxPlusLinear.box_add,
                          size: 20,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Bổ sung tài sản",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Result header
                  Obx(() {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            "Danh sách tài sản bổ sung",
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                          Spacer(),
                          Text(
                            "${_taiSanTamThoiList.length} tài sản",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  // End Result header
                  buildQRKiemKeDiv(context),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            height: 45,
                            minWidth: double.infinity,
                            splashColor: Colors.grey,
                            highlightColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () => Get.back(),
                            child: Text(
                              "Đóng",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: MaterialButton(
                            height: 45,
                            minWidth: double.infinity,
                            splashColor: Colors.grey,
                            highlightColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () {
                              Get.to(() => TaiSanNhapBoSung())?.then((value) {
                                // Refresh danh sách khi quay lại từ trang bổ sung
                                if (_bbkk.ListTaiSanTamThoi != null) {
                                  _taiSanTamThoiList
                                      .assignAll(_bbkk.ListTaiSanTamThoi!);
                                }
                              });
                            },
                            child: Text(
                              "Bổ sung tài sản",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // QR kiểm kê
  buildQRKiemKeDiv(BuildContext context) {
    return Obx(() {
      List<Widget> rows = [];

      if (_taiSanTamThoiList.isNotEmpty) {
        for (int i = 0; i < _taiSanTamThoiList.length; i++) {
          var ts = _taiSanTamThoiList[i];
          rows.add(
            InkWell(
              // onTap: () => Get.to(() => XemTaiSanBoSung(taiSanBoSung: ts)),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "${i + 1}. ${ts.ten}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Get.to(() =>
                                    TaiSanNhapBoSung(editingTSBS: ts, index: i))
                                ?.then((value) {
                              if (_bbkk.ListTaiSanTamThoi != null) {
                                _taiSanTamThoiList
                                    .assignAll(_bbkk.ListTaiSanTamThoi!);
                              }
                            });
                          },
                          child: Icon(
                            IconsaxPlusLinear.edit_2,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            deleteModal(i);
                          },
                          child: Icon(
                            IconsaxPlusLinear.trash,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Nguyên giá",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        Text(
                          (ts.nguyengia != null
                              ? NumberUtils.formatCurrency(ts.nguyengia!, 0)
                              : "0"),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Bộ phận sử dụng",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        Text(
                          ts.bophansudung?.title ?? "Toàn bộ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Nhóm tài sản",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ts.nhomtaisan?.tenNhomTaiSan ?? "Toàn bộ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Tình trạng sử dụng",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (ts.tinhtrangsudung == "001")
                                return Text(
                                  'Đang sử dụng',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                );
                              else if (ts.tinhtrangsudung == "002")
                                return Text(
                                  'Không sử dụng',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                );
                              else if (ts.tinhtrangsudung == "003")
                                return Text(
                                  'Không có nhu cầu sử dụng (chờ xử lý, hỏng)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.right,
                                );
                              else if (ts.tinhtrangsudung == "004")
                                return Text(
                                  'Khác',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                );
                              else if (ts.tinhtrangsudung == "005")
                                return Text(
                                  'Hư hỏng',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                );
                              else if (ts.tinhtrangsudung == "006")
                                return Text(
                                  'Không sử dụng chờ xử lý',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                );
                              return SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          if (i < _taiSanTamThoiList.length - 1) {
            rows.add(Divider());
          }
        }
      }

      return Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 20),
          child: Container(
            child: Column(
              children: [
                if (rows.isEmpty)
                  Container(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Không tìm thấy tài sản nào',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                else
                  Column(children: rows),
              ],
            ),
          ),
        ),
      );
    });
  }
  // End QR kiểm kê

  void deleteModal(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Xóa biên bản kiểm kê",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 60,
                        color: Colors.blue,
                      ),
                      Positioned(
                        right: 20,
                        bottom: 25,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Xác nhận xóa",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Bạn chắc chắn muốn xóa biên bản kiểm kê đã được chọn?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        // height: 45,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _taiSanTamThoiList.removeAt(index);
                          _bbkk.ListTaiSanTamThoi = _taiSanTamThoiList;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Xóa",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        // height: 45,
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Hủy",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
