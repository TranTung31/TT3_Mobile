import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/bbkk.dart';
import 'package:qltstc_kiemke/models/bpsd.dart';
import 'package:qltstc_kiemke/modules/bbkk/list_bbkk.dart';
import 'package:qltstc_kiemke/modules/bbkk/suabbkk/hoidongkiemkeedit.dart';
import 'package:qltstc_kiemke/modules/common_widgets/text_field.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/common_widget.dart';
import 'package:qltstc_kiemke/utils/dialog_utils.dart';
import 'package:qltstc_kiemke/utils/loading_widget.dart';

class ThongTinKiemKeEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ThongTinKiemKeEditPage();
  }
}

class _ThongTinKiemKeEditPage extends State<ThongTinKiemKeEditPage> {
  final dvCtrl = new TextEditingController();
  final tenCtrl = new TextEditingController();
  final sobbCtrl = new TextEditingController();
  final ngaylapCtrl = new TextEditingController();
  final ngaykkCtrl = new TextEditingController();
  final theokhkkCtrl = new TextEditingController();

  var _selectedhtkk = Rxn<String>();
  List<String> _htkkDatas = [
    'Kiểm kê thường niên',
    'Kiểm kê đột xuất',
    'Kiểm kê khác',
    'Kiểm kê tài sản dự án',
  ];

  RxList<String> loadingQueue = <String>[].obs;
  final String _loadingBPSD = "_loadingBPSD";
  late List<BPSD> bpsdDatas;
  Rxn<BPSD> _selectedbpsd = Rxn<BPSD>();
  RxList<BPSD> _bpsdDatas = <BPSD>[].obs;
  int? isBBKKNhap = null;
  @override
  void initState() {
    super.initState();
  }

  onChangeBPSD(selectedTest) {
    print(selectedTest);
    _selectedbpsd.value = selectedTest;
  }

  onChangeHTKK(selectedTest) {
    _selectedhtkk.value = selectedTest;
    _isValidHinhThuc.value = true;

    if (selectedTest == 'Kiểm kê thường niên') {
      var currentYear = DateTime.now().year;
      ngaykkCtrl.text = '31/12/$currentYear';
    }
  }

  Future<void> getBPSD(context) async {
    loadingQueue.add(_loadingBPSD);
    UserService.sharedInstance().getBPSD().then((value) {
      loadingQueue.remove(_loadingBPSD);
      if (value.length > 0) {
        _bpsdDatas.addAll(value);
        initOldData();
      } else {
        DialogUtils.alert(context, "Không tìm thấy bộ phận sử dụng");
        initOldData();
      }
    });
  }

  RxBool _isValidHinhThuc = false.obs;
  RxBool _validatedForm = false.obs;

