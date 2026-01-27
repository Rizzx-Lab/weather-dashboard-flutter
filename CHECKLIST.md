# ✅ Checklist Instalasi Weather Dashboard Flutter

Gunakan checklist ini untuk memastikan semua langkah setup sudah benar.

## 🎯 Phase 1: Prerequisites

### Flutter SDK
- [ ] Download Flutter SDK dari https://flutter.dev/docs/get-started/install
- [ ] Extract ke folder (misal: `C:\src\flutter` atau `~/flutter`)
- [ ] Tambahkan Flutter ke PATH
- [ ] Run `flutter --version` di terminal (harus sukses)
- [ ] Run `flutter doctor` dan cek hasilnya

### VS Code / Android Studio
- [ ] Install VS Code dari https://code.visualstudio.com/
- [ ] Install Flutter extension di VS Code
- [ ] Install Dart extension di VS Code
- [ ] (Optional) Install Android Studio untuk emulator

### Android Development (untuk Android)
- [ ] Install Android Studio atau Android SDK
- [ ] Install Android SDK via Android Studio
- [ ] Install Android Emulator
- [ ] Accept Android licenses: `flutter doctor --android-licenses`

### iOS Development (Mac only)
- [ ] Install Xcode dari App Store
- [ ] Install Xcode Command Line Tools: `xcode-select --install`
- [ ] Open Xcode dan accept license
- [ ] Install CocoaPods: `sudo gem install cocoapods`

---

## 🎯 Phase 2: Project Setup

### Download Project
- [ ] Extract file `weather_dashboard_flutter.zip`
- [ ] Atau clone dari Git (jika ada)
- [ ] Buka folder project di VS Code

### Install Dependencies
```bash
cd weather_dashboard_flutter
flutter pub get
```
- [ ] Command `flutter pub get` berhasil
- [ ] Tidak ada error merah
- [ ] File `.packages` terbuat

### Setup API Key
- [ ] Daftar di https://openweathermap.org/api
- [ ] Verifikasi email
- [ ] Copy API key dari dashboard
- [ ] Buat file `.env` di root project
- [ ] Paste: `OPENWEATHER_API_KEY=your_key_here`
- [ ] Save file `.env`

### Verify .env File
```bash
# File .env harus berisi:
OPENWEATHER_API_KEY=your_actual_api_key_here
```
- [ ] File `.env` ada di root folder
- [ ] API key sudah diisi (bukan `your_api_key_here`)
- [ ] Tidak ada spasi sebelum/sesudah `=`
- [ ] Tidak ada quotes di sekitar API key

---

## 🎯 Phase 3: Platform Setup

### Android Permissions (untuk Android)
File: `android/app/src/main/AndroidManifest.xml`

- [ ] Ada permission: `<uses-permission android:name="android.permission.INTERNET"/>`
- [ ] Ada permission: `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>`
- [ ] Ada permission: `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>`

### iOS Permissions (untuk iOS - Mac only)
File: `ios/Runner/Info.plist`

- [ ] Ada: `NSLocationWhenInUseUsageDescription`
- [ ] Ada: `NSLocationAlwaysUsageDescription`
- [ ] Run: `cd ios && pod install && cd ..`

---

## 🎯 Phase 4: Device Setup

### Option A: Android Emulator
- [ ] Buka Android Studio
- [ ] Tools → AVD Manager
- [ ] Create Virtual Device
- [ ] Choose device (ex: Pixel 4)
- [ ] Download system image (ex: Android 13)
- [ ] Start emulator
- [ ] Run `flutter devices` (emulator harus terlihat)

### Option B: iOS Simulator (Mac only)
- [ ] Run: `open -a Simulator`
- [ ] Pilih device dari menu Hardware
- [ ] Run `flutter devices` (simulator harus terlihat)

### Option C: Physical Device

**Android:**
- [ ] Enable Developer Options di HP
- [ ] Enable USB Debugging
- [ ] Connect HP via USB
- [ ] Allow USB debugging di HP
- [ ] Run `flutter devices` (HP harus terlihat)

**iOS:**
- [ ] Connect iPhone via USB
- [ ] Trust computer di iPhone
- [ ] Run `flutter devices` (iPhone harus terlihat)

---

## 🎯 Phase 5: First Run

### Test Run
```bash
flutter run
```

Checklist:
- [ ] Command `flutter run` tidak error
- [ ] Build berhasil (tunggu 2-5 menit first build)
- [ ] App terbuka di device/emulator
- [ ] Tidak ada error di console

