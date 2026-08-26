# HƯỚNG DẪN CÀI ĐẶT VÀ CHẠY PROJECT QLTSTC KIỂM KÊ

## Tổng quan về Project

**Tên project:** qltstc_kiemke (Quản lý Tài sản cố định - Kiểm kê)

**Mô tả:** Ứng dụng Flutter dùng để quản lý và kiểm kê tài sản cố định, bao gồm các chức năng:
- Đăng nhập và xác thực người dùng
- Quét mã QR/barcode để kiểm tra tài sản
- Tạo và quản lý biên bản kiểm kê (BBKK)
- Xem thông tin chi tiết tài sản và công cụ dụng cụ
- Hiển thị biểu đồ thống kê tăng giảm và tổng hợp tài sản
- Chụp ảnh tài sản
- Quản lý hội đồng kiểm kê

**Công nghệ sử dụng:**
- Flutter SDK 2.12.0 trở lên
- Dart
- GetX (State Management)
- Dio (HTTP Client)
- Mobile Scanner (Quét QR/Barcode)
- Syncfusion Charts (Biểu đồ)

---

## PHẦN 1: YÊU CẦU HỆ THỐNG

### 1.1. Phần cứng tối thiểu
- **CPU:** Intel Core i3 hoặc tương đương
- **RAM:** 8GB (khuyến nghị 16GB)
- **Ổ cứng:** 10GB dung lượng trống
- **Hệ điều hành:** Windows 10/11 (64-bit)

### 1.2. Phần mềm cần thiết
- Visual Studio Code (phiên bản mới nhất)
- Flutter SDK (phiên bản 3.35.4 hoặc cao hơn)
- Android Studio (để sử dụng Android Emulator và SDK)
- Git (để quản lý source code)
- Java JDK 11 hoặc 17

---

## PHẦN 2: CÀI ĐẶT MÔI TRƯỜNG PHÁT TRIỂN

### 2.1. Cài đặt Visual Studio Code

1. Tải Visual Studio Code từ: https://code.visualstudio.com/
2. Chạy file cài đặt và làm theo hướng dẫn
3. Sau khi cài đặt xong, mở VS Code

### 2.2. Cài đặt Flutter SDK

#### Bước 1: Tải Flutter SDK
1. Truy cập: https://docs.flutter.dev/get-started/install/windows
2. Tải file ZIP của Flutter SDK phiên bản Stable
3. Giải nén vào thư mục (ví dụ: `C:\src\flutter`)

#### Bước 2: Cấu hình biến môi trường
1. Nhấn `Windows + R`, gõ `sysdm.cpl` và Enter
2. Chọn tab **Advanced** → Click **Environment Variables**
3. Trong phần **User variables**, tìm biến **Path**
4. Click **Edit** → **New** → Thêm đường dẫn: `C:\src\flutter\bin`
5. Click **OK** để lưu

#### Bước 3: Kiểm tra cài đặt Flutter
```bash
# Mở Command Prompt hoặc PowerShell
flutter --version
flutter doctor
```

### 2.3. Cài đặt Android Studio

#### Bước 1: Tải và cài đặt Android Studio
1. Tải từ: https://developer.android.com/studio
2. Chạy file cài đặt
3. Trong quá trình cài đặt, đảm bảo chọn:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (AVD)

#### Bước 2: Cài đặt Android SDK
1. Mở Android Studio
2. Click **More Actions** → **SDK Manager**
3. Trong tab **SDK Platforms**, chọn:
   - Android 13.0 (Tiramisu) - API Level 33
   - Android 12.0 (S) - API Level 31
   - Android 11.0 (R) - API Level 30
4. Trong tab **SDK Tools**, đảm bảo đã chọn:
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Command-line Tools
   - Android Emulator
   - Intel x86 Emulator Accelerator (HAXM installer) - nếu CPU là Intel
5. Click **Apply** để tải và cài đặt

#### Bước 3: Thiết lập licenses
```bash
flutter doctor --android-licenses
# Gõ 'y' để đồng ý tất cả licenses
```

### 2.4. Cài đặt Extensions cho VS Code

Mở VS Code và cài đặt các extension sau:

