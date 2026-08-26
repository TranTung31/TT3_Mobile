import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/KeyValueModel.dart';
import 'package:qltstc_kiemke/models/StringKeyValueModel.dart';

import 'package:qltstc_kiemke/models/bpsd.dart';
import 'package:qltstc_kiemke/models/nhomtaisan.dart';
import 'package:qltstc_kiemke/models/taisan.dart';
import 'package:qltstc_kiemke/models/taisanbosung.dart';
import 'package:qltstc_kiemke/modules/common_widgets/text_field.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/common_widget.dart';
import 'package:qltstc_kiemke/utils/dialog_utils.dart';
import 'package:qltstc_kiemke/utils/number_utils.dart';

class TaiSanNhapBoSung extends StatefulWidget {
  // TaiSanNhapBoSung();
  final TaiSan? taiSan;
  final TSBS? editingTSBS;
  final int? index;
  const TaiSanNhapBoSung({Key? key, this.taiSan, this.editingTSBS, this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TaiSanNhapBoSung();
  }
}

class _TaiSanNhapBoSung extends State<TaiSanNhapBoSung> {
  final nguyengiaCtrl = new TextEditingController();
  final giatriconlaiCtrl = new TextEditingController();
  final tenCtrl = new TextEditingController();
  final FocusNode nguyengiaFocusNode = FocusNode();
  final FocusNode giatriconlaiFocusNode = FocusNode();

  var _isValidNhomTS = false.obs;
  RxList<TSBS> dsTSBS = <TSBS>[].obs;
  final List<StringKeyValueModel> _tinhTrangDatas = [
    StringKeyValueModel("001", "Đang sử dụng"),
    StringKeyValueModel("002", "Không sử dụng"),
    StringKeyValueModel("003", "Không có nhu cầu sử dụng (chờ xử lý, hỏng)"),
    StringKeyValueModel("004", "Khác"),
    StringKeyValueModel("005", "Hư hỏng"),
    StringKeyValueModel("006", "Không sử dụng chờ xử lý"),
  ];
  Rxn<StringKeyValueModel> _selectedTinhTrang = Rxn<StringKeyValueModel>();

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern('vi_VN').format(int.parse(s));

  Rxn<NhomTS?> _selectedNhomSD = Rxn<NhomTS>();

  RxList<String> loadingQueue = <String>[].obs;
  final String _loadingBPSD = "_loadingBPSD";
  Rxn<BPSD> _selectedbpsd = Rxn<BPSD>();
  RxList<BPSD> _bpsdDatas = <BPSD>[].obs;
  Rxn<KeyValueModel> hinhthucxuly = Rxn<KeyValueModel>();
  RxList<NhomTS> _nhomSDDatas = <NhomTS>[].obs;
  Rxn<KeyValueModel> ketquaxuly = Rxn<KeyValueModel>();

