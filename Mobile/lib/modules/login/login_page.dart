import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qltstc_kiemke/modules/common_widgets/text_field.dart';
import 'package:qltstc_kiemke/modules/mains/main_page.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/dialog_utils.dart';
import 'package:qltstc_kiemke/utils/loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameCtrl = new TextEditingController();
  var passwordCtrl = new TextEditingController();
  var _showLoading = false.obs;

  bool _validateInputs() {
    if (usernameCtrl.text.trim().isEmpty && passwordCtrl.text.trim().isEmpty) {
      DialogUtils.alert(context, "Vui lòng nhập đầy đủ thông tin");
      return false;
    }
    if (usernameCtrl.text.trim().isEmpty) {
      DialogUtils.alert(context, "Vui lòng nhập tên đăng nhập");
      return false;
    }
    if (passwordCtrl.text.trim().isEmpty) {
      DialogUtils.alert(context, "Vui lòng nhập mật khẩu");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // SharedPreferencesUtils.setToken(
    //     "GZsiMRQesGhnZml8OLXtS20SdMLxI9N5FodaCEAOyi8GMjAvl5XpRXItEURXhSLRGE2Je1Si0-qeMGVdVDF_pwYVedKwqU3fTy0dRWS-tC0BDhuhgy9uDA-h3HdPaKF7fejE0tIcFWvryo_nXTItJnz70iZM1HvvVWxwMwBMptkOk_7mzwQ8clqXnRh8L2xiQaYta_thSQEbUKNP0ibaY54q2dl5GpE8K9SyovswJtvNfVlTXOptuDKs56EM0gF7722zt6oahvRZJnLM0pDqDeH_jB7WKLZDMDR1zTUmyALkdE6--rbYe8B31zozJv_BcJ9D5-g2aM6DN2JpX4Lu4bUWd9-t50Y0aAvAinBtyWNKTzVcbZNQh4KheYkxBEXq_fw3TS2BJANs1F_n5ONIzlaFdoMJcqWdr2nMnUMiZeOm1LtPifg9d-IlURsqohemh7932GtjvgMhf4Ky6YtgF9-JXX4bHQ0Jbm6kPf9iJTuyzdLA_emNhAwk3glsCxhkqDrFTjCdDvJhXsht7w4E5yZbVGck6LC9Yet6oCZULrl3vn25KG3Ntr3bAHMataqPpDxA79zdCnslv_n1j_VsI267rMVUi7INyHvS4qq2VjcuQ8LkME4YfhQlI5rg5vbQYm7c_C_93-MOWw3ou1RWlnlUw_Uc0jEyKRQ7OZLxcmUwboA2rxHfJZ3GxSOuImjnw1iQniKGs9fm390JT0wiWioFPQZncCyV-pJUWrGlDkUOba4BmmqkY5BCwdE3ym_j80Cqd6Moah9UhnsGU0ti4TYGcLYO-PVDkZk3i5BKfZGKQ4ulLaUjfREVITNYPeGe1RdVWXh42NqnMa6NFwq_ow-rRewU4vIaVAx4Au053NDL5B5Bl9tmzROCYBZbsjDeAHcp0BUGv_ms-hudv4-KJ2KQeSFWpeDaBX-Jh-zpWlVz9RL_L37MZta7GQ6UufURtt_KXuYM54dbb-5YvFTOsiLrfwE1pAAOfR9ZzPxcjvu3VlckDbvuBmij8sX_-p-nQKvuTbLa-_TrCG8PoPwIXFfcl3cCCF8aZxMhmWCzR6psjDxc-Kvdtkm3ozheAQh-yOohZ7FdK9JDKyrrw3WB7qM_m0sC_bNDkq7X-DzbiO89g21a3kJBLnNNyNJFVN2boe5jx-WRmzuXUeNBNP39EOkcnWRoChSCTy8GLSAKgORX8r1xQtyAuyB9J4sWFSPUZI4Zs2Melt-5Uc-aehv-1DITq_aNsyxyyt3wKVpPaCsEio9Fbr-YIEkIOObPE5F4fmzdxZNXAhs783x_HPozKoEw8tk8ALvpJ88n-Ei7L4VgVCibojaD9rg-QNTmBEvbKcHlzQ");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          // Thêm GestureDetector
          onTap: () {
            FocusScope.of(context).unfocus(); // Ẩn bàn phím
          },
          child: Stack(
            children: [
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: Image.asset(
              //     "assets/res/images/login_icon_bottom.png",
              //     fit: BoxFit.fitWidth,
              //     alignment: Alignment.bottomCenter,
              //   ),
              // ),
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // AppHeader(title: "Test"),
                      // SizedBox(height: 30),
                      Image.asset(
                        "assets/res/images/login_icon_top.png",
                        height: Get.width * 0.8,
                        // width: Get.width,
                      ),
                      // SizedBox(height: 10),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: ColorUtils.gray.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            // Text(
                            //   "Tài khoản đăng nhập",
                            //   textAlign: TextAlign.left,
                            //   style: Theme.of(context).textTheme.headline3,
                            // ),
                            Text(
                              "Đăng nhập tài khoản",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: ColorUtils.mainColor,
                                    fontSize: 24,
                                  ),
                            ),
                            Text(
                              "Ứng dụng hệ thống kiểm kê tài sản mobile",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: ColorUtils.gray,
                                  ),
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                              controller: usernameCtrl,
                              hint: "Tên đăng nhập",
                              // icon: Icons.person,
                            ),
                            CustomTextField(
                              // icon: Icons.lock,
                              controller: passwordCtrl,
                              obscureText: true,
                              hint: "Mật khẩu",
                            ),
                            SizedBox(height: 10),
                            MaterialButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (!_validateInputs()) {
                                  return;
                                }
                                _showLoading.value = true;
                                String trimmedUsername =
                                    usernameCtrl.text.trim();
                                String trimmedPassword =
                                    passwordCtrl.text.trim();
                                UserService.sharedInstance()
                                    .login(trimmedUsername, trimmedPassword)
                                    .then((user) {
                                  if (user.userName != null) {
                                    Get.off(
                                      () => MainPage(),
                                      transition: Transition.cupertino,
                                    );
                                    _showLoading.value = false;
                                  } else {
                                    DialogUtils.alert(context, user.message!);
                                    _showLoading.value = false;
                                  }
                                });
                              },
                              child: Text(
                                "Đăng nhập".toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: Colors.white),
                              ),
                              color: ColorUtils.mainColor,
                              minWidth: double.infinity,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                "assets/res/images/login_icon_bottom.png",
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Hotline: 0242.220.2828/2888",
                                  style: TextStyle(
                                    color: ColorUtils.mainColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => LoadingWidget(_showLoading.value)),
            ],
          ),
        ),
      ),
    );
  }
}
