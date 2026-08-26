import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
// import 'package:qltstc_kiemke/modules/bbkk/xembbkk/thongtinchungbbkk.dart';
import 'package:qltstc_kiemke/modules/login/login_page.dart';
import 'package:qltstc_kiemke/modules/mains/main_page.dart';
import 'package:qltstc_kiemke/services/user_service.dart';

class AccountHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? subTitle;
  final String? pageName;

  const AccountHeader({Key? key, this.subTitle, this.pageName})
      : super(key: key);

  @override
  Size get preferredSize {
    double height = 68; // Base AppBar height
    if (subTitle != null) height += 42;
    if (pageName != null) height += 45;
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    var user = UserService.sharedInstance().currentUser!;
    return Container(
        child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/res/images/header.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: AppBar(
              toolbarHeight: 68,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              scrolledUnderElevation: 0,
              elevation: 0,
              leadingWidth: 48,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image.asset(
                  'assets/res/images/quochuy.png',
                  fit: BoxFit.contain,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.tenDonVi!,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  if (subTitle != null)
                    Text(
                      "Mã đơn vị " + user.maDonVi!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                    )
                  else
                    Text(
                      "Chào đồng chí " + user.userName!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                    ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  icon: Icon(
                    IconsaxPlusLinear.login,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          if (subTitle != null)
            AppBar(
              toolbarHeight: 42,
              title: Text(
                subTitle!,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              scrolledUnderElevation: 0,
              elevation: 0,
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (pageName != null) {
                    Get.back();
                  } else {
                    Get.offAll(() => MainPage());
                  }
                },
              ),
            ),
          // if (pageName != null)
          // Container(
          //   height: 45,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(4),
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: MaterialButton(
          //           height: 45,
          //           elevation: 0,
          //           splashColor: Colors.transparent,
          //           highlightColor: Colors.transparent,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(4),
          //           ),
          //           onPressed: () => {
          //             if (pageName != "ThongTin")
          //               {Get.to(() => ThongTinChungBBKK())}
          //             else
          //               {null}
          //           },
          //           child: Text(
          //             "Thông tin",
          //             style: TextStyle(
          //               color: pageName == "ThongTin"
          //                   ? Colors.black
          //                   : Colors.blue,
          //               fontSize: 13,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //           // color: Colors.white,
          //         ),
          //       ),
          //       Container(
          //         width: 1,
          //         height: 45,
          //         color: Colors.grey[300],
          //       ),
          //       Expanded(
          //         child: MaterialButton(
          //           height: 45,
          //           elevation: 0,
          //           splashColor: Colors.transparent,
          //           highlightColor: Colors.transparent,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(4),
          //           ),
          //           onPressed: () => {
          //             if (pageName != "HoiDong")
          //               {Get.to(() => ThongTinChungBBKK())}
          //             else
          //               {null}
          //           },
          //           child: Text(
          //             "Hội đồng",
          //             style: TextStyle(
          //               color: pageName == "HoiDong"
          //                   ? Colors.black
          //                   : Colors.blue,
          //               fontSize: 13,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //           // color: Colors.white,
          //         ),
          //       ),
          //       Container(
          //         width: 1,
          //         height: 45,
          //         color: Colors.grey[300],
          //       ),
          //       Expanded(
          //         child: MaterialButton(
          //           height: 45,
          //           elevation: 0,
          //           splashColor: Colors.transparent,
          //           highlightColor: Colors.transparent,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(4),
          //           ),
          //           onPressed: () => {
          //             if (pageName != "QRKiemKe")
          //               {Get.to(() => ThongTinChungBBKK())}
          //             else
          //               {null}
          //           },
          //           child: Text(
          //             "QR kiểm kê",
          //             style: TextStyle(
          //               color: pageName == "QRKiemKe"
          //                   ? Colors.black
          //                   : Colors.blue,
          //               fontSize: 13,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //           // color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    ));
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
                      'Đăng xuất tài khoản',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
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
                      //   Icons.phone_iphone_rounded,
                      //   size: 60,
                      //   color: Colors.blue,
                      // ),
                      // Positioned(
                      //   right: 15,
                      //   top: 15,
                      //   child: Container(
                      //     width: 32,
                      //     height: 32,
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: Icon(
                      //       Icons.priority_high,
                      //       color: Colors.white,
                      //       size: 20,
                      //     ),
                      //   ),
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
                      //       color: Colors.white,
                      //       size: 16,
                      //     ),
                      //   ),
                      // ),
                      Image.asset(
                        "assets/res/images/dang_xuat_modal_icon.png",
                        height: Get.width * 0.8,
                        // width: Get.width,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Xác nhận đăng xuất',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Bạn chắc chắn muốn đăng xuất tài khoản khỏi hệ thống?',
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.off(
                            () => LoginPage(),
                            transition: Transition.cupertino,
                          );
                          UserService.sharedInstance().logout();
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
                          'Xác nhận',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
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
                          'Hủy',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
