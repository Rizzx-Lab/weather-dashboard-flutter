# 🔄 Perbandingan React vs Flutter - Weather Dashboard

Panduan ini menjelaskan bagaimana file React (JavaScript) diubah menjadi Flutter (Dart).

## 📊 Perbandingan Struktur

### React Project (Original)
```
weather/
├── src/
│   ├── components/
│   │   ├── AdvancedWeatherCard.jsx
│   │   ├── DraggableFavorites.tsx
│   │   ├── FavoritesCities.jsx
│   │   ├── ForecastChart.jsx
│   │   ├── LoadingSpinner.jsx
│   │   ├── PWAInstall.jsx
│   │   ├── SearchBar.jsx
│   │   ├── ThemeToggle.jsx
│   │   └── WeatherMap.jsx
│   ├── graphql/
│   ├── hooks/
│   ├── store/
│   ├── types/
│   ├── utils/
│   ├── App.jsx
│   ├── App.css
│   └── main.jsx
├── package.json
├── .env
└── node_modules/
```

### Flutter Project (Converted)
```
weather_dashboard_flutter/
├── lib/
│   ├── screens/
│   │   └── home_screen.dart
│   ├── widgets/
│   │   ├── weather_card.dart
│   │   ├── forecast_card.dart
│   │   └── search_bar.dart
│   ├── services/
│   │   ├── weather_service.dart
│   │   ├── location_service.dart
│   │   └── weather_provider.dart
│   ├── models/
│   │   ├── weather.dart
│   │   └── forecast.dart
│   └── main.dart
├── pubspec.yaml
├── .env
└── .packages
```

## 🔀 Mapping File React → Flutter

| React File | Flutter Equivalent | Keterangan |
|------------|-------------------|------------|
| `main.jsx` | `main.dart` | Entry point aplikasi |
| `App.jsx` | `home_screen.dart` | Main screen/component |
| `WeatherCard.jsx` | `weather_card.dart` | Widget kartu cuaca |
| `SearchBar.jsx` | `search_bar.dart` | Search bar widget |
| `ForecastChart.jsx` | `forecast_card.dart` | Forecast display |
| `package.json` | `pubspec.yaml` | Dependencies |
| `node_modules/` | `.packages` | Installed packages |
| `.jsx/.js` files | `.dart` files | Source code |

## 💻 Perbandingan Syntax

### 1. Import Dependencies

**React:**
```javascript
import React, { useState, useEffect } from 'react';
import axios from 'axios';
```

**Flutter:**
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
```

### 2. Component/Widget Definition

**React:**
```javascript
function WeatherCard({ weather }) {
  return (
    <div className="weather-card">
      <h2>{weather.city}</h2>
      <p>{weather.temp}°C</p>
    </div>
  );
}
```

**Flutter:**
```dart
class WeatherCard extends StatelessWidget {
  final Weather weather;
  
  const WeatherCard({Key? key, required this.weather}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(weather.city),
          Text('${weather.temp}°C'),
        ],
      ),
    );
  }
}
```

### 3. State Management

**React (useState):**
```javascript
const [weather, setWeather] = useState(null);
const [loading, setLoading] = useState(false);

const fetchWeather = async () => {
  setLoading(true);
  const data = await getWeather();
  setWeather(data);
  setLoading(false);
};
```

**Flutter (Provider):**
```dart
class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  
  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();
    
    _weather = await getWeather();
    _isLoading = false;
    notifyListeners();
  }
}
```

### 4. API Calls

**React (Axios):**
```javascript
const fetchWeather = async (city) => {
  const response = await axios.get(
    `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${API_KEY}`
  );
  return response.data;
};
```

**Flutter (HTTP):**
```dart
Future<Weather> fetchWeather(String city) async {
  final response = await http.get(
    Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey')
  );
  
  if (response.statusCode == 200) {
    return Weather.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load weather');
  }
}
```

### 5. Conditional Rendering

**React:**
```javascript
{loading ? (
  <LoadingSpinner />
) : (
  <WeatherCard weather={weather} />
)}
```

**Flutter:**
```dart
isLoading 
  ? CircularProgressIndicator()
  : WeatherCard(weather: weather)
```

### 6. Lists/Arrays

**React:**
```javascript
{forecasts.map((forecast) => (
  <ForecastCard key={forecast.id} forecast={forecast} />
))}
```

**Flutter:**
```dart
ListView.builder(
  itemCount: forecasts.length,
  itemBuilder: (context, index) {
    return ForecastCard(forecast: forecasts[index]);
  },
)
```

### 7. Styling

**React (CSS/Tailwind):**
```javascript
<div className="bg-blue-500 p-4 rounded-lg shadow-md">
  <h1 className="text-white text-2xl font-bold">Weather</h1>
</div>
```

**Flutter:**
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue.shade500,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(/* ... */)],
  ),
  child: Text(
    'Weather',
    style: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

## 🛠️ Tools & Commands

### React
```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build
```

### Flutter
```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Build for production
flutter build apk  # Android
flutter build ios  # iOS
```

## 📦 Dependencies

### React (package.json)
```json
{
  "dependencies": {
    "react": "^18.0.0",
    "axios": "^1.0.0",
    "react-router-dom": "^6.0.0"
  }
}
```

### Flutter (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  provider: ^6.1.1
```

## 🎯 Fitur Utama yang Dipertahankan

✅ **Weather Display** - Tampilan cuaca real-time
✅ **Search Functionality** - Pencarian kota
✅ **5-Day Forecast** - Forecast 5 hari
✅ **Location Detection** - Auto-detect lokasi
✅ **Responsive UI** - Tampilan responsive
✅ **Error Handling** - Penanganan error
✅ **Loading States** - Loading indicators

## 🔄 State Management

| React | Flutter | Keterangan |
|-------|---------|------------|
| useState | StatefulWidget | Local state |
| useEffect | initState/didChangeDependencies | Lifecycle |
| Context API | Provider | Global state |
| Redux | Provider/Riverpod | Advanced state |

## 🎨 UI Framework

| React | Flutter | Keterangan |
|-------|---------|------------|
| HTML/CSS | Widgets | UI Building |
| Tailwind | Material/Cupertino | Styling |
| CSS-in-JS | ThemeData | Theming |
| React Router | Navigator | Navigation |

## 📱 Development Environment

### React
- **Editor**: VS Code, WebStorm
- **Browser**: Chrome DevTools
- **Hot Reload**: Fast Refresh
- **Platform**: Web, Mobile (React Native)

### Flutter
- **Editor**: VS Code, Android Studio
- **DevTools**: Flutter DevTools
- **Hot Reload**: Hot Reload & Hot Restart
- **Platform**: Android, iOS, Web, Desktop

## 🚀 Advantages Flutter

1. **Single Codebase** - Android, iOS, Web dari 1 code
2. **Native Performance** - Compiled ke native code
3. **Rich Widgets** - Built-in Material & Cupertino
4. **Hot Reload** - Super fast development
5. **Strong Typing** - Dart is type-safe

## 💡 Tips Migration

1. **Pahami Widget Tree** - Seperti component tree di React
2. **State Management** - Provider mirip Context API
3. **Async/Await** - Sama seperti di JavaScript
4. **Null Safety** - Dart punya null safety bawaan
5. **Material Design** - Flutter follows Material closely

## 📚 Resources

- [Flutter for React Developers](https://flutter.dev/docs/get-started/flutter-for/react-native-devs)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

---

**Happy Coding! 🎉**
