import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/bbkk.dart';
import 'package:qltstc_kiemke/models/taisan.dart';
import 'package:qltstc_kiemke/modules/bbkk/list_bbkk.dart';
import 'package:qltstc_kiemke/modules/bbkk/quetqrtaisan/taisannhapbosung.dart';
import 'package:qltstc_kiemke/modules/bbkk/quetqrtaisan/taisanquetmagiaodienchinh.dart';
import 'package:qltstc_kiemke/modules/bbkk/suabbkk/bosungtaisanedit.dart';
import 'package:qltstc_kiemke/modules/common_widgets/barcode_scanner_screen.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/taisan_service.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/dialog_utils.dart';
import 'package:qltstc_kiemke/utils/number_utils.dart';
import 'package:qltstc_kiemke/utils/loading_widget.dart';

class TaiSanKiemKeEditPage extends StatefulWidget {
  TaiSanKiemKeEditPage({required this.ngayKiemKe});

  final String? ngayKiemKe;

  @override
  _TaiSanKiemKeEditPageState createState() => _TaiSanKiemKeEditPageState();
}

class _TaiSanKiemKeEditPageState extends State<TaiSanKiemKeEditPage> {
  final listTS = RxList<TaiSan>();
  Rx<bool> showDeXuatAlertPopup = false.obs;
  Rx<bool> hasUpdated = false.obs;
  RxList<String> loadingQueue = <String>[].obs;
  int? isBBKKNhap = null;
  final String tenDonVi =
      UserService.sharedInstance().currentUser?.tenDonVi ?? "";