1. **Flutter** (Dart Code)
   - Mở Extensions (`Ctrl + Shift + X`)
   - Tìm "Flutter" và cài đặt
   - Extension này sẽ tự động cài đặt extension "Dart"

2. **Dart** (sẽ được cài tự động cùng Flutter)

3. **Android iOS Emulator** (tùy chọn nhưng hữu ích)
   - Giúp khởi động emulator trực tiếp từ VS Code

### 2.5. Cấu hình Flutter trong VS Code

1. Mở VS Code
2. Nhấn `Ctrl + Shift + P` để mở Command Palette
3. Gõ "Flutter: Run Flutter Doctor" và chọn
4. Xem kết quả trong Terminal, đảm bảo không có lỗi nghiêm trọng

---

## PHẦN 3: TẠO VÀ CẤU HÌNH ANDROID EMULATOR

### 3.1. Tạo Android Virtual Device (AVD)

#### Cách 1: Sử dụng Android Studio
1. Mở Android Studio
2. Click **More Actions** → **Virtual Device Manager** (hoặc **AVD Manager**)
3. Click **Create Device**
4. Chọn một thiết bị (khuyến nghị: **Pixel 5** hoặc **Pixel 6**)
5. Click **Next**
6. Chọn System Image:
   - Khuyến nghị: **Tiramisu (API Level 33)** hoặc **S (API Level 31)**
   - Click **Download** nếu chưa có
7. Click **Next**
8. Đặt tên cho AVD (ví dụ: "Pixel_5_API_33")
9. Trong **Advanced Settings**:
   - RAM: 2048 MB trở lên
   - Internal Storage: 2048 MB
   - SD Card: 512 MB (nếu cần)
10. Click **Finish**

#### Cách 2: Sử dụng Command Line
```bash
# Xem danh sách system images có sẵn
sdkmanager --list | findstr "system-images"

# Tải system image (ví dụ Android 33)
sdkmanager "system-images;android-33;google_apis_playstore;x86_64"

# Tạo AVD
avdmanager create avd -n Pixel_5_API_33 -k "system-images;android-33;google_apis_playstore;x86_64" -d pixel_5
```

### 3.2. Khởi động Emulator

#### Từ Android Studio:
1. Mở **AVD Manager**
2. Click nút ▶️ (Play) bên cạnh AVD bạn vừa tạo

#### Từ VS Code:
1. Nhấn `Ctrl + Shift + P`
2. Gõ "Flutter: Launch Emulator"
3. Chọn emulator bạn muốn khởi động

#### Từ Command Line:
```bash
# Xem danh sách emulator
emulator -list-avds

# Khởi động emulator
emulator -avd Pixel_5_API_33
```

### 3.3. Kiểm tra kết nối
```bash
# Kiểm tra thiết bị đã kết nối
flutter devices
```

Kết quả sẽ hiển thị emulator của bạn, ví dụ:
```
Pixel 5 API 33 (mobile) • emulator-5554 • android-x86 • Android 13 (API 33)
```

---

## PHẦN 4: MỞ VÀ CẤU HÌNH PROJECT

### 4.1. Mở Project trong VS Code

1. Mở VS Code
2. Chọn **File** → **Open Folder**
3. Điều hướng đến thư mục project: `d:\Project\Android\qltstc_kiemke_new`
4. Click **Select Folder**

### 4.2. Kiểm tra cấu trúc Project

Project có cấu trúc như sau:
```
qltstc_kiemke_new/
├── lib/                          # Thư mục chứa source code chính
│   ├── main.dart                 # File khởi chạy ứng dụng
│   ├── constants/                # Các hằng số và cấu hình
│   │   ├── api_constants.dart    # URL API endpoints
│   │   └── configs.dart          # Cấu hình ứng dụng
│   ├── models/                   # Data models
│   ├── modules/                  # Các module chức năng
│   │   ├── bbkk/                 # Module biên bản kiểm kê
│   │   ├── common_widgets/       # Widgets dùng chung
│   │   ├── login/                # Module đăng nhập
│   │   └── mains/                # Trang chủ
│   ├── services/                 # API services
│   └── utils/                    # Utilities
├── assets/                       # Tài nguyên (hình ảnh, fonts...)
├── test/                         # Unit tests
├── pubspec.yaml                  # File cấu hình dependencies
└── README.md                     # Tài liệu project
```

