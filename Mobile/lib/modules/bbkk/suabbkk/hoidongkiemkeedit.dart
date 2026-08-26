import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/thanhvienhoidong.dart';
import 'package:qltstc_kiemke/modules/bbkk/list_bbkk.dart';
import 'package:qltstc_kiemke/modules/bbkk/suabbkk/taisankiemkeedit.dart';
import 'package:qltstc_kiemke/modules/common_widgets/text_field.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/common_widget.dart';
import 'package:qltstc_kiemke/utils/dialog_utils.dart';
import 'package:qltstc_kiemke/utils/loading_widget.dart';

// ignore: must_be_immutable
class HoiDongKiemKeEditPage extends StatelessWidget {
  HoiDongKiemKeEditPage();

  RxList<TVHD> dsTVHD = <TVHD>[].obs;
  var _showEditPanel = false.obs;
  var editPanelTitle = "Thêm thành viên hội đồng";
  Rxn<TVHD> _editingTV = Rxn<TVHD>();
  RxList<String> loadingQueue = <String>[].obs;
  int? isBBKKNhap = null;

  initOldData() {
    var bbkk = BBKKService.sharedInstance().currentRecord;
    isBBKKNhap = bbkk?.LaLuuNhap;
    dsTVHD.value = bbkk?.ThanhVienHoiDong ?? <TVHD>[];
  }

