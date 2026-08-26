import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/bbkk.dart';
import 'package:qltstc_kiemke/modules/bbkk/suabbkk/thongtinkiemkeedit.dart';
import 'package:qltstc_kiemke/modules/bbkk/taomoibbkk/thongtinkiemkecreate.dart';
import 'package:qltstc_kiemke/modules/bbkk/xembbkk/thongtinchungbbkk.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/modules/mains/main_page.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/dialog_utils.dart';
import 'package:qltstc_kiemke/utils/loading_widget.dart';

class ListBBKK extends StatefulWidget {
  @override
  _ListBBKKState createState() => _ListBBKKState();
}

class _ListBBKKState extends State<ListBBKK> {
  RxList<BBKK> showingList = RxList<BBKK>();
  List<BBKK> list = [];
  RxString textSearch = "".obs;
  RxList<ExpandableController> listCtrl = RxList<ExpandableController>();
  var _showLoading = false.obs;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    _showLoading.value = true;
    BBKKService.sharedInstance().getBBKKs().then((value) {
      _showLoading.value = false;
      if (value == null)
        DialogUtils.alert(context, "Lỗi kết nối");
      else {
        list.clear();
        list.addAll(value);
        list.sort((a, b) {
          var df = DateFormat("dd/MM/yyyy");
          return df
              .parse(b.NgayKiemKe!)
              .difference(df.parse(a.NgayKiemKe!))
              .inDays;
        });
        list.forEach((element) {
          expandList[element.Id ?? ""] = false;
        });
        onSearch(textSearch.value);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData();
  }

  onSearch(String text) {
    textSearch.value = text;
    if (text.isNotEmpty)
      showingList.value = list
          .where(
            (element) =>
                (element.TenDotKiemKe ?? "").toUpperCase().contains(
                      text.toUpperCase(),
                    ) ||
                (element.SoBienBan ?? "").toUpperCase().contains(
                      text.toUpperCase(),
                    ) ||
                (element.BoPhanSuDung ?? "").toUpperCase().contains(
                      text.toUpperCase(),
                    ),
          )
          .toList();
    else
      showingList.value = list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountHeader(subTitle: "Danh sách biên bản kiểm kê"),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: Config.BASE_PADDING,
                  right: Config.BASE_PADDING,
                  top: 10),
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
                  BBKKService.sharedInstance().currentRecord = new BBKK();
                  // Get.to(CreateBBKKPage())!.then((value) {
                  //   initData();
                  // });
                  Get.to(ThongTinKiemKeCreatePage(),
                          transition: Transition.cupertino)!
                      .then((value) {
                    initData();
                  });
                },
                child: Text(
                  "Tạo mới biên bản kiểm kê",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Config.BASE_PADDING,
                vertical: 10,
              ),
              child: Divider(color: ColorUtils.gray),
            ),
            Expanded(
              child: Obx(
                () => Stack(
                  children: [
                    buildListItem(context),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: MaterialButton(
                            minWidth: 80,
                            onPressed: () => Get.off(() => MainPage()),
                            child: Text(
                              "Đóng",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.white),
                            ),
                            color: ColorUtils.mainColor,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    LoadingWidget(_showLoading.value),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RxMap<String, bool> expandList = RxMap<String, bool>();

  buildListItem(context) {
    List<Widget> items = [];
    showingList.forEach((bbkk) {
      var canEditBBKK = checkCanEditBBKK(bbkk);

      // Determine status color
      Color statusColor;
      if (bbkk.LaLuuNhap == 1) {
        statusColor = Colors.orange;
      } else if (bbkk.TrangThai == 2) {
        statusColor = Colors.blue;
      } else {
        statusColor = Colors.grey;
      }

      var item = Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () => goToDetailBBKK(bbkk),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        bbkk.TenDotKiemKe ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    if (canEditBBKK)
                      InkWell(
                        onTap: () => goToUpdateBBKK(bbkk),
                        child: Icon(
                          IconsaxPlusLinear.edit_2,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    if (canEditBBKK) SizedBox(width: 12),
                    if (canEditBBKK)
                      InkWell(
                        onTap: () => deleteBBKK(bbkk),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ngày kiểm kê:",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      bbkk.NgayKiemKe ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hình thức kiểm kê:",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      bbkk.HinhThucKiemKe ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trạng thái:",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      bbkk.LaLuuNhap == 1
                          ? "Lưu nháp"
                          : bbkk.TrangThai == 1
                              ? "Chờ duyệt"
                              : bbkk.TrangThai == 2
                                  ? "Đã duyệt - Chờ xử lý"
                                  : bbkk.TrangThai == 3
                                      ? "Đã xử lý xong"
                                      : "Đã lưu",
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      items.add(item);
    });
    items.add(SizedBox(height: 90));
    return SingleChildScrollView(child: Column(children: items));
  }

  changeExpandedIndex(String id) {
    expandList.forEach((key, element) {
      if (id != key) expandList[key] = false;
    });
    expandList[id] = !(expandList[id] ?? false);
  }

  void goToUpdateBBKK(BBKK bbkk) {
    _showLoading.value = true;
    BBKKService.sharedInstance().getBBKKbyId(bbkk.Id ?? "").then((value) {
      _showLoading.value = false;
      if (value == null)
        DialogUtils.alert(context, "Không tìm thấy biên bản kiểm kê này");
      else {
        BBKKService.sharedInstance().currentRecord = value;
        Get.to(ThongTinKiemKeEditPage(), transition: Transition.cupertino)!
            .then((value) {
          initData();
        });
      }
    });
  }

  void deleteBBKK(BBKK bbkk) {
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
                          _showLoading.value = true;
                          BBKKService.sharedInstance()
                              .deleteBBKK(bbkk.Id ?? "")
                              .then((value) {
                            _showLoading.value = false;
                            if (!value)
                              DialogUtils.alert(context,
                                  "Không tìm thấy biên bản kiểm kê này");
                            else {
                              initData();
                            }
                          });
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

  checkCanEditBBKK(BBKK bbkk) {
    var date = DateFormat("dd/MM/yyyy").parse(bbkk.NgayKiemKe!);
    if (UserService.sharedInstance().currentUser?.namKhoaSo != null &&
        date.year <=
            int.parse(UserService.sharedInstance().currentUser!.namKhoaSo!)) {
      return false;
    }
    // if (bbkk.LaLuuNhap == null) return false;
    return true;
  }

  void goToDetailBBKK(BBKK bbkk) {
    _showLoading.value = true;
    BBKKService.sharedInstance().getBBKKbyId(bbkk.Id ?? "").then((value) {
      _showLoading.value = false;
      if (value == null)
        DialogUtils.alert(context, "Không tìm thấy biên bản kiểm kê này");
      else {
        BBKKService.sharedInstance().currentRecord = value;
        // Get.to(ViewBBKK(), transition: Transition.cupertino);
        Get.to(ThongTinChungBBKK(), transition: Transition.cupertino);
      }
    });
  }
}