### 4.3. Cài đặt Dependencies

Mở Terminal trong VS Code (`Ctrl + ~`) và chạy lệnh:

```bash
# Di chuyển vào thư mục project (nếu chưa ở đó)
cd d:\Project\Android\qltstc_kiemke_new

# Tải tất cả dependencies
flutter pub get
```

**Lưu ý:** Lệnh này sẽ tải và cài đặt tất cả các packages được định nghĩa trong file `pubspec.yaml`, bao gồm:
- get (State Management)
- dio (HTTP Client)
- mobile_scanner (Quét QR/Barcode)
- image_picker (Chụp ảnh)
- shared_preferences (Lưu trữ local)
- fl_chart, syncfusion_flutter_charts (Biểu đồ)
- Và nhiều packages khác...

### 4.4. Kiểm tra lỗi

```bash
# Phân tích code và kiểm tra lỗi
flutter analyze

# Kiểm tra môi trường Flutter
flutter doctor -v
```

Nếu có cảnh báo, hãy làm theo hướng dẫn để khắc phục.

---

## PHẦN 5: CHẠY PROJECT

### 5.1. Chuẩn bị chạy ứng dụng

#### Bước 1: Khởi động Android Emulator
- Làm theo hướng dẫn ở **Phần 3.2** để khởi động emulator
- Đợi emulator khởi động hoàn tất (có thể mất 2-3 phút lần đầu)

#### Bước 2: Kiểm tra thiết bị
```bash
flutter devices
```

Đảm bảo emulator của bạn xuất hiện trong danh sách.

### 5.2. Chạy ứng dụng từ VS Code (Khuyến nghị)

#### Cách 1: Sử dụng F5
1. Mở file `lib/main.dart`
2. Nhấn `F5` hoặc chọn **Run** → **Start Debugging**
3. Chọn **Dart & Flutter** nếu được hỏi
4. Chọn thiết bị (emulator) từ danh sách

#### Cách 2: Sử dụng Debug Panel
1. Click biểu tượng **Run and Debug** ở thanh bên trái (hoặc `Ctrl + Shift + D`)
2. Click **Run and Debug** button
3. Chọn **Dart & Flutter**
4. Chọn emulator của bạn

#### Cách 3: Sử dụng Status Bar
1. Ở góc dưới bên phải VS Code, click vào tên thiết bị
2. Chọn emulator của bạn từ danh sách
3. Nhấn `F5` để chạy

### 5.3. Chạy ứng dụng từ Terminal

```bash
# Chạy ở chế độ debug (mode mặc định)
flutter run

# Chạy ở chế độ release (tối ưu hiệu năng)
flutter run --release

# Chạy ở chế độ profile (để phân tích hiệu năng)
flutter run --profile

# Chỉ định thiết bị cụ thể (nếu có nhiều thiết bị)
flutter run -d emulator-5554
```

### 5.4. Quá trình Build và Run

Khi chạy lần đầu tiên, Flutter sẽ:
1. Build project (có thể mất 3-10 phút lần đầu)
2. Cài đặt ứng dụng lên emulator
3. Khởi chạy ứng dụng

**Lưu ý:** Lần chạy đầu tiên sẽ lâu hơn do phải build toàn bộ. Các lần sau sẽ nhanh hơn nhờ Hot Reload.

### 5.5. Giao diện ứng dụng khi chạy

Khi ứng dụng chạy thành công, bạn sẽ thấy:
- **Màn hình Login**: Đây là màn hình đầu tiên
- Giao diện chính của app với các tính năng kiểm kê tài sản

---

## PHẦN 6: SỬ DỤNG TÍNH NĂNG TRONG QUÁ TRÌNH PHÁT TRIỂN

### 6.1. Hot Reload và Hot Restart

#### Hot Reload (r)
- Nhấn `r` trong Terminal khi app đang chạy
- Hoặc nhấn `Ctrl + F5` trong VS Code
- **Công dụng:** Cập nhật thay đổi code ngay lập tức mà không mất trạng thái ứng dụng
- **Thích hợp cho:** Thay đổi UI, logic, thêm widgets

