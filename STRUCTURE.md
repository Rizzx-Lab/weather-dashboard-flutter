# 📂 Struktur Project Flutter Weather Dashboard

## 🌳 Tree Structure

```
weather_dashboard_flutter/
│
├── 📱 android/                          # Android native code
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml  # Permissions & config
│
├── 🍎 ios/                              # iOS native code (belum dibuat)
│   └── Runner/
│       └── Info.plist                   # iOS permissions
│
├── 🌐 web/                              # Web support (belum dibuat)
│   └── index.html
│
├── 📚 lib/                              # MAIN SOURCE CODE
│   │
│   ├── 📱 screens/                      # Layar/Halaman
│   │   └── home_screen.dart            # Halaman utama weather dashboard
│   │
│   ├── 🎨 widgets/                      # Komponen UI reusable
│   │   ├── weather_card.dart           # Kartu cuaca utama
│   │   ├── forecast_card.dart          # Kartu forecast per jam
│   │   └── search_bar.dart             # Search bar kota
│   │
│   ├── 🔧 services/                     # Business logic & API
│   │   ├── weather_service.dart        # API calls ke OpenWeather
│   │   ├── location_service.dart       # GPS & geocoding
│   │   └── weather_provider.dart       # State management (Provider)
│   │
│   ├── 📦 models/                       # Data models
│   │   ├── weather.dart                # Model cuaca saat ini
│   │   └── forecast.dart               # Model data forecast
│   │
│   └── 🚀 main.dart                     # Entry point aplikasi
│
├── 📄 pubspec.yaml                      # Dependencies & config
├── 📄 analysis_options.yaml             # Linting rules
├── 📄 .env                              # API keys (JANGAN COMMIT!)
├── 📄 .gitignore                        # Git ignore rules
├── 📄 README.md                         # Dokumentasi lengkap
├── 📄 QUICKSTART.md                     # Quick start guide
└── 📄 COMPARISON.md                     # React vs Flutter comparison

```

## 📋 Penjelasan File Penting

### 🚀 **main.dart** (Entry Point)
```dart
// Mulai aplikasi, setup Provider, load .env
void main() async {
  await dotenv.load();
  runApp(MyApp());
}
```
- **Fungsi**: Titik awal aplikasi
- **Tanggung jawab**: 
  - Load environment variables
  - Setup state management (Provider)
  - Define theme dan routing

---

### 📱 **screens/home_screen.dart** (Main Screen)
```dart
// Layout utama: AppBar, SearchBar, WeatherCard, Forecast
class HomeScreen extends StatefulWidget {
  // ...
}
```
- **Fungsi**: Halaman utama aplikasi
- **Contains**:
  - App Bar dengan tombol lokasi
  - Search bar
  - Weather card display
  - Forecast list
  - Loading & error states

---

### 🎨 **widgets/** (UI Components)

#### **weather_card.dart**
```dart
// Card besar menampilkan cuaca saat ini
class WeatherCard extends StatelessWidget {
  final Weather weather;
  // Shows: city, temp, icon, humidity, wind, pressure
}
```
- **Mirip dengan**: WeatherCard.jsx di React
- **Menampilkan**: Suhu, kota, deskripsi, ikon, dll

#### **forecast_card.dart**
```dart
// Card kecil untuk forecast per 3 jam
class ForecastCard extends StatelessWidget {
  final Forecast forecast;
  // Shows: time, temp, icon, humidity
}
```
- **Mirip dengan**: ForecastChart.jsx di React
- **Menampilkan**: Forecast dalam card horizontal

#### **search_bar.dart**
```dart
// TextField dengan icon search
class WeatherSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  // Callback saat user search kota
}
```
- **Mirip dengan**: SearchBar.jsx di React
- **Function**: Search city by name

---

### 🔧 **services/** (Business Logic)

#### **weather_service.dart**
```dart
// API calls ke OpenWeatherMap
class WeatherService {
  Future<Weather> getCurrentWeather(String city);
  Future<List<Forecast>> getForecast(String city);
}
```
- **Tanggung jawab**:
  - HTTP requests ke API
  - Parse JSON responses
  - Error handling

