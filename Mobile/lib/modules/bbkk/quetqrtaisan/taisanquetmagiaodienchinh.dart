import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/models/KeyValueModel.dart';
import 'package:qltstc_kiemke/models/StringKeyValueModel.dart';
import 'package:qltstc_kiemke/models/bpsd.dart';
import 'package:qltstc_kiemke/models/nguoisudung.dart';
import 'package:qltstc_kiemke/modules/bbkk/quetqrtaisan/taisannhapbosung.dart';
import 'package:qltstc_kiemke/modules/common_widgets/text_field.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';

import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/common_widget.dart';
import 'package:qltstc_kiemke/utils/dialog_utils.dart';

import '../../../models/taisan.dart';

class TaiSanQuetMaGiaoDienChinh extends StatefulWidget {
  final TaiSan? taiSan;
  final String? tenDonVi;
  const TaiSanQuetMaGiaoDienChinh({Key? key, this.taiSan, this.tenDonVi})
      : super(key: key);

  @override
  _TaiSanQuetMaGiaoDienChinhState createState() =>
      _TaiSanQuetMaGiaoDienChinhState();
}

class _TaiSanQuetMaGiaoDienChinhState extends State<TaiSanQuetMaGiaoDienChinh> {
  var _showBPSDModal = false.obs;
  var _showDeXuatModal = false.obs;
  var _isValidChucdanh = true.obs;

  var ghiChuCtrl = new TextEditingController();
  var trangThaiKK = null;
  var soLuongKiemKe = null;
  RxList<BPSD> _bpsdDatas = <BPSD>[].obs;
  RxList<NguoiSuDung> _nsdDatas = <NguoiSuDung>[].obs;
  Rxn<BPSD> _selectedbpsd = Rxn<BPSD>();
  Rxn<NguoiSuDung> _selectednsd = Rxn<NguoiSuDung>();

  final List<StringKeyValueModel> _tinhTrangDatas = [
    StringKeyValueModel("001", "Đang sử dụng"),
    StringKeyValueModel("002", "Không sử dụng"),
    StringKeyValueModel("003", "Không có nhu cầu sử dụng (chờ xử lý, hỏng)"),
    StringKeyValueModel("004", "Khác"),
    StringKeyValueModel("005", "Hư hỏng"),
    StringKeyValueModel("006", "Không sử dụng chờ xử lý"),
  ];
  Rxn<StringKeyValueModel> _selectedTinhTrang = Rxn<StringKeyValueModel>();

  final List<KeyValueModel> _xuLyDatas = [
    KeyValueModel(2, "Điều chuyển"),
    KeyValueModel(3, "Bán/chuyển nhượng"),
    KeyValueModel(4, "Thanh lý"),
    KeyValueModel(5, "Giảm khác"),
    KeyValueModel(6, "Thu hồi"),
    KeyValueModel(7, "Do điều chỉnh sau kiểm kê"),
  ];
  Rxn<KeyValueModel> _selectedDeXuat = Rxn<KeyValueModel>();
  Rxn<KeyValueModel> _selectedKetQua = Rxn<KeyValueModel>();

  Future<void> getBPSD(context) async {
    UserService.sharedInstance().getBPSD().then((value) {
      if (value.length > 0) {
        _bpsdDatas.addAll(value);
      } else {
        DialogUtils.alert(context, "Không tìm thấy bộ phận sử dụng");
      }
    });
  }

  Future<void> getNSD(String BPSDId) async {
    UserService.sharedInstance().getNSD(BPSDId).then((value) {
      if (value.length > 0) {
        _nsdDatas.addAll(value);
      } else {
        DialogUtils.alert(context, "Không tìm thấy người sử dụng");
      }
    });
  }

