# CHECKLIST XỬ LÝ SỰ CỐ - QLTSTC KIỂM KÊ

## ✅ CHECKLIST CÀI ĐẶT BAN ĐẦU

Trước khi chạy project, hãy đảm bảo:

### 1. Flutter SDK
```bash
flutter --version
# ✅ Phải hiển thị Flutter version 2.12.0 trở lên
```

### 2. Android SDK
```bash
flutter doctor
# ✅ [✓] Android toolchain - develop for Android devices
# ❌ Nếu có [✗] → Cài đặt Android Studio và SDK
```

### 3. VS Code Extensions
- ✅ Flutter extension đã cài
- ✅ Dart extension đã cài

### 4. Emulator
```bash
emulator -list-avds
# ✅ Phải hiển thị ít nhất 1 AVD
```

### 5. Project Dependencies
```bash
cd d:\Project\Android\qltstc_kiemke_new
flutter pub get
# ✅ Không có lỗi, tất cả packages tải thành công
```

---

## 🔍 CHẨN ĐOÁN SỰ CỐ

### Sự cố 1: "Flutter command not found"

**Triệu chứng:**
```bash
flutter
# 'flutter' is not recognized as an internal or external command
```

**Nguyên nhân:** Flutter chưa được thêm vào PATH

**Giải pháp:**
1. ✅ Kiểm tra Flutter đã cài: Tìm thư mục `flutter\bin`
2. ✅ Thêm vào Environment Variables:
   - Windows + R → `sysdm.cpl`
   - Advanced → Environment Variables
   - Edit Path → Add `C:\src\flutter\bin`
3. ✅ Mở lại Terminal/CMD mới
4. ✅ Test: `flutter --version`

---

### Sự cố 2: "Android SDK not found"

**Triệu chứng:**
```bash
flutter doctor
# [✗] Android toolchain - Unable to locate Android SDK
```

**Giải pháp:**
```bash
# 1. Tìm đường dẫn Android SDK (thường ở):
# C:\Users\<YourName>\AppData\Local\Android\Sdk

# 2. Đặt biến môi trường ANDROID_HOME
# System Environment Variables:
ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk

# 3. Thêm vào Path:
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\tools
%ANDROID_HOME%\cmdline-tools\latest\bin

# 4. Chạy lại
flutter doctor --android-licenses
# Nhấn 'y' để đồng ý tất cả
```

---

### Sự cố 3: "No devices found"

**Triệu chứng:**
```bash
flutter devices
# No devices detected
```

**Checklist giải quyết:**

#### 3.1. Kiểm tra Emulator
```bash
# Xem danh sách AVD
emulator -list-avds

# Nếu rỗng → Tạo AVD mới:
# - Mở Android Studio
# - Tools → AVD Manager → Create Virtual Device
```

#### 3.2. Khởi động Emulator
```bash
# Khởi động emulator
emulator -avd <tên-avd>

# Đợi 2-3 phút cho emulator khởi động hoàn toàn
```

#### 3.3. Kiểm tra ADB
```bash
# Khởi động lại ADB
adb kill-server
adb start-server

# Kiểm tra thiết bị
adb devices
# ✅ Phải thấy: emulator-5554  device
```

#### 3.4. Kiểm tra lại
```bash
flutter devices
# ✅ Phải thấy emulator trong danh sách
```

---

### Sự cố 4: Build failed / Gradle errors

**Triệu chứng:**
```
BUILD FAILED
Gradle build failed
```

**Giải pháp từng bước:**

#### Bước 1: Clean project
```bash
flutter clean
rm -rf build/
flutter pub get
```

#### Bước 2: Clean Gradle cache (nếu có thư mục android/)
```bash
cd android
.\gradlew clean
cd ..
```

#### Bước 3: Xóa Gradle cache global
```bash
# Xóa thư mục (nếu tồn tại):
%USERPROFILE%\.gradle\caches
```

#### Bước 4: Chạy lại
```bash
flutter run
```

---

### Sự cố 5: "Waiting for another flutter command to release the startup lock"

**Triệu chứng:**
Lệnh Flutter bị treo

**Giải pháp nhanh:**

#### Option 1: Đợi
- ⏱️ Đợi 2-3 phút, lock sẽ tự release

#### Option 2: Force unlock
```bash
# Xóa file lock
cd %LOCALAPPDATA%\Pub\Cache
del flutter_tools.snapshot
del flutter_tools.stamp
```

#### Option 3: Restart
- Đóng tất cả Terminal
- Đóng VS Code
- Mở lại và thử lại

---

### Sự cố 6: Emulator chậm hoặc lag

**Triệu chứng:**
Emulator khởi động lâu, chạy app rất chậm

**Kiểm tra và giải quyết:**

#### 6.1. Kiểm tra RAM
```bash
# Yêu cầu: Ít nhất 8GB RAM hệ thống
# Emulator nên có: 2048 MB RAM trở lên
```

✅ **Tăng RAM cho AVD:**
1. AVD Manager → Edit AVD
2. Show Advanced Settings
3. RAM: 2048 MB hoặc hơn
4. VM Heap: 256 MB

#### 6.2. Bật Hardware Acceleration

**Cho Intel CPU:**
```bash
# Cài Intel HAXM
cd %ANDROID_HOME%\extras\intel\Hardware_Accelerated_Execution_Manager
.\intelhaxm-android.exe
```

**Cho AMD CPU hoặc Intel mới:**
```powershell
# Bật Hyper-V (chạy PowerShell as Admin)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
# Restart máy
```