  @override
  void initState() {
    super.initState();
    // Initialize status data
    nguyengiaFocusNode.addListener(() {
      if (!nguyengiaFocusNode.hasFocus && nguyengiaCtrl.text.isNotEmpty) {
        // if (giatriconlaiCtrl.text.isEmpty) {
        //   giatriconlaiCtrl.text = nguyengiaCtrl.text;
        // }
        giatriconlaiCtrl.text = nguyengiaCtrl.text;
      }
    });
    _selectedTinhTrang.value =
        _tinhTrangDatas.firstWhereOrNull((element) => element.key == "001");
    getBPSD(context);
    getNhomTS(context);

    // Load existing data if editing TSBS (after a short delay to ensure data is loaded)
    if (widget.editingTSBS != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        loadExistingTSBSData();
      });
    }
  }

  @override
  void dispose() {
    nguyengiaFocusNode.dispose();
    giatriconlaiFocusNode.dispose();
    super.dispose();
  }

  void loadExistingTSBSData() {
    if (widget.editingTSBS != null) {
      final tsbs = widget.editingTSBS!;
      tenCtrl.text = tsbs.ten ?? "";
      nguyengiaCtrl.text = tsbs.nguyengia != null
          ? NumberUtils.formatCurrency(tsbs.nguyengia!, 0)
          : "";
      giatriconlaiCtrl.text = tsbs.giaTriConLai != null
          ? NumberUtils.formatCurrency(tsbs.giaTriConLai!, 0)
          : "";
      _selectedTinhTrang.value = _tinhTrangDatas.firstWhereOrNull(
        (element) => element.key == tsbs.tinhtrangsudung,
      );
      _selectedNhomSD.value = tsbs.nhomtaisan;
      _selectedbpsd.value = tsbs.bophansudung;

      // Load Đề xuất xử lý (hinhthucxuly)
      if (tsbs.maHinhThucXuLy != null && tsbs.maHinhThucXuLy!.isNotEmpty) {
        try {
          int maHinhThuc = int.parse(tsbs.maHinhThucXuLy!);
          hinhthucxuly.value = getHinhThucXuLyByKey(maHinhThuc);
        } catch (e) {
          print('Error parsing maHinhThucXuLy: ${tsbs.maHinhThucXuLy}');
        }
      }

      // Load Kết quả xử lý (ketquaxuly)
      if (tsbs.maKetQuaXuLy != null && tsbs.maKetQuaXuLy!.isNotEmpty) {
        try {
          int maKetQua = int.parse(tsbs.maKetQuaXuLy!);
          ketquaxuly.value = getKetQuaXuLyByKey(maKetQua);
        } catch (e) {
          print('Error parsing maKetQuaXuLy: ${tsbs.maKetQuaXuLy}');
        }
      }
    }
  }

  Future<void> getBPSD(context) async {
    loadingQueue.add(_loadingBPSD);
    UserService.sharedInstance().getBPSD().then((value) {
      loadingQueue.remove(_loadingBPSD);
      if (value.length > 0) {
        _bpsdDatas.addAll(value);
        // if (widget.taiSan?.tenBPSDTS != null) {
        //   var existingBPSD = _bpsdDatas.firstWhereOrNull(
        //     (element) => element.title == widget.taiSan?.tenBPSDTS,
        //   );
        //   if (existingBPSD != null) {
        //     _selectedbpsd.value = existingBPSD;
        //   }
        // }
        // Handle existing TSBS data
        if (widget.editingTSBS?.bophansudung != null) {
          var editingBPSD = _bpsdDatas.firstWhereOrNull(
            (element) => element.key == widget.editingTSBS!.bophansudung!.key,
          );
          if (editingBPSD != null) {
            _selectedbpsd.value = editingBPSD;
          }
        }
        // initOldData();
      } else {
        DialogUtils.alert(context, "Không tìm thấy bộ phận sử dụng");
        // initOldData();
      }
    });
  }

  Future<void> getNhomTS(context) async {
    loadingQueue.add(_loadingBPSD);
    UserService.sharedInstance().getNhomTS().then((value) {
      loadingQueue.remove(_loadingBPSD);
      if (value.length > 0) {
        _nhomSDDatas.addAll(value);
        if (widget.taiSan?.tenBPSDTS != null) {
          var existingBPSD = _nhomSDDatas.firstWhereOrNull(
            (element) => element.title == widget.taiSan?.tenBPSDTS,
          );
          if (existingBPSD != null) {
            _selectedNhomSD.value = existingBPSD;
          }
        }
        // Handle existing TSBS data
        if (widget.editingTSBS?.nhomtaisan != null) {
          var editingNhomTS = _nhomSDDatas.firstWhereOrNull(
            (element) => element.key == widget.editingTSBS!.nhomtaisan!.key,
          );
          if (editingNhomTS != null) {
            _selectedNhomSD.value = editingNhomTS;
          }
        }
        // initOldData();
      } else {
        DialogUtils.alert(context, "Không tìm thấy nhóm tài sản");
        // initOldData();
      }
    });
  }

  RxBool _validatedForm = false.obs;

  @override
  Widget build(BuildContext context) {
    // dvCtrl.text = UserService.sharedInstance().currentUser!.tenDonVi!;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AccountHeader(
            subTitle: widget.editingTSBS != null
                ? "Chỉnh sửa Tài sản bổ sung"
                : "Thêm mới Tài sản bổ sung",
            pageName: "ThemMoi",
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: Config.BASE_PADDING,
                      ),
                      child: Obx(
                        () => Column(
                          children: [
                            // SizedBox(height: 100),
                            Row(
                              children: [
                                Text("Nhóm tài sản "),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            buildNhomTSDropdown(context),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Tên tài sản "),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                              hint: "Nhập thông tin",
                              controller: tenCtrl,
                              validator: _validatedForm.value
                                  ? validateRequired
                                  : null,
                              borderColor: ColorUtils.gray.withOpacity(0.4),
                            ),
                            SizedBox(height: 10),
                            Row(children: [
                              Text("Nguyên giá "),
                              // Text(
                              //   "*",
                              //   style: TextStyle(
                              //     color: Colors.red,
                              //   ),
                              // ),
                            ]),
                            Focus(
                              focusNode: nguyengiaFocusNode,
                              child: CustomTextField(
                                hint: "Nhập thông tin",
                                inputType: TextInputType.number,
                                controller: nguyengiaCtrl,
                                prefixText: "VNĐ",
                                onChanged: (text) {
                                  try {
                                    text =
                                        '${_formatNumber(text.replaceAll('.', ''))}';
                                    nguyengiaCtrl.value = TextEditingValue(
                                      text: text,
                                      selection: TextSelection.collapsed(
                                        offset: text.length,
                                      ),
                                    );
                                  } catch (e) {}
                                },
                                borderColor: ColorUtils.gray.withOpacity(0.4),
                                // validator: _validatedForm.value
                                //     ? validateRequired
                                //     : null,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(children: [
                              Text("Giá trị còn lại "),
                              // Text(
                              //   "*",
                              //   style: TextStyle(
                              //     color: Colors.red,
                              //   ),
                              // ),
                            ]),
                            Focus(
                              focusNode: giatriconlaiFocusNode,
                              child: CustomTextField(
                                hint: "Nhập thông tin",
                                inputType: TextInputType.number,
                                controller: giatriconlaiCtrl,
                                prefixText: "VNĐ",
                                onChanged: (text) {
                                  try {
                                    text =
                                        '${_formatNumber(text.replaceAll('.', ''))}';
                                    giatriconlaiCtrl.value = TextEditingValue(
                                      text: text,
                                      selection: TextSelection.collapsed(
                                        offset: text.length,
                                      ),
                                    );
                                  } catch (e) {}
                                },
                                borderColor: ColorUtils.gray.withOpacity(0.4),
                                // validator: _validatedForm.value
                                //     ? (text) =>
                                //         validateGiaTriConLai(text) == null
                                //     : null,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Bộ phận sử dụng "),
                              ],
                            ),
                            SizedBox(height: 10),
                            buildBPSDDropdown(context),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Tình trạng sử dụng "),
                              ],
                            ),
                            SizedBox(height: 10),
                            buildTinhTrangDropdown(context),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Đề xuất xử lý "),
                              ],
                            ),
                            SizedBox(height: 10),
                            buildDeXuatDropdown(context),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Kết quả xử lý "),
                              ],
                            ),
                            SizedBox(height: 10),
                            buildKetQuaDropdown(context),
                            SizedBox(height: 20),
                            Row(
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
                                    onPressed: () => onSaveTSBS(context),
                                    child: Text(
                                      "Lưu",
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
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  var _nhomTSSearchboxCtrl = TextEditingController();
  var _BPSDTSSearchboxCtrl = TextEditingController();

  Row buildBPSDDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: ColorUtils.gray.withOpacity(0.4),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<BPSD?>(
              enabled: true,
              popupProps: PopupProps.modalBottomSheet(
                fit: FlexFit.tight,
                onDismissed: () {
                  _BPSDTSSearchboxCtrl.clear();
                },
                showSelectedItems: true,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  padding: EdgeInsets.symmetric(
                    horizontal: Config.BASE_PADDING,
                    vertical: 10,
                  ),
                  controller: _BPSDTSSearchboxCtrl,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _BPSDTSSearchboxCtrl.clear();
                      },
                    ),
                  ),
                ),
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item?.title,
                  isSelected,
                  false,
                ),
              ),
              clearButtonProps: ClearButtonProps(
                isVisible: _selectedbpsd.value != null,
              ),
              compareFn: (i, s) => i?.key == s?.key,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  hintText: "Chọn",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              asyncItems: (String? filter) => getBPSDData(filter),
              onChanged: (data) {
                _selectedbpsd.value = (data);
              },
              filterFn: (item, filter) {
                if (filter.isEmpty) return true;
                return (item?.title ?? "")
                    .toLowerCase()
                    .contains(filter.toLowerCase());
              },
              selectedItem: _selectedbpsd.value,
              dropdownBuilder: (context, item) =>
                  CommonWidget.customDropDownSelectedItem(
                context,
                item?.title,
                hint: "Chọn",
                enable: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  validateRequired(String text) {
    return text.isNotEmpty && text.length <= 255;
  }

  validateRequiredNumber(String text) {
    try {
      var a = int.tryParse(text.replaceAll(".", ""));
      return a != null;
    } catch (e) {
      return false;
    }
  }

  // Validation for giatriconlai to ensure it's <= nguyengia
  String? validateGiaTriConLai(String text) {
    // if (!validateRequired(text)) {
    //   return "Vui lòng nhập Giá trị còn lại";
    // }

    // if (!validateRequiredNumber(text)) {
    //   return "Giá trị còn lại không hợp lệ";
    // }

    try {
      var giaTriConLai = double.parse(text.replaceAll(".", ""));
      var nguyenGia = double.parse(
          nguyengiaCtrl.text.replaceAll(".", "").isEmpty
              ? "0"
              : nguyengiaCtrl.text.replaceAll(".", ""));

      if (giaTriConLai > nguyenGia) {
        return "Giá trị còn lại phải nhỏ hơn hoặc bằng Nguyên giá";
      }
      // if (giaTriConLai == 0) {
      //   return "Giá trị còn lại phải lớn hơn 0";
      // }

      return null; // Valid
    } catch (e) {
      return "Giá trị không hợp lệ";
    }
  }

  initOldData() {
    loadingQueue.clear();
    var currentRecord = BBKKService.sharedInstance().currentRecord;
    if (currentRecord == null) return;
    loadingQueue.add("initData");
    Future.delayed(Duration(milliseconds: 300), () {
      // Initialize department selection if available
      _selectedbpsd.value = _bpsdDatas.any(
        (element) =>
            element.key == currentRecord.BoPhanKiemKeId ||
            element.title == currentRecord.BoPhanSuDung,
      )
          ? _bpsdDatas.firstWhere(
              (e) =>
                  e.key == currentRecord.BoPhanKiemKeId ||
                  e.title == currentRecord.BoPhanSuDung,
            )
          : null;
      loadingQueue.remove("initData");
    });
  }

  Future<List<NhomTS>> getNhomTSData(filter) async {
    return _nhomSDDatas
        .where((element) =>
            (element.title ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  onSaveTSBS(context) {
    _validatedForm.value = true;

    var errorCount = 0;
    if (!validateRequired(tenCtrl.text)) errorCount++;
    if (_selectedNhomSD.value?.title == null ||
        _selectedNhomSD.value!.title!.isEmpty) errorCount++;
    if (_selectedTinhTrang.value == null ||
        _selectedTinhTrang.value?.key == null) errorCount++;
    if (errorCount > 1) {
      DialogUtils.alert(context, "Vui lòng nhập các trường bắt buộc");
      return;
    }
    if (!validateRequired(tenCtrl.text)) {
      if (tenCtrl.text.length > 255) {
        DialogUtils.alert(context, "Tên Tài sản dài quá 255 ký tự");
        return;
      }
      DialogUtils.alert(context, "Vui lòng nhập Tên tài sản");
      return;
    }
    if (nguyengiaCtrl.text.length > 25) {
      DialogUtils.alert(context, "Nguyên giá dài quá 25 ký tự");
      return;
    }
    if (giatriconlaiCtrl.text.length > 25) {
      DialogUtils.alert(context, "Giá trị còn lại dài quá 25 ký tự");
      return;
    }

    // if (!validateRequired(nguyengiaCtrl.text)) {
    //   DialogUtils.alert(context, "Vui lòng nhập Nguyên giá");
    //   return;
    // }
    // if (!validateRequiredNumber(nguyengiaCtrl.text)) {
    //   DialogUtils.alert(context, "Nguyên giá không hợp lệ");
    //   return;
    // }

    // Validate giá trị còn lại <= nguyên giá
    if (!giatriconlaiCtrl.text.isEmpty) {
      String? giaTriConLaiError = validateGiaTriConLai(giatriconlaiCtrl.text);
      if (giaTriConLaiError != null) {
        DialogUtils.alert(context, giaTriConLaiError);
        return;
      }
    }

    // if (_selectedBophan.value == null) {
    //   DialogUtils.alert(context, "Vui lòng chọn Bộ phận sử dụng");
    //   return;
    // }
    if (_selectedNhomSD.value?.title == null ||
        _selectedNhomSD.value!.title!.isEmpty) {
      DialogUtils.alert(context, "Vui lòng chọn Nhóm tài sản");
      return;
    }

    if (_selectedTinhTrang.value == null ||
        _selectedTinhTrang.value?.key == null) {
      DialogUtils.alert(context, "Vui lòng chọn tình trạng sử dụng");
      return;
    } else {
      TSBS tsbs;
      bool isEditing = widget.editingTSBS != null;

      if (isEditing) {
        // Update existing TSBS
        tsbs = widget.editingTSBS!;
        // Remove old item from list
        // BBKKService.sharedInstance()
        //     .currentRecord!
        //     .ListTaiSanTamThoi
        //     ?.removeWhere((item) =>
        //         item.ten == tsbs.ten &&
        //         item.nguyengia == tsbs.nguyengia &&
        //         item.tinhtrangsudung == tsbs.tinhtrangsudung);
      } else {
        // Create new TSBS
        tsbs = new TSBS();
      }

      // Update/Set values
      tsbs.ten = tenCtrl.text;
      tsbs.nguyengia = double.parse(
        nguyengiaCtrl.text.replaceAll(".", "").isEmpty
            ? "0"
            : nguyengiaCtrl.text.replaceAll(".", ""),
      );
      tsbs.giaTriConLai = double.parse(
        giatriconlaiCtrl.text.replaceAll(".", "").isEmpty
            ? "0"
            : giatriconlaiCtrl.text.replaceAll(".", ""),
      );

      tsbs.tinhtrangsudung = _selectedTinhTrang.value?.key;
      tsbs.nhomtaisan = _selectedNhomSD.value;
      tsbs.bophansudung = _selectedbpsd.value;
      tsbs.maHinhThucXuLy = hinhthucxuly.value != null
          ? hinhthucxuly.value!.key.toString()
          : null;
      tsbs.maKetQuaXuLy =
          ketquaxuly.value != null ? ketquaxuly.value!.key.toString() : null;

      tsbs.trangThaiKK = 4;

      // Update the original taiSan's trangThaiKK to 4 if it exists
      // if (widget.taiSan != null) {
      //   widget.taiSan!.trangThaiKK = 4;
      // }

      // Add updated/new item to list
      if (BBKKService.sharedInstance().currentRecord!.ListTaiSanTamThoi ==
          null) {
        BBKKService.sharedInstance().currentRecord!.ListTaiSanTamThoi = [tsbs];
        // BBKKService.sharedInstance()
        //     .currentRecord!
        //     .ListTaiSanTamThoi!
        //     .add(tsbs);
      } else {
        if (!isEditing) {
          BBKKService.sharedInstance()
              .currentRecord!
              .ListTaiSanTamThoi!
              .add(tsbs);
        } else {
          BBKKService.sharedInstance()
              .currentRecord!
              .ListTaiSanTamThoi![widget.index!] = tsbs;
        }
      }
      // if (!isEditing) {
      //   BBKKService.sharedInstance()
      //       .currentRecord!
      //       .ListTaiSanTamThoi!
      //       .add(tsbs);
      // } else {
      //   BBKKService.sharedInstance()
      //       .currentRecord!
      //       .ListTaiSanTamThoi![widget.index!] = tsbs;
      // }

      // Navigate back with appropriate action
      Future.delayed(Duration(milliseconds: 150), () {
        Get.back(result: {
          'action': isEditing ? 'asset_updated' : 'asset_added',
          'taiSan': widget.taiSan,
          'tsbs': tsbs
        });
      });
    }
  }

  Row buildTinhTrangDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorUtils.gray.withOpacity(0.4),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<StringKeyValueModel>(
              popupProps: PopupProps.dialog(
                fit: FlexFit.loose,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item.value,
                  isSelected,
                  false,
                ),
              ),
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  hintText: "Chọn",
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

  // Future<List<KeyValueModel>> getTinhTrangData(filter) async {
  //   List<KeyValueModel> data = [];
  //   _tinhtrangDatas.forEach((key, value) {
  //     if (filter == null ||
  //         filter.isEmpty ||
  //         key.toLowerCase().contains(filter.toLowerCase())) {
  //       data.add(KeyValueModel(int.parse(value), key));
  //     }
  //   });
  //   return data;
  // }

  Future<List<BPSD>> getBPSDData(filter) async {
    return _bpsdDatas
        .where((element) => element.title.contains(filter))
        .toList();
  }

  Row buildNhomTSDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isValidNhomTS.value || !_validatedForm.value
                    ? ColorUtils.gray.withOpacity(0.4)
                    : Colors.red,
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<NhomTS?>(
              popupProps: PopupProps.modalBottomSheet(
                fit: FlexFit.loose,
                showSelectedItems: true,
                showSearchBox: true,
                onDismissed: () {
                  // Clear search box khi đóng dropdown
                  _nhomTSSearchboxCtrl.clear();
                },
                searchFieldProps: TextFieldProps(
                  padding: EdgeInsets.symmetric(
                    horizontal: Config.BASE_PADDING,
                    vertical: 10,
                  ),
                  controller: _nhomTSSearchboxCtrl,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _nhomTSSearchboxCtrl.clear();
                      },
                    ),
                  ),
                ),
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item?.title,
                  isSelected,
                  item?.unselectable ?? false,
                ),
                disabledItemFn: (item) {
                  return item?.unselectable ?? true;
                },
              ),
              compareFn: (i, s) => i?.key == s?.key,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  hintText: "Chọn",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              asyncItems: (String? filter) => getNhomTSData(filter),
              onChanged: (data) {
                _isValidNhomTS.value = true;
                _selectedNhomSD.value = (data);
              },
              filterFn: (item, filter) {
                if (filter.isEmpty) return true;
                return (item?.title ?? "")
                    .toLowerCase()
                    .contains(filter.toLowerCase());
              },
              selectedItem: _selectedNhomSD.value,
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

  Row buildDeXuatDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorUtils.gray.withOpacity(0.4),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<KeyValueModel>(
              popupProps: PopupProps.dialog(
                fit: FlexFit.loose,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item.value,
                  isSelected,
                  false,
                ),
              ),
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  hintText: "Chọn",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              asyncItems: (String? filter) => getDexuatData(filter),
              onChanged: (data) {
                hinhthucxuly.value = data;
              },
              selectedItem: hinhthucxuly.value,
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

  Row buildKetQuaDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              // color: ColorUtils.gray.withOpacity(0.2),
              border: Border.all(
                color: ColorUtils.gray.withOpacity(0.4),
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<KeyValueModel>(
              enabled: true,
              popupProps: PopupProps.dialog(
                fit: FlexFit.loose,
                showSelectedItems: true,
                itemBuilder: (context, item, isSelected) =>
                    CommonWidget.customDropdownPopupItem(
                  context,
                  item.value,
                  isSelected,
                  false,
                ),
              ),
              compareFn: (i, s) => i == s,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  // fillColor: ColorUtils.gray.withOpacity(0.2),
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  hintText: "Chọn",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              asyncItems: (String? filter) => getDexuatData(filter),
              onChanged: (data) {
                ketquaxuly.value = data;
              },
              selectedItem: ketquaxuly.value,
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

  Future<List<KeyValueModel>> getDexuatData(filter) async {
    List<KeyValueModel> data = [];
    data.add(new KeyValueModel(0, "Điều chuyển"));
    data.add(new KeyValueModel(1, "Do điều chỉnh sau kiểm kê"));
    data.add(new KeyValueModel(2, "Thu hồi"));
    data.add(new KeyValueModel(3, "Giảm khác"));
    data.add(new KeyValueModel(4, "Thanh lý"));
    data.add(new KeyValueModel(5, "Bán chuyển nhượng"));

    return data;

    // return [];
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
    // Same data as hinhthucxuly since they use the same getDexuatData function
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