  void _onXacNhanPressed() {
    if (widget.taiSan == null) return;

    // Mark this asset as scanned and update it in the current record
    var updatedTaiSan = widget.taiSan!;
    updatedTaiSan.hasScanned = true;
    if (soLuongKiemKe != null && trangThaiKK != null) {
      updatedTaiSan.soLuongKiemKe = soLuongKiemKe;
      updatedTaiSan.trangThaiKK = trangThaiKK;
    } else {
      updatedTaiSan.soLuongKiemKe = 1;
      updatedTaiSan.trangThaiKK = 1; // Default to "Đã kiểm kê"
    }
    // Update in current BBKK record
    var bbkk = BBKKService.sharedInstance().currentRecord;
    if (bbkk != null) {
      // bbkk.ListTaiSan = bbkk.ListTaiSan ?? [];

      // Find and replace existing item or add new one
      var existingIndex =
          bbkk.ListTaiSan!.indexWhere((ts) => ts.tsId == updatedTaiSan.tsId);
      if (existingIndex >= 0) {
        bbkk.ListTaiSan![existingIndex] = updatedTaiSan;
        // } else {
        //   bbkk.ListTaiSan!.add(updatedTaiSan);
      }
      if (bbkk.ListTaiSanTamThoi != null &&
          bbkk.ListTaiSanTamThoi!.isNotEmpty) {
        var existingIndexTamThoi = bbkk.ListTaiSanTamThoi!
            .indexWhere((ts) => ts.taisanId == updatedTaiSan.tsId);
        if (existingIndexTamThoi >= 0) {
          bbkk.ListTaiSanTamThoi!.removeAt(existingIndexTamThoi);
        }
      }
      // bbkk.hasUpdated = true;
    }

    // Navigate back to TaiSanKiemKePage with result
    Get.back(result: {'action': 'scan_confirmed', 'taiSan': updatedTaiSan});
  }