### Test Features
- [ ] App meminta permission lokasi → **Allow**
- [ ] Cuaca lokasi kamu muncul (atau error jika GPS off)
- [ ] Search bar bisa diklik
- [ ] Search kota (contoh: "Jakarta") → cuaca muncul
- [ ] Forecast cards muncul di bawah
- [ ] Pull down untuk refresh → loading indicator muncul
- [ ] Klik icon lokasi di app bar → cuaca update

---

## 🎯 Phase 6: Hot Reload Test

### Test Hot Reload
1. App harus running
2. Edit file `lib/main.dart`
3. Ubah warna: `seedColor: Colors.blue` → `seedColor: Colors.red`
4. Save file
5. Di terminal, tekan `r` (lowercase)

Checklist:
- [ ] Warna app berubah dalam 1-2 detik
- [ ] App tidak restart penuh
- [ ] Data tetap ada (tidak reset)

### Test Hot Restart
1. Di terminal, tekan `R` (uppercase)

Checklist:
- [ ] App restart penuh
- [ ] Data reset ke awal
- [ ] Butuh waktu lebih lama dari hot reload

---

## 🎯 Phase 7: Debugging Test

### Test Debugging
1. Buka `lib/screens/home_screen.dart`
2. Klik di sebelah kiri line number untuk set breakpoint
3. Tekan `F5` di VS Code (atau klik Run → Start Debugging)
4. App akan pause di breakpoint

Checklist:
- [ ] Breakpoint bisa di-set (red dot muncul)
- [ ] App pause di breakpoint
- [ ] Variables terlihat di Debug sidebar
- [ ] Bisa continue/step over dengan buttons

---

## 🎯 Phase 8: Build Test (Optional)

### Build APK (Android)
```bash
flutter build apk --release
```
- [ ] Command berhasil tanpa error
- [ ] APK terbuat di: `build/app/outputs/flutter-apk/app-release.apk`
- [ ] APK bisa di-install di Android (test jika mau)

### Build iOS (Mac only)
```bash
flutter build ios --release
```
- [ ] Command berhasil
- [ ] Build sukses

---

## 🎯 Final Checks

### Code Quality
```bash
flutter analyze
```
- [ ] Tidak ada critical errors
- [ ] (Warning/info boleh ada)

### Tests
```bash
flutter test
```
- [ ] All tests pass (jika ada tests)

### Clean Build
```bash
flutter clean
flutter pub get
flutter run
```
- [ ] Semua command sukses
- [ ] App masih jalan normal

---

## 🐛 Common Issues & Solutions

### ❌ "flutter: command not found"
**Solution:**
```bash
# Add to PATH
export PATH="$PATH:/path/to/flutter/bin"
# atau di Windows tambahkan ke System Environment Variables
```

### ❌ "No devices found"
**Solution:**
- Pastikan emulator/device running
- Run: `flutter devices`
- Restart ADB: `adb kill-server && adb start-server`

### ❌ "Gradle build failed"
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### ❌ "API key not found" saat runtime
**Solution:**
- Pastikan file `.env` ada
- Pastikan `OPENWEATHER_API_KEY` ada di `.env`
- Restart app (hot reload tidak cukup untuk .env)
- Hot restart dengan `R` di terminal

### ❌ "Location permission denied"
**Solution:**
- Buka Settings HP
- Cari app "Weather Dashboard"
- Allow Location permission
- Restart app

### ❌ "Failed to load weather data"
**Solution:**
- Cek internet connection
- Cek API key valid
- Cek API key belum expire
- Coba kota lain (misal: "Jakarta", "Tokyo")

---

## ✅ Success Criteria

Kamu berhasil jika:

- [x] `flutter doctor` menunjukkan ✓ di Flutter, Android, VS Code
- [x] `flutter run` bisa jalankan app
- [x] App bisa fetch cuaca (dari lokasi atau search)
- [x] Hot reload bekerja (tekan `r`)
- [x] Bisa debug dengan breakpoint
- [x] Tidak ada error merah di console

---

## 🎉 Selamat!

Jika semua checklist sudah ✅, kamu sudah berhasil setup Flutter Weather Dashboard!

Next steps:
1. Baca `README.md` untuk fitur lengkap
2. Baca `STRUCTURE.md` untuk memahami kode
3. Baca `COMPARISON.md` untuk memahami perbedaan dengan React
4. Start coding! 🚀

---

Need help? Check:
- `QUICKSTART.md` untuk quick reference
- `VSCODE_SETUP.md` untuk VS Code tips
- GitHub Issues untuk tanya masalah

**Happy Coding! 💙**