  Future<String?> _scanBarcode() async {
    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
    );
  }

  Future<void> _handleQRScan() async {
    final qrResult = await _scanBarcode();
    if (qrResult == null || qrResult.isEmpty || qrResult == '-1') return;

    final taiSan = await TaiSanService.sharedInstance()
        .getThongTinTaiSan(qrResult, widget.ngayKiemKe ?? "");

    if (taiSan == null) {
      DialogUtils.alert(context, "Mã QR không hợp lệ.");
      return;
    }

    if (!listTS.any((t) => t.tsId == taiSan.tsId)) {
      scanErrorModal();
      return;
    }

    syncTaiSan();
    final result = await Get.to<Map<String, dynamic>>(
      () => TaiSanQuetMaGiaoDienChinh(taiSan: taiSan, tenDonVi: tenDonVi),
      transition: Transition.cupertino,
    );

    if (result != null) {
      _handleScanResult(result);
    }
  }

  @override
  void initState() {
    super.initState();
    initOldData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountHeader(
        subTitle: "Thêm mới biên bản kiểm kê",
        pageName: "ThemMoi",
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 5),
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
                          onPressed: () => {},
                          child: Text(
                            "Thông tin",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                          onPressed: () => {},
                          child: Text(
                            "Hội đồng",
                            style: TextStyle(
                              color: Colors.blue,
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
                          onPressed: () => {},
                          child: Text(
                            "QR kiểm kê",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          Get.to(() => BoSungTaiSanEditPage());
                        },
                        child: Text(
                          "Bổ sung tài sản",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: Config.BASE_PADDING,
                    right: Config.BASE_PADDING,
                    top: 8,
                    bottom: 8,
                  ),
                  child: MaterialButton(
                    height: 45,
                    minWidth: double.infinity,
                    splashColor: Colors.grey,
                    highlightColor: Colors.grey,
                    elevation: 0,
                    highlightElevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: Colors.blue, width: 1),
                    ),
                    onPressed: _handleQRScan,
                    child: Text(
                      "Quét mã QR kiểm kê",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    color: Colors.white,
                  ),
                ),
                Obx(() => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Text(
                            "Danh sách tài sản",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Đã kiểm kê: ${listTS.where((ts) => ts.trangThaiKK != 3 && ts.trangThaiKK != null).length.toString()}/${listTS.length.toString()} tài sản",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )),
                Obx(() => buildTaiSans(context)),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: Config.BASE_PADDING,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: ColorUtils.gray),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: ColorUtils.gray,
                          ),
                          child: Text(
                            "Quay lại",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      if (isBBKKNhap == 1) ...{
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => confirmModal(false),
                            // validateCreate(isFinalSave: false),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: ColorUtils.mainColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Lưu nháp",
                              style: TextStyle(
                                color: ColorUtils.mainColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                      },
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => confirmModal(true),
                          // validateCreate(isFinalSave: true),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: ColorUtils.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Lưu",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            if (showDeXuatAlertPopup.value) buildDeXuatAlertPopup(context),
            Obx(() => LoadingWidget(loadingQueue.length > 0)),
          ],
        ),
      ),
    );
  }

  Stack buildDeXuatAlertPopup(BuildContext context) {
    final unprocessedAssets = listTS
        .where((e) =>
            (e.trangThaiKK == null || e.trangThaiKK == 3) && !e.hasScanned)
        .toList();

    final rows = <Widget>[];
    for (int i = 0; i < unprocessedAssets.length; i++) {
      final element = unprocessedAssets[i];
      rows.add(
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    "${i + 1}. ${element.tenTS ?? ''}",
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "SL: ${element.soLuong ?? ''}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        element.nguyenGia != null
                            ? NumberUtils.formatCurrency(element.nguyenGia!, 0)
                            : '',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            _buildAssetInfo(
                context, "Bộ phận sử dụng: ${element.tenBPSDTS ?? ''}"),
            _buildAssetInfo(context, "Mã TS: ${element.maTS ?? ''}"),
            _buildAssetInfo(
              context,
              "Giá trị còn lại: ${element.giaTriConLai != null ? NumberUtils.formatCurrency(element.giaTriConLai!, 0) : ''}",
            ),
            SizedBox(height: 15),
            if (i < unprocessedAssets.length - 1) Divider(),
          ],
        ),
      );
    }
    return Stack(
      children: [
        InkWell(
          onTap: () => showDeXuatAlertPopup.value = false,
          child: Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.grey.withOpacity(0.5)),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tài sản chưa được xử lý",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 400,
                        child: SingleChildScrollView(
                          child: Column(children: rows),
                        ),
                      ),
                      SizedBox(height: 30),
                      MaterialButton(
                        onPressed: () async {
                          showDeXuatAlertPopup.value = false;
                        },
                        child: Text(
                          "Đóng".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: Colors.white),
                        ),
                        color: ColorUtils.mainColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTaiSans(context) {
    var rows = <Widget>[];

    for (int i = 1; i <= listTS.length; i++) {
      var ts = listTS[i - 1];
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
                      "${i}. ${ts.tenTS}",
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
                  _getInventoryStatusWidget(ts.trangThaiKK),
                ],
              ),
            ],
          ),
        ),
      );
      if (i < listTS.length) rows.add(Divider());
    }
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 20),
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
    );
  }

  void initOldData() {
    loadingQueue.add("loading");
    listTS.clear();
    final bbkk = BBKKService.sharedInstance().currentRecord ?? BBKK();
    hasUpdated.value = bbkk.hasUpdated;
    isBBKKNhap = bbkk.LaLuuNhap;
    if (bbkk.ListTaiSan != null && bbkk.ListTaiSan!.isNotEmpty) {
      for (var ts in bbkk.ListTaiSan!) {
        ts.hasScanned = (ts.trangThaiKK != null && ts.trangThaiKK != 3);
      }
      listTS.addAll(bbkk.ListTaiSan!);
      loadingQueue.remove("loading");
    } else {
      loadDanhSachTaiSansForNewMode();
      loadingQueue.remove("loading");
    }
  }

  void checkTSKK(TaiSan ts, BuildContext context, bool hasScanned) {
    if (ts.daGiam == 1) {
      DialogUtils.alert(
        context,
        "Tài sản này đã giảm với lý do \"${ts.liDoGiam!}\" trên hệ thống. Vui lòng kiểm tra lại.",
      );
      return;
    }
    if (ts.donViId != null &&
        ts.donViId != UserService.sharedInstance().currentUser!.donviId) {
      DialogUtils.alert(
        context,
        "Tài sản này không thuộc đơn vị đang kiểm kê.",
      );
      return;
    }
    var existingIndex = listTS.indexWhere((t) => t.tsId == ts.tsId);
    if (existingIndex >= 0) {
      listTS[existingIndex] = ts;
    } else {
      ts.hasScanned = hasScanned;
      listTS.insert(0, ts);
    }
    listTS.refresh();
  }

  void loadDanhSachTaiSansForNewMode() {
    if (widget.ngayKiemKe == null ||
        widget.ngayKiemKe!.isEmpty ||
        listTS.isNotEmpty) return;

    final bbkk = BBKKService.sharedInstance().currentRecord;
    final boPhanId = bbkk?.BoPhanKiemKeId ?? "";
    final donViId = UserService.sharedInstance().currentUser!.donviId!;

    BBKKService.sharedInstance()
        .getDanhSachTaiSans(widget.ngayKiemKe!, boPhanId, donViId)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        listTS.addAll(
          value.map((loaiBienDong) {
            final taiSan = loaiBienDong.convertToTaiSan();
            taiSan.hasScanned = false;
            return taiSan;
          }),
        );
        listTS.refresh();
      }
    }).catchError((error) {
      print("Error loading DanhSachTaiSans: $error");
    });
  }

  void _handleScanResult(Map<String, dynamic> result) {
    final taiSan = result['taiSan'] as TaiSan?;
    if (taiSan != null) {
      checkTSKK(taiSan, context, true);
      syncTaiSan();
    }
  }

  Widget _buildAssetInfo(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ),
    );
  }

  Widget _getInventoryStatusWidget(int? trangThaiKK) {
    if (trangThaiKK == 1) {
      return Text(
        'Đủ - Kiểm kê xong',
        style: TextStyle(
          fontSize: 13,
          color: Colors.green,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (trangThaiKK == 2) {
      return Text(
        'Thiếu - Đã đề xuất xử lý',
        style: TextStyle(
          fontSize: 13,
          color: Colors.orangeAccent,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return Text(
        'Thiếu - Cần đề xuất xử lý',
        style: TextStyle(
          fontSize: 13,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  void syncTaiSan() {
    final bbkk = BBKKService.sharedInstance().currentRecord;
    if (bbkk != null) {
      bbkk.ListTaiSan = listTS.toList();
      bbkk.hasUpdated = hasUpdated.value;
      if (listTS.isNotEmpty) {
        bbkk.hasLoadedAssets = true;
      }
    }
  }

  Future<void> _handleSave(bool isFinalSave) async {
    // Set default status for unprocessed assets
    for (var element in listTS) {
      if (element.trangThaiKK == null) {
        element.trangThaiKK = 3;
      }
    }

    // Validate final save
    if (isFinalSave) {
      // Sort by name and processing status
      listTS.sort(
          (a, b) => b.tenTS!.toLowerCase().compareTo(a.tenTS!.toLowerCase()));
      listTS.sort((a, b) => (a.maHinhThucXuLy != null || a.hasScanned) &&
              (b.maHinhThucXuLy == null && !b.hasScanned)
          ? 1
          : 0);

      if (listTS.any((e) => e.trangThaiKK == null || e.trangThaiKK == 3)) {
        hasUpdated.value = true;
        syncTaiSan();
        errorModal("Đề xuất xử lý tài sản",
            "Còn tài sản chưa được đề nghị xử lý, vui lòng cập nhật đề nghị xử lý tài sản!");
        loadingQueue.remove("saving");
        return;
      }
    }

    // Save BBKK
    hasUpdated.value = true;
    syncTaiSan();
    final result =
        await BBKKService.sharedInstance().updateBBKK(isNhap: isFinalSave);
    loadingQueue.remove("saving");

    if (!result) {
      errorModal("Lưu thất bại",
          "Đã có lỗi xảy ra trong quá trình lưu biên bản kiểm kê. Vui lòng thử lại.");
    }
    Get.off(() => ListBBKK());
  }

  void confirmModal(bool isFinalSave) {
    final title =
        isFinalSave ? "Lưu biên bản kiểm kê" : "Lưu nháp biên bản kiểm kê";
    final confirmText = isFinalSave ? "Xác nhận lưu" : "Xác nhận lưu nháp";
    final question = isFinalSave
        ? "Bạn chắc chắn muốn lưu biên bản kiểm kê này?"
        : "Bạn chắc chắn muốn lưu nháp biên bản kiểm kê này?";
    final buttonText = isFinalSave ? "Lưu" : "Lưu nháp";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, size: 20, color: Colors.grey),
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
                      Icon(Icons.save, size: 60, color: Colors.blue),
                      Positioned(
                        right: 20,
                        bottom: 25,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isFinalSave ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.save_alt,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  confirmText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isFinalSave ? Colors.green : Colors.grey,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  question,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey[700], height: 1.5),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          loadingQueue.add("saving");
                          Navigator.of(context).pop();
                          _handleSave(isFinalSave);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text(buttonText,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text("Hủy",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
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

  void errorModal(String messageTitle, String messageContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Đã xảy ra lỗi",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, size: 20, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  // decoration: BoxDecoration(
                  //   color: Colors.blue.withOpacity(0.1),
                  //   borderRadius: BorderRadius.circular(16),
                  // ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Icon(Icons.save, size: 60, color: Colors.blue),
                      // Positioned(
                      //   right: 20,
                      //   bottom: 25,
                      //   child: Container(
                      //     width: 24,
                      //     height: 24,
                      //     decoration: BoxDecoration(
                      //       color: Colors.red,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child:
                      //         Icon(Icons.close, size: 16, color: Colors.white),
                      //   ),
                      // ),
                      Image.asset(
                        "assets/res/images/xoa_modal_icon.png",
                        height: Get.width * 0.8,
                        // width: Get.width,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  messageTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  messageContent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey[700], height: 1.5),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text("Đóng",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
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

  void scanErrorModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Đã xảy ra lỗi",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, size: 20, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  // decoration: BoxDecoration(
                  //   color: Colors.blue.withOpacity(0.1),
                  //   borderRadius: BorderRadius.circular(16),
                  // ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Icon(Icons.laptop_chromebook_outlined,
                      //     size: 60, color: Colors.blue),
                      // Positioned(
                      //   top: 33,
                      //   child: Center(
                      //     child: Container(
                      //       width: 24,
                      //       height: 24,
                      //       child: Icon(Icons.search,
                      //           size: 28, color: Colors.blue),
                      //     ),
                      //   ),
                      // ),
                      // Positioned(
                      //   right: 18,
                      //   bottom: 23,
                      //   child: Container(
                      //     width: 24,
                      //     height: 24,
                      //     decoration: BoxDecoration(
                      //       color: Colors.red,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child:
                      //         Icon(Icons.close, size: 16, color: Colors.white),
                      //   ),
                      // ),

                      Image.asset(
                        "assets/res/images/taisan_khong_ton_tai_modal_icon.png",
                        height: Get.width * 0.8,
                        // width: Get.width,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Tài sản không tồn tại",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Tài sản chưa có trên hệ thống, xin hãy bổ sung tài sản.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey[700], height: 1.5),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text("Đóng",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.off(() => TaiSanNhapBoSung()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text("Bổ sung",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
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
