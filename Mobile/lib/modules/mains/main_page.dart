import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:qltstc_kiemke/models/bbkk.dart';
// import 'package:qltstc_kiemke/models/bieudotonghop.dart';
import 'package:qltstc_kiemke/modules/bbkk/taomoibbkk/thongtinkiemkecreate.dart';
import 'package:qltstc_kiemke/modules/common_widgets/main_page_chart_1.dart';
import 'package:qltstc_kiemke/modules/common_widgets/main_page_chart_2.dart';
import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';
import 'package:qltstc_kiemke/modules/bbkk/list_bbkk.dart';
import 'package:qltstc_kiemke/modules/bbkk/thongtinccdc/thongtinccdcquetma.dart';
import 'package:qltstc_kiemke/modules/bbkk/thongtintaisan/thongtintaisanquetma.dart';
import 'package:qltstc_kiemke/modules/common_widgets/barcode_scanner_screen.dart';
import 'package:qltstc_kiemke/services/BBKKService.dart';
import 'package:qltstc_kiemke/services/taisan_service.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:qltstc_kiemke/utils/loading_widget.dart';
// import 'package:fl_chart/fl_chart.dart';
import '../../utils/dialog_utils.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _hasInitialized = false;
  var _showLoading = false.obs;
  var _showQRLoading = false.obs; // Separate loading for QR scanning
  var _isQRTab = false; // Track if we're on QR tab to avoid loading
  // int _selectedIndex = 2; // Default to Biên bản kiểm kê
  // String _selectedYear2 = DateTime.now().year.toString();
  // final List<String> _years = [
  //   DateTime.now().year.toString(),
  //   (DateTime.now().year - 1).toString(),
  //   (DateTime.now().year - 2).toString(),
  // ];

  // List<BieuDoTongHop>? _bieuDoTongHop;
  // bool _isLoadingChart2 = false;

  // String _formatNumber(double? number) {
  //   if (number == null) return '0';
  //   if (number == number.toInt()) {
  //     return number.toInt().toString();
  //   }
  //   return number.toString();
  // }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_hasInitialized) return;

    setState(() {
      // _showLoading.value = true;
      _hasInitialized = true;
    });
    if (!_isQRTab) {
      setState(() {
        _showLoading.value = true;
      });
      try {
        await UserService.sharedInstance().getNhomTS(refresh: true);
      } finally {
        if (mounted) {
          setState(() {
            _showLoading.value = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Chỉ show loading nếu không phải QR tab
    // if (!_isQRTab) {
    //   _showLoading.value = true;
    //   getCacheData().then((value) => _showLoading.value = false);
    // }
    var user = UserService.sharedInstance().currentUser!;
    return Stack(
      children: [
        Scaffold(
          appBar: AccountHeader(),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Config.BASE_PADDING),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              MainPageChart1(),
                              MainPageChart2(),
                              //#region fl_chart 2 widget
                              // Container(
                              //   height: 350,
                              //   margin: EdgeInsets.symmetric(
                              //       horizontal: 8, vertical: 6),
                              //   padding: EdgeInsets.all(8),
                              //   decoration: BoxDecoration(
                              //     color: Theme.of(context).colorScheme.surface,
                              //     borderRadius: BorderRadius.circular(10),
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.grey.withOpacity(0.5),
                              //         spreadRadius: 2,
                              //         blurRadius: 7,
                              //         offset: Offset(0, 3),
                              //       ),
                              //     ],
                              //   ),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Text(
                              //             "Số liệu theo loại Tài sản",
                              //             style: Theme.of(context)
                              //                 .textTheme
                              //                 .titleLarge,
                              //           ),
                              //           DropdownButton<String>(
                              //             value: _selectedYear2,
                              //             style: TextStyle(color: Colors.black),
                              //             underline: Container(),
                              //             items: _years.map((String year) {
                              //               return DropdownMenuItem<String>(
                              //                 value: year,
                              //                 child: Text(year),
                              //               );
                              //             }).toList(),
                              //             onChanged: (String? value) {
                              //               setState(() {
                              //                 _selectedYear2 = value!;
                              //                 _loadChart2Data();
                              //               });
                              //             },
                              //           ),
                              //         ],
                              //       ),
                              //       SizedBox(height: 8),
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         children: [
                              //           _buildLegendItem(
                              //               ColorUtils.mainColor, "Nguyên giá"),
                              //           SizedBox(width: 20),
                              //           _buildLegendItem(
                              //               Colors.orange, "Số lượng"),
                              //         ],
                              //       ),
                              //       SizedBox(height: 8),
                              //       Expanded(
                              //         child: _isLoadingChart2
                              //             ? Center(
                              //                 child:
                              //                     CircularProgressIndicator())
                              //             : LineChart(
                              //                 LineChartData(
                              //                   lineBarsData:
                              //                       _getCombinedChartData(),
                              //                   minY: 0,
                              //                   maxY: _getMaxY2(),
                              //                   clipData: FlClipData.none(),
                              //                   lineTouchData: LineTouchData(
                              //                     enabled: true,
                              //                     getTouchedSpotIndicator:
                              //                         (LineChartBarData barData,
                              //                             List<int>
                              //                                 spotIndexes) {
                              //                       return spotIndexes
                              //                           .map((spotIndex) {
                              //                         return TouchedSpotIndicatorData(
                              //                           FlLine(
                              //                             color: Colors
                              //                                 .transparent, // Ẩn đường indicator
                              //                           ),
                              //                           FlDotData(
                              //                             show: false,
                              //                             getDotPainter: (spot,
                              //                                 percent,
                              //                                 barData,
                              //                                 index) {
                              //                               return FlDotCirclePainter(
                              //                                 radius: 6,
                              //                                 color: barData
                              //                                         .color ??
                              //                                     Colors
                              //                                         .transparent,
                              //                                 strokeWidth: 2,
                              //                                 strokeColor: Colors
                              //                                     .transparent,
                              //                               );
                              //                             },
                              //                           ),
                              //                         );
                              //                       }).toList();
                              //                     },
                              //                     touchTooltipData:
                              //                         LineTouchTooltipData(
                              //                       tooltipBgColor: Colors.white
                              //                           .withOpacity(0.9),
                              //                       tooltipRoundedRadius: 8,
                              //                       tooltipPadding:
                              //                           EdgeInsets.all(8),
                              //                       tooltipMargin: 8,
                              //                       fitInsideHorizontally:
                              //                           true, // Tránh tràn ô
                              //                       fitInsideVertically: true,
                              //                       getTooltipItems:
                              //                           (List<LineBarSpot>
                              //                               touchedBarSpots) {
                              //                         return touchedBarSpots
                              //                             .map((barSpot) {
                              //                           if (_bieuDoTongHop ==
                              //                                   null ||
                              //                               barSpot.x.toInt() >=
                              //                                   _bieuDoTongHop!
                              //                                       .length) {
                              //                             return null;
                              //                           }
                              //                           final index =
                              //                               barSpot.x.toInt();
                              //                           final item =
                              //                               _bieuDoTongHop![
                              //                                   index];
                              //                           // Kiểm tra xem đây là bar data hay line data
                              //                           bool isLineData = barSpot
                              //                                   .barIndex ==
                              //                               _bieuDoTongHop!
                              //                                   .length; // Line data là item cuối cùng
                              //                           String text;
                              //                           Color color;
                              //                           if (isLineData) {
                              //                             text =
                              //                                 'Số lượng: ${_formatNumber(item.soLuong.toDouble())}';
                              //                             color = Colors.orange;
                              //                           } else {
                              //                             double
                              //                                 nguyenGiaTrieu =
                              //                                 item.nguyenGia /
                              //                                     1000000;
                              //                             text =
                              //                                 'Nguyên giá: ${_formatNumber(nguyenGiaTrieu)} tr';
                              //                             color = ColorUtils
                              //                                 .mainColor;
                              //                           }
                              //                           return LineTooltipItem(
                              //                             text,
                              //                             TextStyle(
                              //                               color: color,
                              //                               fontSize: 12,
                              //                               fontWeight:
                              //                                   FontWeight.w500,
                              //                             ),
                              //                           );
                              //                         }).toList();
                              //                       },
                              //                     ),
                              //                   ),
                              //                   titlesData: FlTitlesData(
                              //                     show: true,
                              //                     bottomTitles: AxisTitles(
                              //                       sideTitles: SideTitles(
                              //                         showTitles: true,
                              //                         reservedSize: 50,
                              //                         interval: 1.0,
                              //                         getTitlesWidget:
                              //                             (value, meta) {
                              //                           return _getTitleWidget2(
                              //                               value.toInt());
                              //                         },
                              //                       ),
                              //                     ),
                              //                     leftTitles: AxisTitles(
                              //                       axisNameWidget: Text(
                              //                         "Nguyên giá (triệu đồng)",
                              //                         style: TextStyle(
                              //                             fontSize: 10,
                              //                             color: ColorUtils
                              //                                 .mainColor),
                              //                       ),
                              //                       sideTitles: SideTitles(
                              //                         showTitles: true,
                              //                         reservedSize: 40,
                              //                         getTitlesWidget:
                              //                             (value, meta) {
                              //                           if (value >=
                              //                               _getMaxY2() *
                              //                                   0.99) {
                              //                             return Container();
                              //                           }
                              //                           return Text(
                              //                             _formatNumber(value /
                              //                                     1000000) +
                              //                                 "tr",
                              //                             style: TextStyle(
                              //                                 fontSize: 8,
                              //                                 color: ColorUtils
                              //                                     .mainColor),
                              //                           );
                              //                         },
                              //                       ),
                              //                     ),
                              //                     rightTitles: AxisTitles(
                              //                       axisNameWidget: Text(
                              //                         "Số lượng",
                              //                         style: TextStyle(
                              //                             fontSize: 10,
                              //                             color: Colors.orange),
                              //                       ),
                              //                       axisNameSize: 40,
                              //                       sideTitles: SideTitles(
                              //                         showTitles: false,
                              //                       ),
                              //                     ),
                              //                     topTitles: AxisTitles(
                              //                       sideTitles: SideTitles(
                              //                           showTitles: false),
                              //                     ),
                              //                   ),
                              //                   borderData:
                              //                       FlBorderData(show: false),
                              //                   gridData: FlGridData(
                              //                     show: true,
                              //                     drawHorizontalLine: true,
                              //                     drawVerticalLine: false,
                              //                     // horizontalInterval:
                              //                     //     _getMaxY2() / 5,
                              //                   ),
                              //                 ),
                              //               ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              //#endregion fl_chart 2 widget
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                height: 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // _selectedIndex = 0;
                                _isQRTab = false;
                              });
                              _handleBottomNavTap(
                                  0, user.donviId, user.tenDonVi);
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    IconsaxPlusLinear.note_add,
                                    size: 24,
                                    color:
                                        //  _selectedIndex == 0
                                        //     ? ColorUtils.mainColor
                                        //     :
                                        Colors.grey,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Thêm biên bản',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          // _selectedIndex == 0
                                          //     ? ColorUtils.mainColor
                                          //     :
                                          Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                // _selectedIndex = 2;
                                _isQRTab = false;
                              });
                              _handleBottomNavTap(
                                  2, user.donviId, user.tenDonVi);
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    IconsaxPlusLinear.note,
                                    size: 24,
                                    color:
                                        // _selectedIndex == 2
                                        //     ? ColorUtils.mainColor
                                        //     :
                                        Colors.grey,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Biên bản kiểm kê',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          // _selectedIndex == 2
                                          //     ? ColorUtils.mainColor
                                          //     :
                                          Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: -28,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, -4)),
                          ],
                        ),
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  // _selectedIndex = 1;
                                  _isQRTab = true;
                                });
                                _showQRPopupMenu(
                                    context, user.donviId, user.tenDonVi);
                              },
                              borderRadius: BorderRadius.circular(28),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: ColorUtils.mainColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconsaxPlusLinear.scan,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: Text(
                        'Quét mã tra cứu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              // _selectedIndex == 1
                              //     ? ColorUtils.mainColor
                              //     : Colors.grey
                              ColorUtils.mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(() => LoadingWidget(_showLoading.value || _showQRLoading.value)),
      ],
    );
  }

  //#region Bottom
  void _handleBottomNavTap(int index, String? donviId, String? tenDonVi) {
    switch (index) {
      case 0:
        // Thêm mới biên bản
        BBKKService.sharedInstance().currentRecord = new BBKK();
        Get.to(
          () => ThongTinKiemKeCreatePage(),
          transition: Transition.cupertino,
        );
        break;
      case 1:
        // Quét mã QR - logic đã được xử lý ở _showQRPopupMenu
        break;
      case 2:
        // Danh sách biên bản
        Get.to(() => ListBBKK());
        break;
    }
  }

  void _showQRPopupMenu(
      BuildContext context, String? donviId, String? tenDonVi) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width * 0.2,
        MediaQuery.of(context).size.height * 0.65,
        MediaQuery.of(context).size.width * 0.2,
        MediaQuery.of(context).size.height * 0.8,
      ),
      items: [
        PopupMenuItem(
          value: 'qr_scan_1',
          child: ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text('Quét mã QR tài sản'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'qr_scan_2',
          child: ListTile(
            leading: Icon(Icons.search),
            title: Text('Quét mã QR công cụ dụng cụ'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    ).then((value) {
      if (value == 'qr_scan_1') {
        _scanBarcode().then((result) {
          if (result != null && result.isNotEmpty) {
            // Show QR loading indicator while fetching data
            setState(() {
              _showQRLoading.value = true;
            });

            TaiSanService.sharedInstance()
                .getThongTinTaiSanDetail(
                    result, DateFormat("yyyy/MM/dd").format(new DateTime.now()))
                .then((value) {
              if (value == null) {
                DialogUtils.alertWithCallback(
                    context,
                    "Không thể lấy thông tin tài sản. Vui lòng kiểm tra kết nối mạng hoặc thử lại sau!",
                    () {});
                setState(() {
                  result = "";
                  _showQRLoading.value = false;
                });
                return;
              } else if (donviId != value.donViId) {
                DialogUtils.alertWithCallback(
                    context, "Tài sản này không thuộc đơn vị này!", () {});
                setState(() {
                  result = "";
                  _showQRLoading.value = false;
                });
                return;
              } else {
                Get.to(
                    ThongTinTaiSanQuetMa(
                      taiSan: value,
                      tenDonVi: tenDonVi,
                    ),
                    transition: Transition.cupertino);
                setState(() {
                  result = "";
                  _showQRLoading.value = false;
                });
              }
            }).catchError((error) {
              DialogUtils.alertWithCallback(
                  context,
                  "Đã xảy ra lỗi khi lấy thông tin tài sản. Vui lòng thử lại!",
                  () {});
              setState(() {
                result = "";
                _showQRLoading.value = false;
              });
            });
          }
        });
      } else if (value == 'qr_scan_2') {
        _scanBarcode().then((result) {
          if (result != null && result.isNotEmpty) {
            // Show QR loading indicator while fetching data
            setState(() {
              _showQRLoading.value = true;
            });

            TaiSanService.sharedInstance()
                .getThongTinCCDCDetail(
                    result, DateFormat("yyyy/MM/dd").format(new DateTime.now()))
                .then((value) {
              if (value == null) {
                DialogUtils.alertWithCallback(
                    context,
                    "Không thể lấy thông tin CCDC. Vui lòng kiểm tra kết nối mạng hoặc thử lại sau!",
                    () {});
                setState(() {
                  result = "";
                  _showQRLoading.value = false;
                });
                return;
              } else if (donviId != value.donViId) {
                DialogUtils.alertWithCallback(
                    context, "CCDC này không thuộc đơn vị này!", () {});
                setState(() {
                  result = "";
                  _showQRLoading.value = false;
                });
                return;
              } else {
                Get.to(
                    ThongTinCCDCQuetMa(
                      taiSan: value,
                      tenDonVi: tenDonVi,
                    ),
                    transition: Transition.cupertino);
                setState(() {
                  result = "";
                  _showQRLoading.value = false;
                });
              }
            }).catchError((error) {
              DialogUtils.alertWithCallback(
                  context,
                  "Đã xảy ra lỗi khi lấy thông tin CCDC. Vui lòng thử lại!",
                  () {});
              setState(() {
                result = "";
                _showQRLoading.value = false;
              });
            });
          }
        });
      }
    });
  }

  Future<String?> _scanBarcode() async {
    return await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => BarcodeScannerScreen()));
  }

  Future<void> getCacheData() async {
    // await UserService.sharedInstance().getBPSD(refresh: true);
    await UserService.sharedInstance().getNhomTS(refresh: true);
    // await BBKKService.sharedInstance().getBBKKs();
    // await _loadChartData();
  }
  //#endregion Bottom

  //#region fl_chart 2 components

  // Future<void> _loadChartData() async {
  //   await Future.wait([
  //     _loadChart1Data(),
  //     _loadChart2Data(),
  //   ]);
  // }

  // List<LineChartBarData> _getCombinedChartData() {
  //   if (_bieuDoTongHop == null) return [];
  //   List<LineChartBarData> chartData = [];
  //   List<LineChartBarData> barData =
  //       _bieuDoTongHop!.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     var item = entry.value;
  //     double nguyenGia = item.nguyenGia.toDouble();
  //     return LineChartBarData(
  //       spots: [
  //         FlSpot(index.toDouble(), 0),
  //         FlSpot(index.toDouble(),
  //             nguyenGia),
  //       ],
  //       isCurved: false,
  //       color: ColorUtils.mainColor.withOpacity(0.7),
  //       barWidth: 20,
  //       dotData: FlDotData(
  //         show: false,
  //         getDotPainter: (spot, percent, barData, index) {
  //           return FlDotSquarePainter(
  //             size: 20,
  //             color: ColorUtils.mainColor.withOpacity(0.7),
  //             strokeWidth: 0,
  //           );
  //         },
  //       ),
  //       belowBarData: BarAreaData(
  //         show: false,
  //         color: ColorUtils.mainColor.withOpacity(0.7),
  //         cutOffY: 0,
  //         applyCutOffY: true,
  //       ),
  //     );
  //   }).toList();
  //   List<FlSpot> lineSpots = _bieuDoTongHop!.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     var item = entry.value;
  //     double soLuong = item.soLuong.toDouble();
  //     double scaledSoLuong = soLuong * _getMaxY2() / _getMaxSoLuong2();
  //     return FlSpot(index.toDouble(), scaledSoLuong);
  //   }).toList();
  //   LineChartBarData lineChart = LineChartBarData(
  //     spots: lineSpots,
  //     isCurved: false,
  //     color: Colors.orange,
  //     barWidth: 3,
  //     dotData: FlDotData(
  //       show: true,
  //       getDotPainter: (spot, percent, barData, index) {
  //         return FlDotCirclePainter(
  //           radius: 4,
  //           color: Colors.orange,
  //           strokeWidth: 2,
  //           strokeColor: Colors.white,
  //         );
  //       },
  //     ),
  //     belowBarData: BarAreaData(
  //       show: false,
  //     ),
  //   );
  //   chartData.addAll(barData);
  //   chartData.add(lineChart);
  //   return chartData;
  // }

  // Widget _buildLegendItem(Color color, String label) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Container(
  //         width: 12,
  //         height: 12,
  //         decoration: BoxDecoration(
  //           color: color,
  //           shape: BoxShape.rectangle,
  //           borderRadius: BorderRadius.circular(2),
  //         ),
  //       ),
  //       SizedBox(width: 4),
  //       Text(
  //         label,
  //         style: TextStyle(fontSize: 10),
  //       ),
  //     ],
  //   );
  // }

  // Future<void> _loadChart2Data() async {
  //   setState(() {
  //     _isLoadingChart2 = true;
  //   });
  //   try {
  //     var user = UserService.sharedInstance().currentUser!;
  //     String rawDonviId = user.donviId!;
  //     final bieuDoTongHop = await TaiSanService.sharedInstance()
  //         .getBieuDoTongHop(rawDonviId, _selectedYear2);
  //     if (mounted) {
  //       setState(() {
  //         _bieuDoTongHop = bieuDoTongHop;
  //         _isLoadingChart2 = false;
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _isLoadingChart2 = false;
  //       });
  //     }
  //     print('Error loading chart 2 data: $e');
  //   }
  // }

  // double _getMaxY2() {
  //   if (_bieuDoTongHop == null) return 100;
  //   double maxValue = _bieuDoTongHop!
  //       .map((e) => e.nguyenGia)
  //       .reduce((a, b) => a > b ? a : b)
  //       .toDouble();
  //   return maxValue * 1.2; // Add 20% padding
  // }

  // double _getMaxSoLuong2() {
  //   if (_bieuDoTongHop == null) return 100;
  //   double maxValue = _bieuDoTongHop!
  //       .map((e) => e.soLuong)
  //       .reduce((a, b) => a > b ? a : b)
  //       .toDouble();
  //   return maxValue * 1.2; // Add 20% padding
  // }

  // Widget _getTitleWidget2(int index) {
  //   if (_bieuDoTongHop == null || index >= _bieuDoTongHop!.length) {
  //     return Text('');
  //   }
  //   String title = _bieuDoTongHop![index].loaiTaiSan;
  //   return SideTitleWidget(
  //     axisSide: AxisSide.bottom,
  //     child: Column(
  //       children: [
  //         SizedBox(height: 8), // Khoảng cách từ biểu đồ
  //         Transform.rotate(
  //           angle: -0.5, // Nghiêng khoảng 30 độ
  //           child: Container(
  //             width: 60,
  //             child: Text(
  //               title,
  //               style: TextStyle(fontSize: 8),
  //               textAlign: TextAlign.center,
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //               softWrap: true,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  //#endregion fl_chart 2 components
}
