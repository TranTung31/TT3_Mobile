import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qltstc_kiemke/models/bpsd.dart';
import 'package:qltstc_kiemke/models/loai_bien_dongs.dart';
import 'package:qltstc_kiemke/modules/bbkk/xembbkk/taisanbosungbbkk.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/number_utils.dart';

class ThongTinChungBBKK extends StatefulWidget {
  final LoaiBienDongs? taiSan;
  final String? tenDonVi;
  const ThongTinChungBBKK({Key? key, this.taiSan, this.tenDonVi})
      : super(key: key);

  @override
  _ThongTinChungBBKKState createState() => _ThongTinChungBBKKState();
}

class _ThongTinChungBBKKState extends State<ThongTinChungBBKK> {
  Future<void> getBPSD(context) async {
    UserService.sharedInstance().getBPSD().then((value) {
      if (value.length > 0) {
        _bpsdDatas.addAll(value);
      } else {
        // DialogUtils.alert(context, "Không tìm thấy bộ phận sử dụng");
      }
    });
  }

  var pageName = "ThongTin";
  RxList<BPSD> _bpsdDatas = <BPSD>[].obs;
  RxBool isShowTVHDDetail = false.obs;
  dynamic selectedTVHD;

  var bbkk = BBKKService.sharedInstance().currentRecord!;
  var user = UserService.sharedInstance().currentUser;
  BPSD? bpsd;

  // Search and filter variables
  final TextEditingController searchController = TextEditingController();
  final TextEditingController filterMaTSController = TextEditingController();
  final TextEditingController filterTenTSController = TextEditingController();
  RxString searchQuery = "".obs;
  RxBool isShowFilterModal = false.obs;

  // Filter options
  RxString filterMaTS = "".obs;
  RxString filterTenTS = "".obs;
  RxnInt filterKetQuaKK = RxnInt(null);
  RxString filterTinhTrangSD = "".obs;
  RxString filterBPSD = "".obs;

  @override
  void initState() {
    super.initState();
    getBPSD(context);
  }

  @override
  void dispose() {
    searchController.dispose();
    filterMaTSController.dispose();
    filterTenTSController.dispose();
    super.dispose();
  }