#### 6.3. Kiểm tra BIOS
- ✅ Virtualization Technology (VT-x/AMD-V) phải ENABLED
- Khởi động lại máy → Vào BIOS → Tìm và bật VT-x hoặc AMD-V

---

### Sự cố 7: Camera/Scanner không hoạt động

**Triệu chứng:**
Mobile Scanner không quét được QR code trên emulator

**Nguyên nhân:** 
Emulator không hỗ trợ camera thực tế tốt

**Giải pháp khuyến nghị:**

#### Option 1: Dùng thiết bị Android thật (Best!)
```bash
# 1. Bật Developer Options trên điện thoại:
#    - Settings → About Phone
#    - Tap "Build Number" 7 lần

# 2. Bật USB Debugging:
#    - Settings → Developer Options
#    - Enable "USB Debugging"

# 3. Kết nối USB với máy tính

# 4. Cho phép debugging trên điện thoại

# 5. Kiểm tra
adb devices
# ✅ Phải thấy điện thoại trong danh sách

# 6. Chạy app
flutter run
```

#### Option 2: Cấu hình Virtual Camera cho AVD
1. AVD Manager → Edit AVD
2. Show Advanced Settings → Camera
3. Front Camera: VirtualScene
4. Back Camera: VirtualScene hoặc Webcam0

**Lưu ý:** Vẫn có thể không hoạt động tốt với QR Scanner

---

### Sự cố 8: Pub get failed / Package conflicts

**Triệu chứng:**
```
version solving failed
package has incompatible dependencies
```

**Giải pháp:**

#### Bước 1: Xóa lock file
```bash
del pubspec.lock
flutter pub get
```

#### Bước 2: Downgrade packages
Mở `pubspec.yaml`, thử giảm version của package gây lỗi:
```yaml
# Thay vì:
some_package: ^2.0.0

# Thử:
some_package: ^1.9.0
```

#### Bước 3: Check compatibility
```bash
flutter pub outdated
# Xem packages nào outdated hoặc incompatible
```

---

### Sự cố 9: Hot Reload không hoạt động

**Triệu chứng:**
Nhấn `r` nhưng thay đổi không xuất hiện

**Giải pháp:**

#### Thử Hot Restart:
```bash
# Nhấn 'R' (chữ hoa) trong Terminal
# Hoặc trong VS Code: Hot Restart button
```

#### Các trường hợp cần Restart:
- ✅ Thêm package mới
- ✅ Thay đổi code trong main()
- ✅ Thay đổi assets
- ✅ Thay đổi native code (Android/iOS)

#### Nếu vẫn không work:
```bash
# Stop app → Clean → Run lại
flutter clean
flutter pub get
flutter run
```

---

### Sự cố 10: "Insufficient memory" khi build

**Triệu chứng:**
```
Out of memory error
Insufficient memory for the Java Runtime Environment
```

**Giải pháp:**

#### Nếu có thư mục android/:
Tạo/sửa file `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2048m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
org.gradle.parallel=true
org.gradle.daemon=true
```

#### Build với options:
```bash
# Build split APK (nhẹ hơn)
flutter build apk --split-per-abi

# Build release mode
flutter build apk --release
```

---

## 🆘 KHI MỌI CÁCH ĐỀU THẤT BẠI

### Nuclear Option: Reset mọi thứ

```bash
# 1. Clean Flutter
flutter clean

# 2. Xóa cache
flutter pub cache repair

# 3. Xóa lock file
del pubspec.lock

# 4. Get lại packages
flutter pub get

# 5. Restart ADB
adb kill-server
adb start-server

# 6. Khởi động lại emulator

# 7. Run lại
flutter run
```

### Nếu vẫn không được:

```bash
# Reinstall Flutter
# 1. Xóa thư mục flutter cũ
# 2. Tải Flutter mới
# 3. Giải nén và setup lại PATH
# 4. flutter doctor
# 5. flutter doctor --android-licenses
```

---

## 📋 CHECKLIST TRƯỚC KHI HỎI HỖ TRỢ

Khi gặp lỗi và cần hỗ trợ, hãy cung cấp:

### 1. Thông tin hệ thống
```bash
flutter doctor -v
# Copy toàn bộ output
```

### 2. Thông tin lỗi
- ✅ Full error message (đầy đủ)
- ✅ Stack trace (nếu có)
- ✅ Bước đã thử để fix

### 3. Thông tin project
```bash
# Flutter version
flutter --version

# Check pubspec.yaml
cat pubspec.yaml

# Check devices
flutter devices
```

### 4. Screenshots
- Chụp màn hình lỗi
- Chụp terminal output
- Chụp emulator (nếu liên quan UI)

---

## 🎯 KIỂM TRA SAU KHI FIX

Sau khi fix lỗi, verify mọi thứ hoạt động:

```bash
# 1. Doctor check
flutter doctor
# ✅ Không có [✗]

# 2. Devices check
flutter devices
# ✅ Thấy emulator hoặc thiết bị

# 3. Run app
flutter run
# ✅ App chạy thành công

# 4. Hot Reload test
# Thay đổi code → Nhấn 'r'
# ✅ Thay đổi xuất hiện ngay

# 5. Build test
flutter build apk --debug
# ✅ Build thành công
```

---

## 📚 TÀI LIỆU THAM KHẢO

- 📖 Hướng dẫn chi tiết: `HUONG_DAN_CAI_DAT.md`
- 🚀 Quick start: `QUICK_START.md`
- 🌐 Flutter Docs: https://flutter.dev/docs
- ❓ Flutter Issues: https://github.com/flutter/flutter/issues

---

**Tip:** Lưu file này để tham khảo nhanh khi gặp sự cố! 💡