#### **location_service.dart**
```dart
// Handle GPS & permissions
class LocationService {
  Future<Position> getCurrentPosition();
  Future<String> getCityName(double lat, lon);
}
```
- **Tanggung jawab**:
  - Request location permission
  - Get GPS coordinates
  - Reverse geocoding (coords → city name)

#### **weather_provider.dart**
```dart
// State management dengan Provider
class WeatherProvider extends ChangeNotifier {
  Weather? _currentWeather;
  bool _isLoading;
  String? _error;
  
  Future<void> getWeatherByCity(String city);
  Future<void> getWeatherByLocation();
}
```
- **Mirip dengan**: Redux/Context API di React
- **Tanggung jawab**:
  - Manage app state
  - Coordinate weather & location services
  - Notify UI of changes

---

### 📦 **models/** (Data Models)

#### **weather.dart**
```dart
class Weather {
  final String cityName;
  final double temperature;
  final String description;
  // ... dan properties lainnya
  
  factory Weather.fromJson(Map<String, dynamic> json);
}
```
- **Fungsi**: Model data cuaca saat ini
- **Contains**: All weather properties dari API

#### **forecast.dart**
```dart
class Forecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  // ... properties forecast
  
  factory Forecast.fromJson(Map<String, dynamic> json);
}
```
- **Fungsi**: Model data forecast per interval
- **Contains**: Future weather predictions

---

## 🔄 Flow Data

```
1. User opens app
   ↓
2. main.dart → loads .env, starts app
   ↓
3. home_screen.dart → calls Provider
   ↓
4. weather_provider.dart → calls services
   ↓
5. location_service.dart → gets GPS coords
   ↓
6. weather_service.dart → API call with coords
   ↓
7. JSON → parsed to Weather/Forecast models
   ↓
8. Provider notifies listeners (UI updates)
   ↓
9. home_screen.dart → displays WeatherCard & ForecastCards
```

## 🎯 File Priorities untuk Belajar

Baca file dalam urutan ini untuk memahami project:

1. **pubspec.yaml** - Lihat dependencies apa saja
2. **main.dart** - Entry point, struktur app
3. **models/weather.dart** - Pahami struktur data
4. **services/weather_service.dart** - Cara fetch API
5. **services/weather_provider.dart** - State management
6. **widgets/weather_card.dart** - UI component
7. **screens/home_screen.dart** - Layout keseluruhan

## ✏️ File Mana yang Perlu Diedit?

### Untuk ubah UI/Tampilan:
- `lib/widgets/weather_card.dart`
- `lib/widgets/forecast_card.dart`
- `lib/screens/home_screen.dart`
- `lib/main.dart` (theme/colors)

### Untuk tambah fitur API:
- `lib/services/weather_service.dart`
- `lib/models/` (buat model baru)

### Untuk ubah logic/state:
- `lib/services/weather_provider.dart`

### Untuk config:
- `pubspec.yaml` (tambah package)
- `.env` (API keys)
- `android/app/src/main/AndroidManifest.xml` (permissions)

## 📝 Naming Conventions

Flutter menggunakan naming convention yang strict:

- **Files**: `snake_case.dart` (contoh: `weather_service.dart`)
- **Classes**: `PascalCase` (contoh: `WeatherCard`)
- **Variables**: `camelCase` (contoh: `currentWeather`)
- **Constants**: `lowerCamelCase` (contoh: `apiKey`)
- **Private**: `_privateName` (dengan underscore)

## 🔒 Files JANGAN Dicommit ke Git

✋ **NEVER COMMIT:**
- `.env` - Contains API keys!
- `build/` - Build artifacts
- `.dart_tool/` - Generated files
- `ios/Pods/` - iOS dependencies

✅ **SAFE TO COMMIT:**
- `.env.example` - Template tanpa keys
- `lib/**/*.dart` - Source code
- `pubspec.yaml` - Dependencies list
- `README.md` - Documentation

## 💡 Tips

1. **Hot Reload**: Tekan `r` di terminal untuk quick reload
2. **Hot Restart**: Tekan `R` untuk full restart
3. **Errors**: Cek terminal dan Debug Console
4. **Widgets**: Gunakan Flutter Inspector (VS Code)
5. **State**: Print `notifyListeners()` untuk debug

---

**Happy Coding! 🚀**
