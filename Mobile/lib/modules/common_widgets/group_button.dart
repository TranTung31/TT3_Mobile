import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qltstc_kiemke/models/loai_bien_dongs.dart';
import 'package:qltstc_kiemke/modules/bbkk/thongtintaisan/thongtinbiendongtaisan.dart';
import 'package:qltstc_kiemke/modules/bbkk/thongtintaisan/thongtingiatritaisan.dart';
import 'package:qltstc_kiemke/modules/bbkk/thongtintaisan/thongtinsudungtaisan.dart';
import 'package:qltstc_kiemke/modules/bbkk/thongtintaisan/thongtintaisanquetma.dart';
import 'package:qltstc_kiemke/modules/mains/main_page.dart';

class GroupButton extends StatefulWidget {
  final LoaiBienDongs? taiSan;
  final String? tenDonVi;
  final String? pageName;
  const GroupButton({Key? key, this.taiSan, this.tenDonVi, this.pageName})
      : super(key: key);

  @override
  _GroupButtonState createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                      if (widget.pageName != "ThongTinTaiSanQuetMa")
                        {
                          Get.to(
                              () => ThongTinTaiSanQuetMa(
                                    taiSan: widget.taiSan,
                                    tenDonVi: widget.tenDonVi,
                                  ),
                              transition: Transition.cupertino)
                        }
                      else
                        {null}
                    },
                    child: Text(
                      "Thông tin tài sản",
                      style: TextStyle(
                        color: widget.pageName == "ThongTinTaiSanQuetMa"
                            ? Colors.black
                            : Colors.blue,
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
                      if (widget.pageName != "ThongTinSuDungTaiSan")
                        {
                          Get.to(() => ThongTinSuDungTaiSan(
                              taiSan: widget.taiSan, tenDonVi: widget.tenDonVi))
                        }
                      else
                        {null}
                    },
                    child: Text(
                      "Thông tin sử dụng",
                      style: TextStyle(
                        color: widget.pageName == "ThongTinSuDungTaiSan"
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
                      if (widget.pageName != "ThongTinGiaTriTaiSan")
                        {
                          Get.to(() => ThongTinGiaTriTaiSan(
                              taiSan: widget.taiSan, tenDonVi: widget.tenDonVi))
                        }
                      else
                        {null}
                    },
                    child: Text(
                      "Thông tin giá trị",
                      style: TextStyle(
                        color: widget.pageName == "ThongTinGiaTriTaiSan"
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
                      if (widget.pageName != "ThongTinBienDongTaiSan")
                        {
                          Get.to(() => ThongTinBienDongTaiSan(
                              taiSanGoc: widget.taiSan,
                              taiSan: widget.taiSan?.loaiBienDongs,
                              tenDonVi: widget.tenDonVi))
                        }
                      else
                        {null}
                    },
                    child: Text(
                      "Biến động tài sản",
                      style: TextStyle(
                        color: widget.pageName == "ThongTinBienDongTaiSan"
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
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: MaterialButton(
            height: 45,
            minWidth: double.infinity,
            splashColor: Colors.grey,
            highlightColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onPressed: () => Get.offAll(
              () => MainPage(),
              transition: Transition.cupertino,
            ),
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
    );
  }
}

//class GroupButton extends StatelessWidget {
//  final String hintText;
//  final TextEditingController controller;
//  final Function onChangeAction;
//  final double width;
//
//  GroupButton(
//      {this.hintText, this.controller, this.onChangeAction, this.width});
//
//  _getCancelIcon() {
//    if (this.controller.text.trim() == "") {
//      return Expanded(
//        child: Container(),
//        flex: 1,
//      );
//    }
//    return Expanded(
//      child: InkWell(
//          onTap: () {
//            onChangeAction("");
//            controller.text="";
//
//          },
//          child: new Container(
//              child: Padding(
//            padding: EdgeInsets.only(left: 2, right: 2),
//            child: Icon(
//              Icons.cancel,
//              size: 16.0,
//            ),
//          ))),
//      flex: 1,
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      width: width != null ? width : MediaQuery.of(context).size.width,
//      decoration: BoxDecoration(
//        border: Border.all(color: Color.fromRGBO(240, 238, 238, 1)),
//        borderRadius: BorderRadius.circular(4.0),
//        color: Color.fromRGBO(240, 238, 238, 1),
//      ),
//      child: Row(
//        children: <Widget>[
//          Expanded(
//            child: new Container(
//                child: Padding(
//              padding: EdgeInsets.only(left: 2, right: 2),
//              child: Icon(
//                Icons.search,
//                size: 16.0,
//              ),
//            )),
//            flex: 1,
//          ),
//          Expanded(
//            child: TextField(
//              controller: controller,
//              keyboardType: TextInputType.text,
//              textInputAction: TextInputAction.search,
//              onChanged: (value) {
//                if (onChangeAction != null) {
//                  onChangeAction(value.trim());
//                }
//              },
//              decoration: InputDecoration(
//                  contentPadding:
//                      EdgeInsets.symmetric(vertical: 9.0, horizontal: 0),
//                  hintText: hintText,
//                  border: InputBorder.none,
//                  hintStyle:
//                      TextStyle(color: Color.fromRGBO(152, 149, 153, 1))),
//            ),
//            flex: 8,
//          ),
//          _getCancelIcon()
//        ],
//      ),
//    );
//  }
//}