  Row buildBPSDDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(0.4),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<BPSD?>(
              enabled: true,
              popupProps: PopupProps.dialog(
                showSelectedItems: true,
                fit: FlexFit.loose,
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item?.title,
                  isSelected,
                  false,
                ),
              ),
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  // hintText: "--Chọn chức danh--",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              items: _bpsdDatas.toList(),
              onChanged: (data) {
                _selectedbpsd.value = (data);
                _selectednsd.value = null;
                _nsdDatas.clear();
                getNSD(data?.key ?? "");
              },
              selectedItem: _selectedbpsd.value,
              dropdownBuilder: (context, item) =>
                  CommonWidget.customDropDownSelectedItem(
                context,
                item?.title,
                hint: "Chọn",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildNSDDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(0.4),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<NguoiSuDung?>(
              enabled: true,
              popupProps: PopupProps.dialog(
                showSelectedItems: true,
                fit: FlexFit.loose,
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item?.tenDTSDTS,
                  isSelected,
                  false,
                ),
              ),
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  // hintText: "--Chọn chức danh--",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              items: _nsdDatas.toList(),
              onChanged: (data) {
                _selectednsd.value = (data);
              },
              selectedItem: _selectednsd.value,
              dropdownBuilder: (context, item) =>
                  CommonWidget.customDropDownSelectedItem(
                context,
                item?.tenDTSDTS,
                hint: "Chọn",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTinhTrangDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(0.4),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<StringKeyValueModel?>(
              enabled: true,
              popupProps: PopupProps.dialog(
                showSelectedItems: true,
                fit: FlexFit.loose,
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item?.value,
                  isSelected,
                  false,
                ),
              ),
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  // hintText: "--Chọn chức danh--",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              items: _tinhTrangDatas,
              onChanged: (data) {
                _selectedTinhTrang.value = (data);
              },
              selectedItem: _selectedTinhTrang.value,
              dropdownBuilder: (context, item) =>
                  CommonWidget.customDropDownSelectedItem(
                context,
                item?.value,
                hint: "Chọn",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildDeXuatDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => Container(
              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: !_isValidChucdanh.value
                      ? Colors.red
                      : Colors.grey.withOpacity(0.4),
                  width: 1.0,
                ),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(10.0)),
              ),
              child: DropdownSearch<KeyValueModel?>(
                enabled: true,
                popupProps: PopupProps.dialog(
                  showSelectedItems: true,
                  fit: FlexFit.loose,
                  itemBuilder: (context, item, isSelected) =>
                      CommonWidget.customDropdownPopupItem(
                    context,
                    item?.value,
                    isSelected,
                    false,
                  ),
                ),
                compareFn: (i, s) => i == s,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    border: InputBorder.none,
                    // hintText: "--Chọn chức danh--",
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                items: _xuLyDatas,
                onChanged: (data) {
                  _isValidChucdanh.value = true;
                  _selectedDeXuat.value = (data);
                },
                selectedItem: _selectedDeXuat.value,
                dropdownBuilder: (context, item) =>
                    CommonWidget.customDropDownSelectedItem(
                  context,
                  item?.value,
                  hint: "Chọn",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildKetQuaDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(0.4),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<KeyValueModel?>(
              enabled: true,
              popupProps: PopupProps.dialog(
                showSelectedItems: true,
                fit: FlexFit.loose,
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item?.value,
                  isSelected,
                  false,
                ),
              ),
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  // hintText: "--Chọn chức danh--",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              items: _xuLyDatas,
              onChanged: (data) {
                _selectedKetQua.value = (data);
              },
              selectedItem: _selectedKetQua.value,
              dropdownBuilder: (context, item) =>
                  CommonWidget.customDropDownSelectedItem(
                context,
                item?.value,
                hint: "Chọn",
              ),
            ),
          ),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountHeader(
        subTitle: "Thông tin tài sản",
        pageName: "thongtin",
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 0, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              children: [
                                _buildInfoRow("Tên tài sản",
                                    widget.taiSan?.tenTS ?? "Không có"),
                                SizedBox(height: 12),
                                Divider(color: Colors.grey.shade300, height: 1),
                                SizedBox(height: 12),
                                _buildInfoRow("Nhóm tài sản",
                                    widget.taiSan?.tenNhomTS ?? "Không có"),
                                SizedBox(height: 12),
                                Divider(color: Colors.grey.shade300, height: 1),
                                SizedBox(height: 12),
                                _buildInfoRow("Mã tài sản",
                                    widget.taiSan?.maTS ?? "Không có"),
                                SizedBox(height: 12),
                                Divider(color: Colors.grey.shade300, height: 1),
                                SizedBox(height: 12),
                                _buildInfoRow("Nguyên giá",
                                    "${NumberFormat().format(widget.taiSan?.nguyenGia ?? 0)} VND"),
                                SizedBox(height: 12),
                                Divider(color: Colors.grey.shade300, height: 1),
                                SizedBox(height: 12),
                                _buildInfoRow("Giá trị còn lại",
                                    "${NumberFormat().format(widget.taiSan?.giaTriConLai ?? 0)} VND"),
                                SizedBox(height: 12),
                                Divider(color: Colors.grey.shade300, height: 1),
                                SizedBox(height: 12),
                                _buildInfoRow("Bộ phận sử dụng",
                                    widget.taiSan?.tenBPSDTS ?? "Không có"),
                                SizedBox(height: 12),
                                Divider(color: Colors.grey.shade300, height: 1),
                                SizedBox(height: 12),
                                _buildInfoRow("Người sử dụng",
                                    widget.taiSan?.tenDTSDTS ?? "Không có"),
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
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 45,
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
                                  widget.taiSan?.trangThaiKK = 4,
                                  Get.to(() => TaiSanNhapBoSung(
                                      taiSan: widget.taiSan))?.then((result) {
                                    if (result != null &&
                                        result is Map<String, dynamic>) {
                                      Get.back(result: result);
                                    }
                                  }),
                                },
                                child: Text(
                                  "Nhập bổ sung",
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
                                onPressed: () => {
                                  // _selectedTinhTrang.value = null,
                                  // _selectedDeXuat.value = null,
                                  // _selectedKetQua.value = null,
                                  _showDeXuatModal.value = true,
                                },
                                child: Text(
                                  "Đề xuất xử lý",
                                  style: TextStyle(
                                    color: Colors.blue,
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
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 45,
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
                                  _bpsdDatas.clear(),
                                  _nsdDatas.clear(),
                                  // _selectedbpsd.value = null,
                                  // _selectednsd.value = null,
                                  getBPSD(context),
                                  _showBPSDModal.value = true,
                                },
                                child: Text(
                                  "Cập nhật Bộ phận sử dụng tài sản",
                                  style: TextStyle(
                                    color: Colors.blue,
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
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
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
                                onPressed: () => _onXacNhanPressed(),
                                child: Text(
                                  "Xác nhận",
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
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
            Obx(
              () => _showBPSDModal.value || _showDeXuatModal.value
                  ? buildModal(context)
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModal(context) {
    return Stack(
      children: [
        Positioned.fill(
          child: InkWell(
            onTap: () => {
              _showBPSDModal.value = false,
              _showDeXuatModal.value = false,
            },
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
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _showBPSDModal.value
                                        ? "Cập nhật bộ phận sử dụng"
                                        : "Đề xuất xử lý tài sản",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            //BPSD Modal
                            if (_showBPSDModal.value) ...{
                              Row(
                                children: [
                                  Text("Bộ phận sử dụng"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildBPSDDropdown(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Người sử dụng"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildNSDDropdown(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Ghi chú"),
                                ],
                              ),
                              CustomTextField(
                                controller: ghiChuCtrl,
                                borderColor: Colors.grey.withOpacity(0.4),
                                hint: "Nhập thông tin",
                              ),
                            },
                            //End BPSD Modal
                            //DeXuat Modal
                            if (_showDeXuatModal.value) ...{
                              Row(
                                children: [
                                  Text("Tình trạng sử dụng"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildTinhTrangDropdown(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Đề xuất xử lý "),
                                  Text(
                                    "*",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildDeXuatDropdown(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text("Kết quả xử lý"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildKetQuaDropdown(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                            },
                            //End DeXuat Modal
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    height: 50,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    color: Colors.grey[300],
                                    onPressed: () {
                                      if (_showDeXuatModal.value) {
                                        _showDeXuatModal.value = false;
                                        _selectedTinhTrang.value = null;
                                        _selectedDeXuat.value = null;
                                        _selectedKetQua.value = null;
                                      } else {
                                        _showBPSDModal.value = false;
                                        _bpsdDatas.clear();
                                        _nsdDatas.clear();
                                        _selectedbpsd.value = null;
                                        _selectednsd.value = null;
                                        ghiChuCtrl.clear();
                                      }
                                    },
                                    child: Text(
                                      'Đóng',
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
                                    height: 50,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    color: Colors.blue,
                                    onPressed: () {
                                      if (_showDeXuatModal.value) {
                                        if (_selectedTinhTrang.value != null) {
                                          widget.taiSan!.maTinhTrangSuDung =
                                              _selectedTinhTrang.value?.key;
                                        }
                                        if (_selectedDeXuat.value == null) {
                                          _isValidChucdanh.value = false;
                                          DialogUtils.alert(context,
                                              "Vui lòng chọn đề xuất xử lý");
                                          return;
                                        } else {
                                          _isValidChucdanh.value = true;
                                          widget.taiSan!.maHinhThucXuLy =
                                              _selectedDeXuat.value!.key
                                                  .toString();
                                        }
                                        if (_selectedKetQua.value != null) {
                                          widget.taiSan!.maKetQuaXuLy =
                                              _selectedKetQua.value!.key
                                                  .toString();
                                        }
                                        _showDeXuatModal.value = false;
                                        trangThaiKK = 2;
                                        soLuongKiemKe = 0;
                                      } else {
                                        widget.taiSan!.ghiChu = (_selectedbpsd
                                                    .value?.key ??
                                                "") +
                                            " - " +
                                            (_selectedbpsd.value?.title ?? "") +
                                            "\n" +
                                            (_selectednsd.value?.maDTSDTS ??
                                                "") +
                                            " - " +
                                            (_selectednsd.value?.tenDTSDTS ??
                                                "") +
                                            "\n" +
                                            ghiChuCtrl.text;
                                        if (_selectedbpsd.value != null) {
                                          widget.taiSan!.BPSDTSID =
                                              _selectedbpsd.value!.key;
                                          widget.taiSan!.tenBPSDTS =
                                              _selectedbpsd.value!.title;
                                        }
                                        if (_selectednsd.value != null) {
                                          widget.taiSan!.DTSDTSID =
                                              _selectednsd.value!.maDTSDTS;
                                          widget.taiSan!.tenDTSDTS =
                                              _selectednsd.value!.tenDTSDTS;
                                        }
                                        _showBPSDModal.value = false;
                                        trangThaiKK = 1;
                                        soLuongKiemKe = 1;
                                      }
                                    },
                                    child: Text(
                                      _showBPSDModal.value
                                          ? "Cập nhật"
                                          : "Đề xuất",
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
                          onTap: () {
                            if (_showDeXuatModal.value) {
                              _showDeXuatModal.value = false;
                              _selectedTinhTrang.value = null;
                              _selectedDeXuat.value = null;
                              _selectedKetQua.value = null;
                            } else {
                              _showBPSDModal.value = false;
                              _bpsdDatas.clear();
                              _nsdDatas.clear();
                              _selectedbpsd.value = null;
                              _selectednsd.value = null;
                              ghiChuCtrl.clear();
                            }
                          },
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