  @override
  Widget build(BuildContext context) {
    initOldData();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                                color: Colors.black,
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
                                color: Colors.blue,
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
                        Spacer(),
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
                      onPressed: () {
                        _editingTV.value = new TVHD();
                        _showEditPanel.value = true;
                        tenCtrl.clear();
                        chucvuCtrl.clear();
                        daidienCtrl.clear();
                        clearAlerts();
                        _selectedChucDanh.value = "";
                      },
                      child: Text(
                        "Thêm thành viên hội đồng",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Config.BASE_PADDING,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Obx(
                              () => dsTVHD.length > 0
                                  ? buildDivTVHD(context)
                                  : Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Không có thành viên hội đồng kiểm kê",
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                              onPressed: () => confirmModal(context),
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
                            onPressed: () {
                              var currentRecord =
                                  BBKKService.sharedInstance().currentRecord;

                              DateFormat df = DateFormat("dd/MM/yyyy");
                              var ngaykk = df.parse(currentRecord!.NgayKiemKe!);
                              DateFormat df1 = DateFormat("yyyy/MM/dd");

                              Get.to(() => TaiSanKiemKeEditPage(
                                    ngayKiemKe: df1.format(ngaykk),
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: ColorUtils.mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Tiếp tục",
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
              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _showEditPanel.value
                      ? buildEditModal(context)
                      : SizedBox.shrink(),
                ),
              ),
              Obx(() => LoadingWidget(loadingQueue.length > 0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditModal(context) {
    return Stack(
      children: [
        Positioned.fill(
          child: InkWell(
            onTap: () => _showEditPanel.value = false,
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
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    editPanelTitle,
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
                                Text("Họ và tên "),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              controller: tenCtrl,
                              validator: _validatedForm.value
                                  ? validateRequired
                                  : null,
                              borderColor: ColorUtils.gray.withOpacity(0.4),
                              hint: "Nhập thông tin",
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Chức vụ "),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              controller: chucvuCtrl,
                              validator: _validatedForm.value
                                  ? validateRequired
                                  : null,
                              borderColor: ColorUtils.gray.withOpacity(0.4),
                              hint: "Nhập thông tin",
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Đại diện "),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              controller: daidienCtrl,
                              validator: _validatedForm.value
                                  ? validateRequired
                                  : null,
                              borderColor: ColorUtils.gray.withOpacity(0.4),
                              hint: "Nhập thông tin",
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Chức danh "),
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
                                  child: buildChucDanhDropdown(
                                    context,
                                  ),
                                ),
                              ],
                            ),
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
                                      _showEditPanel.value = false;
                                      tenCtrl.clear();
                                      chucvuCtrl.clear();
                                      daidienCtrl.clear();
                                      _selectedChucDanh.value = "";
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
                                _editingTV.value?.ten == null
                                    ? Expanded(
                                        child: MaterialButton(
                                          height: 50,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          color: Colors.blue,
                                          onPressed: () =>
                                              onSaveTVHDAndContinue(context),
                                          child: Text(
                                            "Lưu và nhập tiếp",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: MaterialButton(
                                          height: 50,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          color: Colors.blue,
                                          onPressed: () => onSaveTVHD(context),
                                          child: Text(
                                            "Lưu",
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
                            _editingTV.value = null;
                            _showEditPanel.value = false;
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

  Row buildChucDanhDropdown(BuildContext context) {
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
                      : ColorUtils.gray.withOpacity(0.4),
                  width: 1.0,
                ),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(10.0)),
              ),
              child: DropdownSearch<String?>(
                enabled: true,
                popupProps: PopupProps.dialog(
                  showSelectedItems: true,
                  fit: FlexFit.loose,
                  itemBuilder: (context, item, isSelected) =>
                      CommonWidget.customDropdownPopupItem(
                    context,
                    item,
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
                    hintText: "--Chọn chức danh--",
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                asyncItems: (String? filter) => getChucDanhData(filter),
                onChanged: (data) {
                  _isValidChucdanh.value = true;
                  _selectedChucDanh.value = (data);
                },
                selectedItem: _selectedChucDanh.value,
                dropdownBuilder: (context, item) =>
                    CommonWidget.customDropDownSelectedItem(
                  context,
                  item,
                  hint: "--Chọn chức danh--",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<List<String>> getChucDanhData(filter) async {
    return _chucDanhDatas.where((element) => element.contains(filter)).toList();
  }

  buildDivTVHD(context) {
    List<Widget> rows = [];
    if (dsTVHD.length > 0)
      for (var tv in dsTVHD) {
        rows.add(buildRowTVHD(tv, context));
        rows.add(Divider());
      }

    rows.removeLast();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(children: rows),
        ),
      ],
    );
  }

  Widget buildRowTVHD(TVHD tv, context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8),
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
                  "${tv.ten ?? ""} - ${tv.chucvu ?? ""}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: 12),
              InkWell(
                onTap: () => openEdit(tv),
                child: Icon(
                  IconsaxPlusLinear.edit_2,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 15),
              InkWell(
                onTap: () {
                  deleteBBKK(tv, context);
                },
                child: Icon(
                  IconsaxPlusLinear.trash,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            tv.chucdanh ?? "",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void deleteBBKK(TVHD tv, BuildContext context) {
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
                      "Xóa hội đồng kiểm kê",
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
                  // decoration: BoxDecoration(
                  //   color: Colors.blue.withOpacity(0.1),
                  //   borderRadius: BorderRadius.circular(16),
                  // ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Icon(
                      //   Icons.folder,
                      //   size: 60,
                      //   color: Colors.blue,
                      // ),
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
                      //     child: Icon(
                      //       Icons.close,
                      //       size: 16,
                      //       color: Colors.white,
                      //     ),
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
                  "Xác nhận xóa",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Bạn chắc chắn muốn xóa hội đồng kiểm kê đã được chọn?",
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
                          dsTVHD.remove(tv);
                          BBKKService.sharedInstance()
                              .currentRecord!
                              .ThanhVienHoiDong = dsTVHD.toList();
                          _showEditPanel.value = false;
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

  openEdit(TVHD tv) {
    _showEditPanel.value = true;
    editPanelTitle = "Sửa thành viên hội đồng";
    _editingTV.value = tv;
    tenCtrl.text = _editingTV.value!.ten!;
    chucvuCtrl.text = _editingTV.value!.chucvu!;
    daidienCtrl.text = _editingTV.value!.daidien!;
    onChangeChucDanh(tv.chucdanh);
    clearAlerts();
  }

  var tenCtrl = new TextEditingController();
  var _validatedForm = false.obs;
  var _isValidChucdanh = true.obs;
  var chucvuCtrl = new TextEditingController();
  var daidienCtrl = new TextEditingController();

  void onSaveDraft(context) async {
    loadingQueue.add("checkSoBienBanExists");

    var result = await BBKKService.sharedInstance().updateBBKK(isNhap: false);
    if (result) {
      DialogUtils.alert(context, "Lưu nháp thành công");
      Get.off(() => ListBBKK());
      loadingQueue.remove("checkSoBienBanExists");
    } else {
      DialogUtils.alert(context, "Lưu lỗi");
      loadingQueue.remove("checkSoBienBanExists");
    }
  }

  validateRequired(String text) {
    return text.isNotEmpty && text.length <= 255;
  }

  clearAlerts() {
    _validatedForm.value = false;
    _isValidChucdanh.value = true;
  }

  onSaveTVHD(context) {
    _validatedForm.value = true;
    if (_selectedChucDanh.value == null || _selectedChucDanh.value!.isEmpty) {
      _isValidChucdanh.value = false;
    }
    var errorCount = 0;
    if (!validateRequired(tenCtrl.text)) errorCount++;
    if (!validateRequired(chucvuCtrl.text)) errorCount++;
    if (!validateRequired(daidienCtrl.text)) errorCount++;
    if (_selectedChucDanh.value == null || _selectedChucDanh.value!.isEmpty)
      errorCount++;
    if (errorCount > 1) {
      DialogUtils.alert(context, "Vui lòng nhập các trường bắt buộc");
      return;
    }
    if (!validateRequired(tenCtrl.text)) {
      DialogUtils.alert(context, "Vui lòng nhập Tên thành viên");
      return;
    }
    if (!validateRequired(chucvuCtrl.text)) {
      DialogUtils.alert(context, "Vui lòng nhập Chức vụ");
      return;
    }
    if (!validateRequired(daidienCtrl.text)) {
      DialogUtils.alert(context, "Vui lòng nhập Đại diện");
      return;
    }
    if (_selectedChucDanh.value == null || _selectedChucDanh.value!.isEmpty) {
      DialogUtils.alert(context, "Vui lòng chọn Chức danh");
      return;
    } else {
      var tvhd = new TVHD();
      tvhd.ten = tenCtrl.text;
      tvhd.chucvu = chucvuCtrl.text;
      tvhd.daidien = daidienCtrl.text;
      tvhd.chucdanh = _chucDanhDatas
          .where((element) => element == _selectedChucDanh.value)
          .first;
      if (_editingTV.value!.ten != null) dsTVHD.remove(_editingTV.value);
      dsTVHD.add(tvhd);
      BBKKService.sharedInstance().currentRecord!.ThanhVienHoiDong =
          dsTVHD.toList();
      _showEditPanel.value = false;
      _editingTV.value = new TVHD();
    }
  }

  onSaveTVHDAndContinue(context) {
    _validatedForm.value = true;
    if (_selectedChucDanh.value == null || _selectedChucDanh.value!.isEmpty) {
      _isValidChucdanh.value = false;
    }
    var errorCount = 0;
    if (!validateRequired(tenCtrl.text)) errorCount++;
    if (!validateRequired(chucvuCtrl.text)) errorCount++;
    if (!validateRequired(daidienCtrl.text)) errorCount++;
    if (_selectedChucDanh.value == null || _selectedChucDanh.value!.isEmpty)
      errorCount++;
    if (errorCount > 1) {
      DialogUtils.alert(context, "Vui lòng nhập các trường bắt buộc");
      return;
    }
    if (!validateRequired(tenCtrl.text)) {
      DialogUtils.alert(context, "Vui lòng nhập Tên thành viên");
      return;
    }
    if (!validateRequired(chucvuCtrl.text)) {
      DialogUtils.alert(context, "Vui lòng nhập Chức vụ");
      return;
    }
    if (!validateRequired(daidienCtrl.text)) {
      DialogUtils.alert(context, "Vui lòng nhập Đại diện");
      return;
    }
    if (_selectedChucDanh.value == null || _selectedChucDanh.value!.isEmpty) {
      DialogUtils.alert(context, "Vui lòng chọn Chức danh");
      return;
    } else {
      // Lưu thông tin thành viên hiện tại
      var tvhd = new TVHD();
      tvhd.ten = tenCtrl.text;
      tvhd.chucvu = chucvuCtrl.text;
      tvhd.daidien = daidienCtrl.text;
      tvhd.chucdanh = _chucDanhDatas
          .where((element) => element == _selectedChucDanh.value)
          .first;
      if (_editingTV.value!.ten != null) dsTVHD.remove(_editingTV.value);
      dsTVHD.add(tvhd);
      BBKKService.sharedInstance().currentRecord!.ThanhVienHoiDong =
          dsTVHD.toList();

      // Reset form để nhập tiếp thay vì đóng modal
      _editingTV.value = new TVHD();
      tenCtrl.clear();
      chucvuCtrl.clear();
      daidienCtrl.clear();
      _selectedChucDanh.value = "";
      clearAlerts();
      // Giữ modal mở để người dùng nhập tiếp
    }
  }

  var _selectedChucDanh = Rxn<String>();
  List<String> _chucDanhDatas = ["Trưởng ban", "Phó Trưởng ban", "Ủy viên"];

  onChangeChucDanh(selectedTest) {
    print(selectedTest);
    _selectedChucDanh.value = selectedTest;
  }

  List<DropdownMenuItem<Object?>> buildChucDanhs(context) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _chucDanhDatas) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i, style: Theme.of(context).textTheme.bodyMedium),
        ),
      );
    }
    return items;
  }

  void confirmModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                    Text("Lưu nháp biên bản kiểm kê",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    InkWell(
                      onTap: () => Navigator.of(dialogContext).pop(),
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
                            color: Colors.grey,
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
                  "Xác nhận lưu nháp",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Bạn chắc chắn muốn lưu nháp biên bản kiểm kê này?",
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
                          Navigator.of(dialogContext).pop();
                          onSaveDraft(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text("Lưu nháp",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
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
}
