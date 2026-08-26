import 'package:flutter/material.dart';
import 'package:qltstc_kiemke/models/bieudotonghop.dart';
import 'package:qltstc_kiemke/services/taisan_service.dart';
import 'package:qltstc_kiemke/services/user_service.dart';
import 'package:qltstc_kiemke/utils/color_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainPageChart2 extends StatefulWidget {
  const MainPageChart2({
    Key? key,
  }) : super(key: key);
  @override
  _MainPageChart2State createState() => _MainPageChart2State();
}

class _MainPageChart2State extends State<MainPageChart2> {
  List<BieuDoTongHop>? _bieuDoTongHop;
  bool _isLoadingChart2 = false;
  String _selectedYear2 = DateTime.now().year.toString();
  final List<String> _years = [
    DateTime.now().year.toString(),
    (DateTime.now().year - 1).toString(),
    (DateTime.now().year - 2).toString(),
  ];

  @override
  void initState() {
    super.initState();
    _loadChart2Data();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Số liệu theo loại Tài sản",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                DropdownButton<String>(
                  value: _selectedYear2,
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
                      _selectedYear2 = value!;
                      _loadChart2Data();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoadingChart2
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
                      labelFormat: '{value}Tr',
                      labelStyle: const TextStyle(fontSize: 8),
                      title: AxisTitle(
                          text: 'vnđ',
                          textStyle: const TextStyle(fontSize: 10),
                          alignment: ChartAlignment.center),
                    ),
                    axes: <ChartAxis>[
                      NumericAxis(
                        opposedPosition: true,
                        name: 'yAxis1',
                        majorGridLines: MajorGridLines(width: 0),
                        labelFormat: '{value}',
                        labelStyle: const TextStyle(fontSize: 8),
                        title: AxisTitle(
                          text: 'SL',
                          textStyle: const TextStyle(fontSize: 10),
                          alignment: ChartAlignment.center,
                        ),
                      ),
                    ],
                    series: _buildMultipleSeries(),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true, enablePanning: true),
                  ),
          ),
        ],
      ),
    );
  }

  //syncfusion_flutter_charts components
  List<CartesianSeries<BieuDoTongHop, String>> _buildMultipleSeries() {
    if (_bieuDoTongHop == null || _bieuDoTongHop!.isEmpty) {
      return [];
    }

    return <CartesianSeries<BieuDoTongHop, String>>[
      ColumnSeries<BieuDoTongHop, String>(
        dataSource: _bieuDoTongHop!,
        xValueMapper: (BieuDoTongHop data, int index) => data.loaiTaiSan,
        // data.loaiTaiSan.length > 15
        //     ? '${data.loaiTaiSan.substring(0, 15)}...'
        //     : data.loaiTaiSan,
        yValueMapper: (BieuDoTongHop data, int index) =>
            (data.nguyenGia) / 1000000,
        // data.nguyenGia > 9
        //     ? (data.nguyenGia) / 1000000000
        //     : data.nguyenGia / 1000000,
        name: 'Nguyên giá (triệu)',
        color: ColorUtils.mainColor,
      ),
      SplineSeries<BieuDoTongHop, String>(
        dataSource: _bieuDoTongHop!,
        yAxisName: 'yAxis1',
        xValueMapper: (BieuDoTongHop data, int index) => data.loaiTaiSan,
        // data.loaiTaiSan.length > 15
        //     ? '${data.loaiTaiSan.substring(0, 15)}...'
        //     : data.loaiTaiSan,
        yValueMapper: (BieuDoTongHop data, int index) => data.soLuong,
        name: 'Số lượng',
        color: Colors.orange,
        markerSettings:
            const MarkerSettings(isVisible: true, height: 10, width: 10),
      ),
    ];
  }
  //End syncfusion_flutter_charts components

  //fl_chart components
  Future<void> _loadChart2Data() async {
    setState(() {
      _isLoadingChart2 = true;
    });

    try {
      var user = UserService.sharedInstance().currentUser!;
      String rawDonviId = user.donviId!;

      final bieuDoTongHop = await TaiSanService.sharedInstance()
          .getBieuDoTongHop(rawDonviId, _selectedYear2);

      if (mounted) {
        setState(() {
          _bieuDoTongHop = bieuDoTongHop;
          _isLoadingChart2 = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingChart2 = false;
        });
      }
      print('Error loading chart 2 data: $e');
    }
  }

//#endregion fl_chart components
}