  @override
  Widget build(BuildContext context) {
    dvCtrl.text = UserService.sharedInstance().currentUser!.tenDonVi!;
    return FutureBuilder(
      future: getBPSD(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {}
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
                                  color: Colors.black,
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
                            IconsaxPlusLinear.task_square,
                            size: 20,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Thông tin kiểm kê",
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
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text("Đơn vị sử dụng "),
                                    Text(
                                      "*",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                CustomTextField(
                                  isReadOnly: true,
                                  controller: dvCtrl,
                                  hint: "Nhập thông tin",
                                  validator: _validatedForm.value
                                      ? validateRequired
                                      : null,
                                  borderColor: ColorUtils.gray.withOpacity(0.4),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text("Theo kế hoạch kiểm kê"),
                                  ],
                                ),
                                CustomTextField(
                                  controller: theokhkkCtrl,
                                  hint: "Nhập thông tin",
                                  borderColor: ColorUtils.gray.withOpacity(0.4),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text("Tên đợt kiểm kê "),
                                    Text(
                                      "*",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                CustomTextField(
                                  controller: tenCtrl,
                                  hint: "Nhập thông tin",
                                  validator: _validatedForm.value
                                      ? validateRequired
                                      : null,
                                  borderColor: ColorUtils.gray.withOpacity(0.4),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text("Số biên bản "),
                                    Text(
                                      "*",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                CustomTextField(
                                  controller: sobbCtrl,
                                  hint: "Nhập thông tin",
                                  validator: _validatedForm.value
                                      ? validateRequired
                                      : null,
                                  borderColor: ColorUtils.gray.withOpacity(0.4),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text("Hình thức kiểm kê "),
                                    Text(
                                      "*",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(child: buildHTKKDropdown(context)),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Ngày lập "),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          CustomTextField(
                                            controller: ngaylapCtrl,
                                            isDateField: true,
                                            validator: _validatedForm.value
                                                ? validateRequired
                                                : null,
                                            hint: "../../....",
                                            borderColor: ColorUtils.gray
                                                .withOpacity(0.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Ngày kiểm kê "),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          CustomTextField(
                                            validator: _validatedForm.value
                                                ? validateRequired
                                                : null,
                                            controller: ngaykkCtrl,
                                            isReadOnly: false,
                                            isDateField: true,
                                            hint: "../../....",
                                            borderColor: ColorUtils.gray
                                                .withOpacity(0.4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text("Bộ phận sử dụng "),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(
                                        () => _bpsdDatas.length > 0
                                            ? buildBPSDDropdown(context)
                                            : SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Get.back(),
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          side: BorderSide(
                                              color: ColorUtils.gray),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                          onPressed: () => confirmModal(),
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            side: BorderSide(
                                                color: ColorUtils.mainColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                        onPressed: () => onContinue(context),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          backgroundColor: ColorUtils.mainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() => LoadingWidget(loadingQueue.length > 0)),
              ],
            ),
          ),
        );
      },
    );
  }

  Row buildHTKKDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _isValidHinhThuc.value || !_validatedForm.value
                    ? ColorUtils.gray.withOpacity(0.4)
                    : Colors.red,
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: DropdownSearch<String>(
              popupProps: PopupProps.dialog(
                fit: FlexFit.loose,
                showSelectedItems: true,
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
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  border: InputBorder.none,
                  hintText: "Chọn",
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              asyncItems: (String? filter) => getHTKKData(filter),
              onChanged: (data) {
                _isValidHinhThuc.value = true;
                _selectedhtkk.value = (data);
                onChangeHTKK(data);
              },
              filterFn: (item, filter) => true,
              selectedItem: _selectedhtkk.value,
              dropdownBuilder: (context, item) =>
                  CommonWidget.customDropDownSelectedItem(
                context,
                item,
                hint: "--Chọn hình thức--",
              ),
            ),
          ),
        ),
      ],
    );
  }

  var _BPSDTSSearchboxCtrl = TextEditingController();

  Row buildBPSDDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
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
                hint: "--Chọn bộ phận--",
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

  validateMin(String text) {
    if (text.isEmpty) return false;
    try {
      var date = DateTime.parse(text);
      if (UserService.sharedInstance().currentUser?.namKhoaSo != null &&
          date.year <=
              int.parse(UserService.sharedInstance().currentUser!.namKhoaSo!))
        return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  clearAlerts() {
    _validatedForm.value = false;
    _isValidHinhThuc.value = false;
  }

  bool _validateForm(context) {
    _validatedForm.value = true;
    _isValidHinhThuc.value = _selectedhtkk.value?.isNotEmpty ?? false;

    if (!validateRequired(tenCtrl.text)) {
      if (tenCtrl.text.length > 255) {
        DialogUtils.alert(context, "Tên biên bản dài quá 255 ký tự");
        return false;
      }
      DialogUtils.alert(context, "Vui lòng nhập Tên đợt kiểm kê");
      return false;
    }
    if (tenCtrl.text.trim().isEmpty) {
      DialogUtils.alert(
          context, "Tên đợt kiểm kê không được chỉ chứa khoảng trắng");
      return false;
    }

    if (!validateRequired(sobbCtrl.text)) {
      if (sobbCtrl.text.length > 255) {
        DialogUtils.alert(context, "Số biên bản dài quá 255 ký tự");
        return false;
      }
      DialogUtils.alert(context, "Vui lòng nhập Số biên bản");
      return false;
    }
    if (sobbCtrl.text.trim().isEmpty) {
      DialogUtils.alert(
          context, "Số biên bản không được chỉ chứa khoảng trắng");
      return false;
    }
    if (_selectedhtkk.value == null || _selectedhtkk.value!.isEmpty) {
      DialogUtils.alert(context, "Vui lòng chọn Hình thức kiểm kê");
      return false;
    }
    if (ngaylapCtrl.text.isEmpty) {
      DialogUtils.alert(context, "Vui lòng nhập Ngày lập");
      return false;
    }
    if (ngaykkCtrl.text.isEmpty) {
      DialogUtils.alert(context, "Vui lòng nhập Ngày kiểm kê");
      return false;
    }

    var namKhoaSo = UserService.sharedInstance().currentUser!.namKhoaSo!;
    try {
      var ngayLap = DateFormat("dd/MM/yyyy").parse(ngaylapCtrl.text);
      var ngayKiemKe = DateFormat("dd/MM/yyyy").parse(ngaykkCtrl.text);
      var today = DateTime.now();

      if (ngayLap.isAfter(today)) {
        DialogUtils.alert(
            context, "Ngày lập không được là ngày trong tương lai");
        return false;
      }

      if (UserService.sharedInstance().currentUser?.namKhoaSo != null &&
          ngayLap.year <= int.parse(namKhoaSo)) {
        DialogUtils.alert(context,
            "Không thể thêm mới biên bản kiểm kê thuộc năm đã khóa sổ");
        return false;
      }

      if (ngayLap.isAfter(ngayKiemKe)) {
        DialogUtils.alert(
            context, "Ngày lập phải nhỏ hơn hoặc bằng ngày kiểm kê");
        return false;
      }
    } catch (e) {
      DialogUtils.alert(context, "Định dạng ngày không hợp lệ");
      return false;
    }

    return true;
  }

  void onSaveDraft(context) async {
    if (!_validateForm(context)) return;

    var donViId = UserService.sharedInstance().currentUser?.donviId ?? "";
    var recordId = BBKKService.sharedInstance().currentRecord?.Id ?? "";
    var exists = await BBKKService.sharedInstance().checkSoBienBanExists(
      sobbCtrl.text.trim(),
      recordId,
      donViId,
    );

    if (exists) {
      DialogUtils.alert(context, "Số biên bản đã tồn tại");
      loadingQueue.remove("checkSoBienBanExists");

      return;
    }
    loadingQueue.remove("checkSoBienBanExists");

    BBKK bbkk = BBKKService.sharedInstance().currentRecord ?? new BBKK();
    bbkk.TenDotKiemKe = tenCtrl.text.trim();
    bbkk.SoBienBan = sobbCtrl.text.trim();
    bbkk.DonViId = UserService.sharedInstance().currentUser?.donviId;
    bbkk.NgayKiemKe = ngaykkCtrl.text;
    bbkk.NgayLap = ngaylapCtrl.text;
    bbkk.HinhThucKiemKe = _selectedhtkk.value;
    bbkk.BoPhanKiemKeId = _selectedbpsd.value?.key;
    bbkk.BoPhanSuDung = _selectedbpsd.value?.title;
    BBKKService.sharedInstance().currentRecord = bbkk;

    var result = await BBKKService.sharedInstance().updateBBKK(isNhap: false);
    if (result) {
      DialogUtils.alert(context, "Lưu nháp thành công");
      Get.off(() => ListBBKK());
    } else {
      DialogUtils.alert(context, "Lưu lỗi");
    }
  }

  void onContinue(context) async {
    if (!_validateForm(context)) return;
    loadingQueue.add("checkSoBienBanExists");

    var donViId = UserService.sharedInstance().currentUser?.donviId ?? "";
    var recordId = BBKKService.sharedInstance().currentRecord?.Id ?? "";

    var exists = await BBKKService.sharedInstance().checkSoBienBanExists(
      sobbCtrl.text.trim(),
      recordId,
      donViId,
    );

    if (exists) {
      DialogUtils.alert(context, "Số biên bản đã tồn tại");
      loadingQueue.remove("checkSoBienBanExists");
      return;
    }
    loadingQueue.remove("checkSoBienBanExists");

    BBKK bbkk = BBKKService.sharedInstance().currentRecord ?? new BBKK();
    bbkk.TenDotKiemKe = tenCtrl.text.trim();
    bbkk.SoBienBan = sobbCtrl.text.trim();
    bbkk.DonViId = UserService.sharedInstance().currentUser?.donviId;
    bbkk.NgayKiemKe = ngaykkCtrl.text;
    bbkk.NgayLap = ngaylapCtrl.text;
    bbkk.HinhThucKiemKe = _selectedhtkk.value;
    bbkk.BoPhanKiemKeId = _selectedbpsd.value?.key;
    bbkk.BoPhanSuDung = _selectedbpsd.value?.title;
    BBKKService.sharedInstance().currentRecord = bbkk;

    Get.to(() => HoiDongKiemKeEditPage());
  }

  initOldData() {
    loadingQueue.clear();
    var currentRecord = BBKKService.sharedInstance().currentRecord;
    if (currentRecord == null) return;
    loadingQueue.add("initData");
    Future.delayed(Duration(milliseconds: 300), () {
      isBBKKNhap = currentRecord.LaLuuNhap;
      tenCtrl.text = currentRecord.TenDotKiemKe ?? "";
      sobbCtrl.text = currentRecord.SoBienBan ?? "";
      ngaylapCtrl.text = currentRecord.NgayLap ??
          DateFormat('dd/MM/yyyy').format(DateTime.now());
      ngaykkCtrl.text = currentRecord.NgayKiemKe ?? "";
      _selectedhtkk.value = currentRecord.HinhThucKiemKe ?? "";
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

  Future<List<String>> getHTKKData(filter) async {
    return _htkkDatas.where((element) => element.contains(filter)).toList();
  }

  Future<List<BPSD>> getBPSDData(filter) async {
    return _bpsdDatas
        .where((element) => element.title.contains(filter))
        .toList();
  }

  void confirmModal() {
    final pageContext = context; // Store page context
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
                          loadingQueue.add("checkSoBienBanExists");
                          Navigator.of(dialogContext).pop();
                          onSaveDraft(pageContext);
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
