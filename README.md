# Weather Dashboard Flutter

Weather Dashboard aplikasi mobile yang dibuat dengan Flutter untuk menampilkan cuaca real-time dari OpenWeatherMap API.

## 📱 Screenshots

![Weather Dashboard](https://via.placeholder.com/400x800?text=Weather+Dashboard)

## ✨ Fitur

- 🌤️ Cuaca real-time berdasarkan lokasi
- 🔍 Pencarian kota
- 📊 Forecast 5 hari
- 📍 Deteksi lokasi otomatis
- 🔄 Pull to refresh
- 🎨 UI yang clean dan modern

## 🛠️ Teknologi

- **Flutter** - Framework UI
- **Provider** - State management
- **OpenWeather API** - Data cuaca
- **Geolocator** - Lokasi GPS
- **Google Fonts** - Typography

## 📋 Prerequisites

Sebelum mulai, pastikan kamu sudah install:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.0.0 atau lebih baru)
- [Android Studio](https://developer.android.com/studio) atau [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)
- API Key dari [OpenWeatherMap](https://openweathermap.org/api)

## 🚀 Cara Install

### 1. Clone Repository

```bash
git clone https://github.com/your-username/weather-dashboard-flutter.git
cd weather-dashboard-flutter
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Setup API Key

Buat file `.env` di root folder project:

```bash
cp .env.example .env
```

Edit file `.env` dan masukkan API key kamu:

```env
OPENWEATHER_API_KEY=your_api_key_here
```

**Cara mendapatkan API Key:**
1. Daftar di [OpenWeatherMap](https://openweathermap.org/api)
2. Verifikasi email kamu
3. Copy API key dari dashboard
4. Paste ke file `.env`

### 4. Setup Permissions

#### Android

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
    <!-- Tambahkan permissions ini -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    
    <application ...>
        ...
    </application>
</manifest>
```

#### iOS

Edit `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Tambahkan keys ini -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs access to location to show weather data.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app needs access to location to show weather data.</string>
</dict>
```

### 5. Run Aplikasi

#### Untuk Android:
```bash
flutter run
```

#### Untuk iOS (Mac only):
```bash
cd ios
pod install
cd ..
flutter run
```

#### Untuk Web:
```bash
flutter run -d chrome
```

## 📁 Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/
│   ├── weather.dart         # Model data cuaca
│   └── forecast.dart        # Model data forecast
├── services/
│   ├── weather_service.dart    # API service
│   ├── location_service.dart   # Location service
│   └── weather_provider.dart   # State management
├── screens/
│   └── home_screen.dart        # Main screen
└── widgets/
    ├── weather_card.dart       # Widget kartu cuaca
    ├── forecast_card.dart      # Widget kartu forecast
    └── search_bar.dart         # Widget search bar
```

## 🎯 Cara Pakai

1. **Menggunakan Lokasi Saat Ini:**
   - Tap icon lokasi di app bar
   - Izinkan akses lokasi
   - Cuaca akan ditampilkan otomatis

2. **Mencari Kota:**
   - Ketik nama kota di search bar
   - Tekan Enter atau tombol search
   - Cuaca kota tersebut akan ditampilkan

3. **Refresh Data:**
   - Pull down dari atas untuk refresh

## 🔧 Development

### Build APK (Android)

```bash
flutter build apk --release
```

APK akan tersimpan di: `build/app/outputs/flutter-apk/app-release.apk`

### Build iOS

```bash
flutter build ios --release
```

### Run Tests

```bash
flutter test
```

## 📝 Konfigurasi VS Code

Install extensions berikut di VS Code:
- Flutter
- Dart
- Flutter Widget Snippets

Setting `.vscode/settings.json`:

```json
{
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.rulers": [80]
}
```

## 🐛 Troubleshooting

### Error: "API key not found"
- Pastikan file `.env` ada di root folder
- Pastikan format di `.env` benar: `OPENWEATHER_API_KEY=your_key`
- Restart aplikasi setelah edit `.env`

### Error: Location permission denied
- Buka Settings HP
- Cari aplikasi Weather Dashboard
- Aktifkan permission Location

### Error: "Failed to load weather data"
- Cek koneksi internet
- Pastikan API key valid
- Coba kota lain

## 📱 Tested On

- ✅ Android 10+
- ✅ iOS 14+
- ✅ Web (Chrome, Firefox, Safari)

## 🤝 Contributing

Pull requests welcome! Untuk perubahan besar, buka issue terlebih dahulu.

## 📄 License

MIT License - lihat file [LICENSE](LICENSE) untuk detail.

## 👨‍💻 Author

**Your Name**
- GitHub: [@your-username](https://github.com/your-username)

## 🙏 Credits

- [OpenWeatherMap](https://openweathermap.org/) untuk API
- [Flutter](https://flutter.dev/) untuk framework
- Icons dari [Material Icons](https://material.io/icons)

## 📞 Support

Jika ada pertanyaan atau masalah:
- Buka [Issue](https://github.com/your-username/weather-dashboard-flutter/issues)
- Email: your.email@example.com

---

Made with ❤️ and Flutter