#### Hot Restart (R)
- Nhấn `R` (chữ hoa) trong Terminal
- Hoặc click biểu tượng ⚡ "Hot Restart" trong VS Code
- **Công dụng:** Khởi động lại ứng dụng từ đầu
- **Thích hợp cho:** Thay đổi về state, thêm packages mới

### 6.2. Debug trong VS Code

#### Đặt Breakpoint
1. Click vào lề trái của dòng code bạn muốn dừng
2. Một chấm đỏ sẽ xuất hiện
3. Chạy app ở chế độ Debug (`F5`)
4. App sẽ dừng tại breakpoint

#### Debug Controls
- **Continue (F5):** Tiếp tục chạy đến breakpoint tiếp theo
- **Step Over (F10):** Chạy qua dòng hiện tại
- **Step Into (F11):** Đi vào hàm được gọi
- **Step Out (Shift + F11):** Thoát khỏi hàm hiện tại
- **Restart (Ctrl + Shift + F5):** Khởi động lại debug session
- **Stop (Shift + F5):** Dừng debug

#### Debug Console
- Xem trong panel **Debug Console** ở dưới
- In ra log bằng `print()` hoặc `debugPrint()`
- Xem exceptions và errors

### 6.3. Flutter DevTools

```bash
# Mở Flutter DevTools khi app đang chạy
flutter pub global activate devtools
flutter pub global run devtools
```

DevTools cung cấp:
- Widget Inspector (xem cấu trúc UI)
- Performance view (phân tích hiệu năng)
- Memory view (theo dõi memory)
- Network view (xem các request API)
- Logging view (xem logs chi tiết)

### 6.4. Sử dụng Flutter Inspector

Trong VS Code:
1. Khi app đang chạy ở chế độ Debug
2. Nhấn `Ctrl + Shift + P`
3. Gõ "Flutter: Open Widget Inspector"
4. Hoặc click vào "Flutter Inspector" trong debug sidebar

**Tính năng:**
- Select Widget Mode: Click vào widget trong app để xem thông tin
- Toggle Debug Paint: Hiển thị boundaries của widgets
- Toggle Platform: Chuyển đổi giữa Android/iOS
- Show Performance Overlay: Hiển thị FPS

---

## PHẦN 7: CẤU HÌNH VÀ TÙY CHỈNH

### 7.1. Thay đổi API Endpoints

Nếu bạn muốn kết nối đến server khác:

1. Mở file: `lib/constants/api_constants.dart`
2. Thay đổi các URL tương ứng:

```dart
class APIConstants {
  static String LOGIN = "https://your-api-domain.com/API/oauth/token";
  static String GET_BoPhanSuDung = "https://your-api-domain.com/API/...";
  // ... các endpoint khác
}
```

### 7.2. Cấu hình ứng dụng

Mở file: `lib/constants/configs.dart`

```dart
class Config {
  static const bool isDebug = true;  // Chế độ debug
  static const int MAX_DEVICE_SUPPORT = 3;  // Số thiết bị tối đa
  // ... các config khác
}
```

### 7.3. Thêm Assets (Hình ảnh, Fonts...)

1. Thêm file vào thư mục `assets/res/images/`
2. Cập nhật `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/res/images/
    - assets/res/images/your_new_image.png
```

3. Chạy lại `flutter pub get`

### 7.4. Thêm Dependencies mới

1. Mở `pubspec.yaml`
2. Thêm package vào phần `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  your_new_package: ^1.0.0  # Thêm dòng này
```

3. Chạy:
```bash
flutter pub get
```

---

## PHẦN 8: XỬ LÝ LỖI THƯỜNG GẶP

### 8.1. Lỗi: "Unable to locate Android SDK"

**Nguyên nhân:** Flutter không tìm thấy Android SDK

**Giải pháp:**
```bash
# Đặt biến môi trường ANDROID_HOME
# Thêm vào System Environment Variables:
ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk

# Thêm vào Path:
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\tools
%ANDROID_HOME%\tools\bin
```

