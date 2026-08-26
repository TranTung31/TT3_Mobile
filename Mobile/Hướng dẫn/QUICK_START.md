# HƯỚNG DẪN NHANH - QLTSTC KIỂM KÊ

## 🚀 Khởi động nhanh (Quick Start)

### Điều kiện tiên quyết
- ✅ Đã cài Flutter SDK
- ✅ Đã cài Android Studio và SDK
- ✅ Đã cài Visual Studio Code + Flutter Extension
- ✅ Đã tạo Android Emulator

### Các bước chạy project (5 phút)

```bash
# 1. Mở Terminal trong VS Code (Ctrl + ~)

# 2. Di chuyển vào thư mục project
cd d:\Project\Android\qltstc_kiemke_new

# 3. Tải dependencies
flutter pub get

# 4. Kiểm tra thiết bị
flutter devices

# 5. Chạy ứng dụng
flutter run
```

## 📱 Quản lý Emulator

### Khởi động Emulator
```bash
# Xem danh sách emulator
emulator -list-avds

# Khởi động emulator
emulator -avd Pixel_5_API_33
```

### Hoặc từ VS Code:
- `Ctrl + Shift + P` → "Flutter: Launch Emulator"

## 🔧 Lệnh thường dùng

### Flutter Commands
```bash
flutter run              # Chạy app
flutter clean            # Xóa cache
flutter pub get          # Tải dependencies
flutter pub upgrade      # Cập nhật packages
flutter doctor           # Kiểm tra môi trường
flutter analyze          # Phân tích code
flutter build apk        # Build APK
```

### Hot Reload/Restart
- Nhấn `r` trong Terminal → Hot Reload
- Nhấn `R` trong Terminal → Hot Restart
- `Ctrl + F5` trong VS Code → Run without Debug

### Debug trong VS Code
- `F5` → Start Debugging
- `Shift + F5` → Stop Debug
- `Ctrl + Shift + F5` → Restart Debug
- Click lề trái → Đặt Breakpoint

## 🏗️ Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK (tối ưu)
flutter build apk --release

# Split APK theo ABI (dung lượng nhỏ)
flutter build apk --split-per-abi
```

APK được tạo tại: `build/app/outputs/flutter-apk/`

## ⚠️ Xử lý lỗi nhanh

### Lỗi: "No devices found"
```bash
# Khởi động lại ADB
adb kill-server
adb start-server
flutter devices
```

### Lỗi: Build failed
```bash
flutter clean
flutter pub get
flutter run
```

### Lỗi: "Waiting for another flutter command"
- Đợi 1-2 phút
- Hoặc restart VS Code

### Emulator không khởi động
- Kiểm tra RAM đủ (tối thiểu 8GB)
- Bật Virtualization trong BIOS
- Cài HAXM (Intel CPU)

## 📁 Cấu trúc Project quan trọng

```
lib/
├── main.dart                    # Entry point
├── constants/
│   ├── api_constants.dart       # API endpoints (thay đổi ở đây)
│   └── configs.dart             # App configs
├── modules/
│   ├── login/login_page.dart    # Màn hình đăng nhập
│   └── mains/main_page.dart     # Trang chủ
└── services/                    # API services
```

## 🔌 API Configuration

Thay đổi API trong: `lib/constants/api_constants.dart`

```dart
class APIConstants {
  static String LOGIN = "https://your-domain.com/API/oauth/token";
  // ... other endpoints
}
```

## 📊 Kiểm tra trạng thái

```bash
# Kiểm tra Flutter
flutter doctor -v

# Kiểm tra thiết bị
flutter devices

# Kiểm tra packages
flutter pub deps
```

## 🎯 Workflow hàng ngày

1. Mở VS Code → Mở project
2. Khởi động emulator
3. Nhấn `F5` → Chạy app
4. Viết code → Nhấn `r` (Hot Reload)
5. Test → Fix bugs
6. Commit code

## 📞 Hỗ trợ

Tham khảo file `HUONG_DAN_CAI_DAT.md` để biết hướng dẫn chi tiết.

### Các vấn đề phổ biến:
- ❌ Emulator chậm → Tăng RAM trong AVD settings
- ❌ Camera không hoạt động → Dùng thiết bị thật
- ❌ Build lỗi → Chạy `flutter clean`
- ❌ Package conflict → Xóa `pubspec.lock` và chạy `flutter pub get`

## 🔥 Hot Tips

- Sử dụng `const` widgets để tối ưu performance
- Dùng Hot Reload (`r`) thay vì Hot Restart để tiết kiệm thời gian
- Đặt breakpoint và dùng debugger thay vì `print()`
- Chạy `flutter analyze` trước khi commit code
- Backup code thường xuyên với Git

---

**Happy Coding! 🎉**
