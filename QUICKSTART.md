# 🚀 Quick Start Guide - Weather Dashboard Flutter

## Langkah Cepat untuk Mulai

### 1️⃣ Install Flutter

**Windows:**
```bash
# Download Flutter SDK dari: https://flutter.dev/docs/get-started/install/windows
# Extract ke C:\src\flutter
# Tambahkan ke PATH: C:\src\flutter\bin
```

**macOS:**
```bash
brew install flutter
```

**Linux:**
```bash
# Download dan extract Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
```

Cek instalasi:
```bash
flutter doctor
```

### 2️⃣ Install VS Code + Extensions

1. Download [VS Code](https://code.visualstudio.com/)
2. Install extensions:
   - Flutter
   - Dart
   - Flutter Widget Snippets

### 3️⃣ Setup Project

```bash
# 1. Masuk ke folder project
cd weather_dashboard_flutter

# 2. Install dependencies
flutter pub get

# 3. Buat file .env
echo "OPENWEATHER_API_KEY=your_api_key_here" > .env
```

### 4️⃣ Dapatkan API Key

1. Buka https://openweathermap.org/api
2. Sign up gratis
3. Verifikasi email
4. Copy API key dari dashboard
5. Paste ke file `.env`

### 5️⃣ Run Aplikasi

**Via VS Code:**
1. Buka folder project
2. Tekan `F5` atau klik "Run"
3. Pilih device (Android Emulator/iOS Simulator/Chrome)

**Via Terminal:**
```bash
# Android
flutter run

# iOS (Mac only)
flutter run

# Web
flutter run -d chrome
```

## 📱 Setup Device

### Android Emulator
```bash
# Buka Android Studio
# Tools > AVD Manager > Create Virtual Device
# Pilih device (misal: Pixel 4)
# Download system image
# Start emulator
```

### iOS Simulator (Mac only)
```bash
open -a Simulator
```

### Physical Device

**Android:**
1. Aktifkan Developer Options di HP
2. Aktifkan USB Debugging
3. Hubungkan via USB
4. Run: `flutter devices`

**iOS:**
1. Trust computer di iPhone
2. Buka Xcode
3. Sign dengan Apple ID
4. Run dari Xcode

## 🎯 Pertama Kali Buka

1. App akan minta permission lokasi → **Allow**
2. Cuaca lokasi kamu akan muncul otomatis
3. Coba search kota lain di search bar
4. Pull down untuk refresh

## 🔧 Perintah Berguna

```bash
# Clean build
flutter clean

# Rebuild
flutter pub get
flutter run

# Build APK
flutter build apk --release

# Check errors
flutter analyze

# Format code
flutter format .

# Update dependencies
flutter pub upgrade
```

## ❓ Troubleshooting Cepat

**Error: "No devices found"**
```bash
# Cek devices
flutter devices

# Restart ADB (Android)
adb kill-server
adb start-server
```

**Error: "Gradle sync failed"**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Error: "CocoaPods not installed" (iOS)**
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

**Error: "API key not found"**
- Pastikan file `.env` ada
- Restart app setelah edit `.env`

## 📚 Struktur File Penting

```
weather_dashboard_flutter/
├── lib/
│   ├── main.dart              ← Start here!
│   ├── screens/
│   │   └── home_screen.dart   ← Main UI
│   ├── widgets/               ← Komponen UI
│   ├── services/              ← API & Logic
│   └── models/                ← Data models
├── .env                       ← API key (WAJIB!)
├── pubspec.yaml              ← Dependencies
└── README.md                  ← Dokumentasi lengkap
```

## 🎨 Modifikasi UI

Edit file ini untuk ubah tampilan:
- `lib/widgets/weather_card.dart` - Kartu cuaca utama
- `lib/widgets/forecast_card.dart` - Kartu forecast
- `lib/screens/home_screen.dart` - Layout keseluruhan

Warna tema di `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  // Ubah Colors.blue ke warna lain!
),
```

## 🆘 Butuh Bantuan?

1. Baca [README.md](README.md) lengkap
2. Cek [Flutter Docs](https://flutter.dev/docs)
3. Buka issue di GitHub

---

**Selamat coding! 🎉**
