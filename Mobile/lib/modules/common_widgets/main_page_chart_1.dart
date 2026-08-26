import 'package:flutter/material.dart';
import 'package:qltstc_kiemke/models/bieudotanggiam.dart';
import 'package:qltstc_kiemke/services/taisan_service.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainPageChart1 extends StatefulWidget {
  const MainPageChart1({
    Key? key,
  }) : super(key: key);
  @override
  _MainPageChart1State createState() => _MainPageChart1State();
}

class _MainPageChart1State extends State<MainPageChart1> {
  BieuDoTangGiam? _bieuDoTangGiam;
  List<TangGiamChiTiet>? _listTangGiamChiTiets;
  bool _isLoadingChart1 = false;
  String _selectedYear1 = DateTime.now().year.toString();
  final List<String> _years = [
    DateTime.now().year.toString(),
    (DateTime.now().year - 1).toString(),
    (DateTime.now().year - 2).toString(),
  ];
  String _formatNumber(double? number) {
    if (number == null) return '0';
    if (number == number.toInt()) {
      return number.toInt().toString();
    }
    return number.toString();
  }

  @override
  void initState() {
    super.initState();
    _loadChart1Data();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Số liệu Tài sản tăng, giảm",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              DropdownButton<String>(
                value: _selectedYear1,
                style: TextStyle(color: Colors.black),
                underline: Container(),
                items: _years.map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(year),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedYear1 = value!;
                    _loadChart1Data();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          if (_bieuDoTangGiam != null) ...[
            Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(text: "Đầu kỳ: "),
                        TextSpan(
                          text:
                              "${_formatNumber(_bieuDoTangGiam!.tongDkSl.toDouble())}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(text: "Tăng: "),
                        TextSpan(
                          text:
                              "${_formatNumber(_bieuDoTangGiam!.tongTangSl.toDouble())}",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(text: "Giảm: "),
                        TextSpan(
                          text:
                              "${_formatNumber(_bieuDoTangGiam!.tongGiamSl.toDouble())}",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(text: "Cuối kỳ: "),
                        TextSpan(
                          text:
                              "${_formatNumber(_bieuDoTangGiam!.tongCkSl.toDouble())}",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
          SizedBox(height: 8),
          Expanded(
            child: _isLoadingChart1
                ? Center(child: CircularProgressIndicator())
                : SfCartesianChart(
                    margin: EdgeInsets.zero,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: -30,
                      labelStyle: const TextStyle(fontSize: 8),
                      labelIntersectAction: AxisLabelIntersectAction.none,
                      maximumLabelWidth: 60,
                      maximumLabels: 2,
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelFormat: '{value}',
                      labelStyle: const TextStyle(fontSize: 8),
                      title: AxisTitle(
                          text: 'Số lượng',
                          textStyle: const TextStyle(fontSize: 10),
                          alignment: ChartAlignment.center),
                    ),
                    series: _buildSeries(),
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true, enablePanning: true),
                  ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  List<CartesianSeries<TangGiamChiTiet, String>> _buildSeries() {
    if (_listTangGiamChiTiets == null || _listTangGiamChiTiets!.isEmpty) {
      return [];
    }

    return <CartesianSeries<TangGiamChiTiet, String>>[
      ColumnSeries<TangGiamChiTiet, String>(
        dataSource: _listTangGiamChiTiets!,
        xValueMapper: (TangGiamChiTiet data, int index) => data.loaiTaiSan,
        yValueMapper: (TangGiamChiTiet data, int index) => data.dkSl,
        name: 'Đầu kỳ',
        color: Colors.blue,
      ),
      ColumnSeries<TangGiamChiTiet, String>(
        dataSource: _listTangGiamChiTiets!,
        xValueMapper: (TangGiamChiTiet data, int index) => data.loaiTaiSan,
        yValueMapper: (TangGiamChiTiet data, int index) => data.tangSl,
        name: 'Tăng',
        color: Colors.green,
      ),
      ColumnSeries<TangGiamChiTiet, String>(
        dataSource: _listTangGiamChiTiets!,
        xValueMapper: (TangGiamChiTiet data, int index) => data.loaiTaiSan,
        yValueMapper: (TangGiamChiTiet data, int index) => data.giamSl,
        name: 'Giảm',
        color: Colors.red,
      ),
      ColumnSeries<TangGiamChiTiet, String>(
        dataSource: _listTangGiamChiTiets!,
        xValueMapper: (TangGiamChiTiet data, int index) => data.loaiTaiSan,
        yValueMapper: (TangGiamChiTiet data, int index) => data.ckSl,
        name: 'Cuối kỳ',
        color: Colors.orange,
      ),
    ];
  }

  Future<void> _loadChart1Data() async {
    setState(() {
      _isLoadingChart1 = true;
    });

    try {
      var user = UserService.sharedInstance().currentUser!;
      String rawDonviId = user.donviId!;

      final bieuDoTangGiam = await TaiSanService.sharedInstance()
          .getBieuDoTangGiam(rawDonviId, _selectedYear1);

      if (mounted) {
        setState(() {
          _bieuDoTangGiam = bieuDoTangGiam;
          _listTangGiamChiTiets = bieuDoTangGiam?.tangGiamChiTiets;
          _isLoadingChart1 = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingChart1 = false;
        });
      }
      print('Error loading chart 1 data: $e');
    }
  }

  //#region fl_chart 1 methods

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

  // List<BarChartGroupData> _getBarData1() {
  //   if (_bieuDoTangGiam?.tangGiamChiTiets == null) return [];

  //   return _bieuDoTangGiam!.tangGiamChiTiets.asMap().entries.map((entry) {
  //     int index = entry.key;
  //     var item = entry.value;

  //     return BarChartGroupData(
  //       x: index,
  //       barRods: [
  //         // DK_SL (Đầu kỳ) - Blue
  //         BarChartRodData(
  //           toY: item.dkSl?.toDouble() ?? 0,
  //           color: Colors.blue,
  //           width: 8,
  //         ),
  //         // TANG_SL (Tăng) - Green
  //         BarChartRodData(
  //           toY: item.tangSl?.toDouble() ?? 0,
  //           color: Colors.green,
  //           width: 8,
  //         ),
  //         // GIAM_SL (Giảm) - Red
  //         BarChartRodData(
  //           toY: item.giamSl?.toDouble() ?? 0,
  //           color: Colors.red,
  //           width: 8,
  //         ),
  //         // CK_SL (Cuối kỳ) - Orange
  //         BarChartRodData(
  //           toY: item.ckSl?.toDouble() ?? 0,
  //           color: Colors.orange,
  //           width: 8,
  //         ),
  //       ],
  //     );
  //   }).toList();
  // }

  // double _getMaxY1() {
  //   if (_bieuDoTangGiam?.tangGiamChiTiets == null) return 100;

  //   double maxValue = 0;
  //   for (var item in _bieuDoTangGiam!.tangGiamChiTiets) {
  //     maxValue = [
  //       maxValue,
  //       item.dkSl ?? 0,
  //       item.tangSl ?? 0,
  //       item.giamSl ?? 0,
  //       item.ckSl ?? 0
  //     ].reduce((a, b) => a > b ? a : b).toDouble();
  //   }
  //   return maxValue * 1.2; // Add 20% padding
  // }

  // Widget _getTitleWidget1(int index) {
  //   if (_bieuDoTangGiam?.tangGiamChiTiets == null ||
  //       index >= _bieuDoTangGiam!.tangGiamChiTiets.length) {
  //     return Text('');
  //   }

  //   String title = _bieuDoTangGiam!.tangGiamChiTiets[index].loaiTaiSan;
  //   return SideTitleWidget(
  //       axisSide: AxisSide.bottom,
  //       child: Column(
  //         children: [
  //           SizedBox(height: 8), // Khoảng cách từ biểu đồ
  //           Transform.rotate(
  //             angle: -0.5, // Nghiêng khoảng 30 độ
  //             child: Container(
  //               width: 60,
  //               child: Text(
  //                 title,
  //                 style: TextStyle(fontSize: 8),
  //                 textAlign: TextAlign.center,
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  //#endregion fl_chart 1 methods
}