### 8.2. Lỗi: "Gradle sync failed"

**Giải pháp:**
```bash
# Xóa cache Gradle
cd android
.\gradlew clean
cd ..

# Hoặc xóa thư mục build
flutter clean
flutter pub get
```

### 8.3. Lỗi: "Waiting for another flutter command to release the startup lock"

**Giải pháp:**
```bash
# Xóa file lock
cd %LOCALAPPDATA%\Pub\Cache
del flutter_tools.snapshot
del flutter_tools.stamp

# Hoặc chỉ cần đợi 1-2 phút
```

### 8.4. Lỗi: Emulator không khởi động

**Giải pháp:**

1. **Kiểm tra HAXM (Intel CPU):**
```bash
# Chạy từ thư mục Android SDK
cd %ANDROID_HOME%\extras\intel\Hardware_Accelerated_Execution_Manager
.\intelhaxm-android.exe
```

2. **Bật Hyper-V (nếu dùng CPU AMD hoặc Intel mới):**
   - Mở PowerShell as Administrator
   - Chạy: `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`
   - Restart máy

3. **Tăng RAM cho AVD:**
   - Vào AVD Manager
   - Edit AVD
   - Advanced Settings → Tăng RAM lên 2048 MB hoặc cao hơn

### 8.5. Lỗi: "Exception: No connected devices"

**Giải pháp:**
```bash
# Khởi động emulator
emulator -list-avds
emulator -avd Pixel_5_API_33

# Kiểm tra kết nối
adb devices
flutter devices
```

### 8.6. Lỗi: Build failed với "Insufficient memory"

**Giải pháp:**
1. Tăng memory cho Gradle trong `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m
```

2. Hoặc build với option:
```bash
flutter build apk --split-per-abi
```

### 8.7. Lỗi: "Camera/Scanner không hoạt động trên emulator"

**Nguyên nhân:** Emulator không hỗ trợ camera thật

**Giải pháp:**
1. Sử dụng thiết bị Android thật:
   - Bật **Developer Options** và **USB Debugging** trên điện thoại
   - Kết nối qua USB
   - Chạy `flutter devices` để kiểm tra

2. Hoặc cấu hình Virtual Camera cho AVD:
   - AVD Manager → Edit AVD
   - Advanced Settings → Camera
   - Front/Back Camera → chọn "VirtualScene" hoặc "Webcam0"

### 8.8. Lỗi: "Null safety" errors

**Giải pháp:**

Project này sử dụng Dart 2.12+ với null safety. Nếu gặp lỗi:

```bash
# Migrate sang null safety
flutter pub upgrade --null-safety
dart migrate --apply-changes
```

---

## PHẦN 9: BUILD APK/APP BUNDLE

### 9.1. Build APK Debug

```bash
flutter build apk --debug
```

File APK sẽ được tạo tại: `build/app/outputs/flutter-apk/app-debug.apk`

### 9.2. Build APK Release

```bash
# Build APK release (dung lượng lớn hơn)
flutter build apk --release

# Build APK split theo ABI (khuyến nghị - dung lượng nhỏ hơn)
flutter build apk --split-per-abi
```

File APK sẽ được tạo tại:
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

### 9.3. Build App Bundle (Để upload lên Google Play)

```bash
flutter build appbundle --release
```

File sẽ được tạo tại: `build/app/outputs/bundle/release/app-release.aab`

### 9.4. Cài đặt APK lên thiết bị

```bash
# Cài đặt lên emulator hoặc thiết bị đang kết nối
flutter install

# Hoặc dùng ADB
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## PHẦN 10: TIPS VÀ TRICKS

### 10.1. Shortcuts hữu ích trong VS Code

| Phím tắt | Chức năng |
|----------|-----------|
| `F5` | Start Debugging |
| `Ctrl + F5` | Run Without Debugging |
| `Ctrl + ~` | Mở/đóng Terminal |
| `Ctrl + Shift + P` | Command Palette |
| `Ctrl + Space` | Auto-complete |
| `Ctrl + Click` | Go to definition |
| `Alt + ←/→` | Di chuyển qua lại giữa các file |
| `Ctrl + /` | Comment/Uncomment dòng |
| `Shift + Alt + F` | Format code |

### 10.2. Flutter Commands hữu ích

```bash
# Xóa build cache và rebuild lại
flutter clean
flutter pub get

