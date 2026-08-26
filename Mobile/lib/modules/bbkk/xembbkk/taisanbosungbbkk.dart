import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qltstc_kiemke/models/bpsd.dart';
import 'package:qltstc_kiemke/modules/bbkk/xembbkk/xemtaisanbosung.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/number_utils.dart';

class TaiSanBoSungBBKK extends StatefulWidget {
  const TaiSanBoSungBBKK({Key? key}) : super(key: key);

  @override
  _TaiSanBoSungBBKKState createState() => _TaiSanBoSungBBKKState();
}

class _TaiSanBoSungBBKKState extends State<TaiSanBoSungBBKK> {
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

  final searchController = TextEditingController();
  final filterTenTSController = TextEditingController();
  final searchQuery = "".obs;
  final isShowFilterModal = false.obs;

  final filterTenTS = "".obs;
  final filterTinhTrangSD = "".obs;
  final filterBPSD = "".obs;

  @override
  void initState() {
    super.initState();
    getBPSD(context);
  }

  @override
  void dispose() {
    searchController.dispose();
    // filterMaTSController.dispose();
    filterTenTSController.dispose();
    super.dispose();
  }

  List<dynamic> getFilteredList() {
    if (_bbkk.ListTaiSanTamThoi == null) return [];

    final query = searchQuery.value.toLowerCase();
    return _bbkk.ListTaiSanTamThoi!.where((ts) {
      if (query.isNotEmpty) {
        final matchName = ts.ten?.toLowerCase().contains(query) ?? false;
        final matchCode = ts.maTaiSan?.toLowerCase().contains(query) ?? false;
        if (!matchName && !matchCode) return false;
      }

      if (filterTenTS.value.isNotEmpty &&
          !(ts.ten?.toLowerCase().contains(filterTenTS.value.toLowerCase()) ??
              false)) {
        return false;
      }

      if (filterTinhTrangSD.value.isNotEmpty &&
          ts.tinhtrangsudung != filterTinhTrangSD.value) {
        return false;
      }

      if (filterBPSD.value.isNotEmpty &&
          ts.bophansudung?.title != filterBPSD.value) {
        return false;
      }

      return true;
    }).toList();
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
                  //Search bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                searchQuery.value = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm theo tên hoặc mã tài sản',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            filterTenTSController.text = filterTenTS.value;
                            isShowFilterModal.value = true;
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Icon(
                              IconsaxPlusLinear.document_filter,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // End Search bar
                  // Result header
                  Obx(() {
                    final filteredList = getFilteredList();
                    final isFiltered = searchQuery.value.isNotEmpty ||
                        filterTenTS.value.isNotEmpty ||
                        filterTinhTrangSD.value.isNotEmpty ||
                        filterBPSD.value.isNotEmpty;

                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            isFiltered
                                ? "Kết quả tìm kiếm"
                                : "Danh sách tài sản bổ sung",
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                          Spacer(),
                          Text(
                            isFiltered
                                ? "${filteredList.length} tài sản"
                                : "${_bbkk.ListTaiSanTamThoi?.length ?? 0} tài sản",
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
                    child: MaterialButton(
                      height: 45,
                      minWidth: double.infinity,
                      splashColor: Colors.grey,
                      highlightColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
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
                  SizedBox(height: 20),
                ],
              ),
              Obx(() => isShowFilterModal.value
                  ? buildFilterModal(context)
                  : SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  // QR kiểm kê
  buildQRKiemKeDiv(BuildContext context) {
    return Obx(() {
      final filteredList = getFilteredList();
      List<Widget> rows = [];

      if (filteredList.isNotEmpty) {
        for (int i = 0; i < filteredList.length; i++) {
          var ts = filteredList[i];
          rows.add(
            InkWell(
              onTap: () => Get.to(() => XemTaiSanBoSung(taiSanBoSung: ts)),
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
                        // Text(
                        //   (ts.nguyengia != null
                        //       ? NumberUtils.formatCurrency(ts.nguyengia!, 0)
                        //       : "0"),
                        //   style: TextStyle(
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w500,
                        //     color: Colors.black87,
                        //   ),
                        // ),
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
                        Spacer(),
                        Flexible(
                          child: Text(
                            ts.nhomtaisan?.tenNhomTaiSan ?? "",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.right,
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
                        Spacer(),
                        if (ts.tinhtrangsudung == "001")
                          Text(
                            'Đang sử dụng',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else if (ts.tinhtrangsudung == "002")
                          Text(
                            'Không sử dụng',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else if (ts.tinhtrangsudung == "003")
                          Text(
                            'Không có nhu cầu sử dụng (chờ xử lý, hỏng)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else if (ts.tinhtrangsudung == "004")
                          Text(
                            'Khác',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else if (ts.tinhtrangsudung == "005")
                          Text(
                            'Hư hỏng',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else if (ts.tinhtrangsudung == "006")
                          Text(
                            'Không sử dụng chờ xử lý',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          if (i < filteredList.length - 1) {
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

  // Filter Modal
  Widget buildFilterModal(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: InkWell(
            onTap: () => isShowFilterModal.value = false,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Bộ lọc tìm kiếm',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tên tài sản',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: filterTenTSController,
                          decoration: InputDecoration(
                            hintText: 'Nhập',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tình trạng sử dụng',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Obx(() => Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: filterTinhTrangSD.value,
                                hint: Text(
                                  'Chọn',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                underline: SizedBox(),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text(
                                      'Tất cả',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '001',
                                    child: Text(
                                      'Đang sử dụng',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '002',
                                    child: Text(
                                      'Không sử dụng',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '003',
                                    child: Text(
                                      'Không có nhu cầu sử dụng (chờ xử lý, hỏng)',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '004',
                                    child: Text(
                                      'Khác',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '005',
                                    child: Text(
                                      'Hư hỏng',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '006',
                                    child: Text(
                                      'Không sử dụng chờ xử lý',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  filterTinhTrangSD.value = value ?? '';
                                },
                              ),
                            )),
                        SizedBox(height: 16),
                        Text(
                          'Bộ phận sử dụng',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Obx(() => Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: filterBPSD.value,
                                hint: Text(
                                  'Chọn',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                underline: SizedBox(),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text(
                                      'Tất cả',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                  ..._bpsdDatas
                                      .map((bpsd) => DropdownMenuItem<String>(
                                            value: bpsd.title,
                                            child: Text(
                                              bpsd.title,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ))
                                      .toList(),
                                ],
                                onChanged: (value) {
                                  filterBPSD.value = value ?? '';
                                },
                              ),
                            )),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                height: 45,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.grey[300],
                                onPressed: () {
                                  filterTenTSController.clear();
                                  filterTenTS.value = '';
                                  filterTinhTrangSD.value = '';
                                  filterBPSD.value = '';
                                },
                                child: Text(
                                  'Đặt lại',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: MaterialButton(
                                height: 45,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  filterTenTS.value =
                                      filterTenTSController.text;
                                  isShowFilterModal.value = false;
                                },
                                child: Text(
                                  'Tìm kiếm',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 30,
                    child: InkWell(
                      onTap: () => isShowFilterModal.value = false,
                      child: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  // End Filter Modal
}
