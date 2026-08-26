import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:qltstc_kiemke/utils/color_utils.dart';
// import 'package:qltstc_kiemke/modules/common_widgets/widget_account_header.dart';

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;
  bool _canScan = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _canScan = true;
        });
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        // Quét mã QR từ ảnh đã chọn
        await cameraController.stop();

        // Lắng nghe stream để nhận kết quả quét
        final completer = Completer<String?>();
        late StreamSubscription<BarcodeCapture> subscription;
        subscription =
            cameraController.barcodes.listen((BarcodeCapture capture) {
          if (!completer.isCompleted && capture.barcodes.isNotEmpty) {
            final String? code = capture.barcodes.first.rawValue;
            if (code != null && code.isNotEmpty) {
              completer.complete(code);
            } else {
              completer.complete(null);
            }
            subscription.cancel();
          }
        });
        final BarcodeCapture? capture =
            await cameraController.analyzeImage(image.path);
        if (capture != null && capture.barcodes.isNotEmpty) {
          final String? code = await completer.future.timeout(
            Duration(seconds: 2),
            onTimeout: () => null,
          );
          subscription.cancel();

          if (code != null && !_screenOpened) {
            _screenOpened = true;
            Navigator.of(context).pop(code);
          } else {
            subscription.cancel();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Không tìm thấy mã QR trong ảnh')),
            );
            await cameraController.start();
          }
        } else {
          subscription.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không tìm thấy mã QR trong ảnh')),
          );
          await cameraController.start();
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh')),
      );
      try {
        await cameraController.start();
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quét mã tra cứu',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        flexibleSpace: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/res/images/header.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size layoutSize = constraints.biggest;

          final double scanWindowSize = layoutSize.width * 0.6;

          final Rect scanWindow = Rect.fromCenter(
            center: Offset(layoutSize.width / 2, layoutSize.height / 2 - 40),
            width: scanWindowSize,
            height: scanWindowSize,
          );

          return Stack(
            children: [
              MobileScanner(
                controller: cameraController,
                scanWindow: scanWindow,
                onDetect: (capture) {
                  if (_canScan && !_screenOpened) {
                    final List<Barcode> barcodes = capture.barcodes;
                    HapticFeedback.vibrate();
                    if (barcodes.isNotEmpty) {
                      final String code = barcodes.first.rawValue ?? "";
                      if (code.isNotEmpty) {
                        _screenOpened = true;
                        Navigator.of(context).pop(code);
                      } else {
                        Navigator.of(context).pop(null);
                      }
                    }
                  }
                },
              ),
              CustomPaint(
                painter: ScanWindowPainter(scanWindow),
                child: Container(),
              ),
              // Text hướng dẫn phía trên ô quét
              Positioned(
                top: scanWindow.top - 80,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Đưa mã QR vào trung tâm của camera,\ntiến trình sẽ diễn ra tự động.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              // Nút truy cập thư viện ảnh
              Positioned(
                top: scanWindow.bottom + 30,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: Icon(Icons.photo_library, color: Colors.white),
                    label: Text(
                      'Truy cập thư viện ảnh',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              // Nút Đóng ở footer
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Text(
                        'Đóng',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class ScanWindowPainter extends CustomPainter {
  final Rect scanWindow;

  ScanWindowPainter(this.scanWindow);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()..color = Colors.black.withAlpha(153);

    final outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final innerPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)),
      );

    final overlayPath =
        Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(overlayPath, overlayPaint);

    final Paint borderPaint = Paint()
      ..color = Colors.blue[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)),
      borderPaint,
    );

    final Paint cornerPaint = Paint()
      ..color = Colors.blue[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final double cornerLength = 40.0;
    final double radius = 20.0;
    canvas.drawPath(
      Path()
        ..moveTo(scanWindow.left, scanWindow.top + cornerLength)
        ..lineTo(scanWindow.left, scanWindow.top + radius)
        ..arcToPoint(
          Offset(scanWindow.left + radius, scanWindow.top),
          radius: Radius.circular(radius),
        )
        ..lineTo(scanWindow.left + cornerLength, scanWindow.top),
      cornerPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanWindow.right - cornerLength, scanWindow.top)
        ..lineTo(scanWindow.right - radius, scanWindow.top)
        ..arcToPoint(
          Offset(scanWindow.right, scanWindow.top + radius),
          radius: Radius.circular(radius),
        )
        ..lineTo(scanWindow.right, scanWindow.top + cornerLength),
      cornerPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanWindow.left + cornerLength, scanWindow.bottom)
        ..lineTo(scanWindow.left + radius, scanWindow.bottom)
        ..arcToPoint(
          Offset(scanWindow.left, scanWindow.bottom - radius),
          radius: Radius.circular(radius),
        )
        ..lineTo(scanWindow.left, scanWindow.bottom - cornerLength),
      cornerPaint,
    );

    canvas.drawPath(
      Path()
        ..moveTo(scanWindow.right, scanWindow.bottom - cornerLength)
        ..lineTo(scanWindow.right, scanWindow.bottom - radius)
        ..arcToPoint(
          Offset(scanWindow.right - radius, scanWindow.bottom),
          radius: Radius.circular(radius),
        )
        ..lineTo(scanWindow.right - cornerLength, scanWindow.bottom),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