# Cập nhật Flutter SDK
flutter upgrade

# Kiểm tra outdated packages
flutter pub outdated

# Upgrade packages
flutter pub upgrade

# Xem chi tiết về một package
flutter pub deps

# Chạy tests
flutter test

# Analyze code quality
flutter analyze

# Format code
flutter format lib/
```

### 10.3. ADB Commands hữu ích

```bash
# Xem danh sách thiết bị kết nối
adb devices

# Restart ADB server
adb kill-server
adb start-server

# Lấy logs từ thiết bị
adb logcat

# Screenshot
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png

# Screen recording
adb shell screenrecord /sdcard/demo.mp4
adb pull /sdcard/demo.mp4

# Uninstall app
adb uninstall com.example.qltstc_kiemke
```

### 10.4. Performance Tips

1. **Sử dụng const widgets** khi có thể:
```dart
const Text('Hello World')  // Tốt hơn
Text('Hello World')         // Bình thường
```

2. **Tránh rebuild không cần thiết** - Sử dụng GetX, Provider hoặc các state management tools

3. **Optimize images** - Sử dụng ảnh đúng kích thước và format

4. **Profile app** trước khi release:
```bash
flutter run --profile
```

5. **Sử dụng ListView.builder** thay vì ListView khi có nhiều items

### 10.5. Debugging Tips

1. **In logs:**
```dart
print('Debug message');
debugPrint('Debug message');
```

2. **Xem logs trong Terminal:**
```bash
flutter logs
```

3. **Assert trong code:**
```dart
assert(user != null, 'User should not be null');
```

4. **Try-catch để bắt lỗi:**
```dart
try {
  // code
} catch (e) {
  print('Error: $e');
}
```

---

## PHẦN 11: TÀI LIỆU THAM KHẢO

### 11.1. Official Documentation

- **Flutter:** https://flutter.dev/docs
- **Dart:** https://dart.dev/guides
- **GetX:** https://pub.dev/packages/get
- **Dio:** https://pub.dev/packages/dio
- **Mobile Scanner:** https://pub.dev/packages/mobile_scanner

### 11.2. Community Resources

- **Flutter Community:** https://flutter.dev/community
- **Stack Overflow:** https://stackoverflow.com/questions/tagged/flutter
- **Reddit:** https://www.reddit.com/r/FlutterDev/
- **GitHub:** https://github.com/flutter/flutter

### 11.3. Video Tutorials

- **Flutter Official YouTube:** https://www.youtube.com/c/flutterdev
- **Các channel tiếng Việt về Flutter trên YouTube**

---

## PHẦN 12: KẾT LUẬN

Bạn đã hoàn thành việc cài đặt và cấu hình môi trường phát triển Flutter trên Windows với Visual Studio Code. Giờ đây bạn có thể:

✅ Chạy ứng dụng QLTSTC Kiểm Kê trên Android Emulator
✅ Debug và phát triển tính năng mới
✅ Build APK để cài đặt trên thiết bị thực
✅ Sử dụng các công cụ debug và profiling
✅ Xử lý các lỗi phổ biến

### Quy trình làm việc hàng ngày:

1. Mở VS Code và project
2. Khởi động emulator hoặc kết nối thiết bị thực
3. Nhấn F5 để chạy app
4. Phát triển tính năng mới
5. Sử dụng Hot Reload (r) để xem thay đổi ngay lập tức
6. Test trên emulator/thiết bị
7. Commit code lên Git

### Liên hệ hỗ trợ:

Nếu gặp vấn đề, bạn có thể:
- Tham khảo phần "Xử lý lỗi thường gặp" ở trên
- Tìm kiếm trên Stack Overflow
- Đọc documentation của Flutter
- Hỏi trong các group Flutter Việt Nam

**Chúc bạn phát triển thành công! 🚀**

---

*Tài liệu được tạo cho project QLTSTC Kiểm Kê*
*Phiên bản: 1.0*
*Ngày cập nhật: 2026-08-10*