  List<dynamic> getFilteredList() {
    if (bbkk.ListTaiSan == null) return [];

    var filtered = bbkk.ListTaiSan!.where((ts) {
      if (searchQuery.value.isNotEmpty) {
        bool matchSearch = false;
        if (ts.tenTS != null &&
            ts.tenTS!.toLowerCase().contains(searchQuery.value.toLowerCase())) {
          matchSearch = true;
        }
        if (ts.maTS != null &&
            ts.maTS!.toLowerCase().contains(searchQuery.value.toLowerCase())) {
          matchSearch = true;
        }
        if (!matchSearch) return false;
      }

      if (filterMaTS.value.isNotEmpty) {
        if (ts.maTS == null ||
            !ts.maTS!.toLowerCase().contains(filterMaTS.value.toLowerCase())) {
          return false;
        }
      }

      if (filterTenTS.value.isNotEmpty) {
        if (ts.tenTS == null ||
            !ts.tenTS!
                .toLowerCase()
                .contains(filterTenTS.value.toLowerCase())) {
          return false;
        }
      }

      if (filterKetQuaKK.value != null) {
        if (filterKetQuaKK.value == 1 && ts.trangThaiKK != 1) return false;
        if (filterKetQuaKK.value == 2 && ts.trangThaiKK != 2) return false;
        if (filterKetQuaKK.value == 3 &&
            !(ts.trangThaiKK == 3 ||
                ts.trangThaiKK == 4 ||
                ts.trangThaiKK == null)) return false;
      }

      if (filterTinhTrangSD.value.isNotEmpty) {
        if (ts.maTinhTrangSuDung != filterTinhTrangSD.value) return false;
      }

      if (filterBPSD.value.isNotEmpty) {
        if (ts.tenBPSDTS != filterBPSD.value) return false;
      }

      return true;
    }).toList();

    return filtered;
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
          subTitle: "Thông tin biên bản kiểm kê",
          pageName: "ThongTin",
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 5),
                  // Navigation buttons
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            height: 45,
                            elevation: 0,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onPressed: () => {
                              setState(() {
                                pageName = "ThongTin";
                              }),
                            },
                            child: Text(
                              "Thông tin",
                              style: TextStyle(
                                color: pageName == "ThongTin"
                                    ? Colors.black
                                    : Colors.blue,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 45,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: MaterialButton(
                            height: 45,
                            elevation: 0,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onPressed: () => {
                              setState(() {
                                pageName = "HoiDong";
                              }),
                            },
                            child: Text(
                              "Hội đồng",
                              style: TextStyle(
                                color: pageName == "HoiDong"
                                    ? Colors.black
                                    : Colors.blue,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 45,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: MaterialButton(
                            height: 45,
                            elevation: 0,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onPressed: () => {
                              setState(() {
                                pageName = "QRKiemKe";
                              }),
                            },
                            child: Text(
                              "QR kiểm kê",
                              style: TextStyle(
                                color: pageName == "QRKiemKe"
                                    ? Colors.black
                                    : Colors.blue,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // End Navigation buttons
                  SizedBox(height: 5),
                  if (pageName == "QRKiemKe") ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
                            IconsaxPlusLinear.scan_barcode,
                            size: 20,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Quét mã QR kiểm kê",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(() => TaiSanBoSungBBKK());
                            },
                            child: Text(
                              "Tài sản bổ sung",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Search bar
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 8),
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
                              filterMaTSController.text = filterMaTS.value;
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
                      final isSearching = searchQuery.value.isNotEmpty ||
                          filterMaTS.value.isNotEmpty ||
                          filterTenTS.value.isNotEmpty ||
                          filterKetQuaKK.value != null ||
                          filterTinhTrangSD.value.isNotEmpty ||
                          filterBPSD.value.isNotEmpty;

                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Text(
                              isSearching
                                  ? "Kết quả tìm kiếm"
                                  : "Danh sách tài sản",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                            Spacer(),
                            Text(
                              isSearching
                                  ? "${filteredList.length} tài sản"
                                  : "Đã kiểm kê: ${bbkk.ListTaiSan?.where((ts) => ts.trangThaiKK != 3).length ?? 0}/${bbkk.ListTaiSan?.length ?? 0} tài sản",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    isSearching ? Colors.green : Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    // End Result header
                  ],
                  _buildPageContent(),
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
              Obx(() => isShowTVHDDetail.value
                  ? buildTVHDDetailModal(context, selectedTVHD)
                  : SizedBox.shrink()),
              Obx(() => isShowFilterModal.value
                  ? buildFilterModal(context)
                  : SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (pageName) {
      case "ThongTin":
        return buildThongTinDiv(context);
      case "HoiDong":
        return buildHoiDongDiv(context);
      case "QRKiemKe":
        return buildQRKiemKeDiv(context);
      default:
        return buildThongTinDiv(context);
    }
  }

  // Thông tin kiểm kê
  buildThongTinDiv(BuildContext context) {
    try {
      bpsd = _bpsdDatas.firstWhere(
        (element) => element.key == bbkk.BoPhanKiemKeId,
      );
    } catch (e) {
      bpsd = null;
    }
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            // color: Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      IconsaxPlusLinear.task_square,
                      size: 20,
                      color: Colors.blue,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Chi tiết tài sản",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    _buildInfoRow(
                        "Đơn vị kiểm kê", user!.tenDonVi ?? "Không có"),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, height: 1),
                    SizedBox(height: 12),
                    _buildInfoRow(
                        "Tên đợt kiểm kê", bbkk.TenDotKiemKe ?? "Không có"),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, height: 1),
                    SizedBox(height: 12),
                    _buildInfoRow("Số biên bản", bbkk.SoBienBan ?? "Không có"),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, height: 1),
                    SizedBox(height: 12),
                    _buildInfoRow(
                        "Hình thức kiểm kê", bbkk.HinhThucKiemKe ?? "Không có"),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, height: 1),
                    SizedBox(height: 12),
                    _buildInfoRow("Ngày lập", bbkk.NgayLap ?? "Không có"),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, height: 1),
                    SizedBox(height: 12),
                    _buildInfoRow(
                        "Ngày kiểm kê", bbkk.NgayKiemKe ?? "Không có"),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey.shade300, height: 1),
                    SizedBox(height: 12),
                    _buildInfoRow("Bộ phận sử dụng", bpsd?.title ?? "Toàn bộ"),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
  // End Thông tin kiểm kê

  // Hội đồng kiểm kê
  buildHoiDongDiv(BuildContext context) {
    List<Widget> rows = [];
    if (bbkk.ThanhVienHoiDong != null && bbkk.ThanhVienHoiDong!.length > 0) {
      bbkk.ThanhVienHoiDong!.forEach((element) {
        rows.add(
          InkWell(
            onTap: () {
              selectedTVHD = element;
              isShowTVHDDetail.value = true;
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${element.ten ?? ""} - ${element.chucvu ?? ""}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    element.chucdanh ?? "",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        rows.add(Divider());
      });
      rows.removeLast();
    }
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 20),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    Icon(
                      IconsaxPlusLinear.people,
                      size: 20,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Hội đồng kiểm kê",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: rows),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTVHDDetailModal(BuildContext context, dynamic tvhd) {
    return Stack(
      children: [
        Positioned.fill(
          child: InkWell(
            onTap: () => isShowTVHDDetail.value = false,
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
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Chi tiết thành viên hội đồng",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Họ và tên: "),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Text(
                                tvhd.ten ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Chức vụ: "),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Text(
                                tvhd.chucvu ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Đại diện: "),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Text(
                                tvhd.daidien ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Chức danh: "),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: Text(
                                tvhd.chucdanh ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    height: 50,
                                    onPressed: () =>
                                        isShowTVHDDetail.value = false,
                                    child: Text(
                                      "Đóng".toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                    color: Colors.blue,
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
                          onTap: () => isShowTVHDDetail.value = false,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  // End Hội đồng kiểm kê

  // QR kiểm kê
  buildQRKiemKeDiv(BuildContext context) {
    return Obx(() {
      final filteredList = getFilteredList();
      List<Widget> rows = [];

      if (filteredList.isNotEmpty) {
        for (int i = 0; i < filteredList.length; i++) {
          var ts = filteredList[i];
          ts.hasScanned = true;
          rows.add(
            Container(
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
                          "${i + 1}. ${ts.tenTS}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        (ts.nguyenGia != null
                            ? NumberUtils.formatCurrency(ts.nguyenGia!, 0)
                            : "0"),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
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
                        ts.tenBPSDTS ?? "Toàn bộ",
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
                        "Mã tài sản",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      Text(
                        ts.maTS ?? "",
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
                        "Kết quả kiểm kê",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      if (ts.trangThaiKK == 1)
                        Text(
                          'Đủ - Kiểm kê xong',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if (ts.trangThaiKK == 2)
                        Text(
                          'Thiếu - Đã đề xuất xử lý',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if (ts.trangThaiKK == 3 ||
                          ts.trangThaiKK == 4 ||
                          ts.trangThaiKK == null)
                        Text(
                          'Thiếu - Cần đề xuất xử lý',
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
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
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
                          'Mã tài sản',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: filterMaTSController,
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
                          'Kết quả kiểm kê',
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
                              child: DropdownButton<int?>(
                                isExpanded: true,
                                value: filterKetQuaKK.value,
                                hint: Text(
                                  'Chọn',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                underline: SizedBox(),
                                items: [
                                  DropdownMenuItem<int?>(
                                    value: null,
                                    child: Text(
                                      'Tất cả',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                  DropdownMenuItem<int?>(
                                    value: 1,
                                    child: Text(
                                      'Đủ - Kiểm kê xong',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem<int?>(
                                    value: 2,
                                    child: Text(
                                      'Thiếu - Đã đề xuất xử lý',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  DropdownMenuItem<int?>(
                                    value: 3,
                                    child: Text(
                                      'Thiếu - Cần đề xuất xử lý',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  filterKetQuaKK.value = value;
                                },
                              ),
                            )),
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
                                  filterMaTSController.clear();
                                  filterTenTSController.clear();
                                  filterMaTS.value = '';
                                  filterTenTS.value = '';
                                  filterKetQuaKK.value = null;
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
                                  filterMaTS.value = filterMaTSController.text;
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
