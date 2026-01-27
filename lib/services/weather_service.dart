import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String geoUrl = 'https://api.openweathermap.org/geo/1.0';

  // Current Weather
  Future<WeatherData> getCurrentWeather(double lat, double lon) async {
    final url = '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Get weather by city name
  Future<WeatherData> getWeatherByCity(String cityName) async {
    final url = '$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Hourly Forecast (from 5-day/3-hour forecast)
  Future<List<HourlyForecast>> getHourlyForecast(double lat, double lon) async {
    final url = '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];
      
      // Get next 24 hours (8 items * 3 hours = 24 hours)
      return list
          .take(8)
          .map((item) => HourlyForecast.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  // 5-Day Daily Forecast
  Future<List<DailyForecast>> getDailyForecast(double lat, double lon) async {
    final url = '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];

      // Group by day and get one forecast per day (at noon)
      Map<String, List<dynamic>> groupedByDay = {};
      
      for (var item in list) {
        final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final dayKey = '${date.year}-${date.month}-${date.day}';
        
        if (!groupedByDay.containsKey(dayKey)) {
          groupedByDay[dayKey] = [];
        }
        groupedByDay[dayKey]!.add(item);
      }

      // Get forecast for each day (prefer noon time ~12:00)
      List<DailyForecast> dailyForecasts = [];
      
      groupedByDay.forEach((day, forecasts) {
        // Find forecast closest to noon
        var noonForecast = forecasts.reduce((a, b) {
          final aTime = DateTime.fromMillisecondsSinceEpoch(a['dt'] * 1000);
          final bTime = DateTime.fromMillisecondsSinceEpoch(b['dt'] * 1000);
          final aDiff = (aTime.hour - 12).abs();
          final bDiff = (bTime.hour - 12).abs();
          return aDiff < bDiff ? a : b;
        });

        // Calculate min/max temp for the day
        double tempMin = forecasts
            .map((f) => f['main']['temp_min'].toDouble())
            .reduce((a, b) => a < b ? a : b);
        double tempMax = forecasts
            .map((f) => f['main']['temp_max'].toDouble())
            .reduce((a, b) => a > b ? a : b);

        dailyForecasts.add(DailyForecast(
          date: DateTime.fromMillisecondsSinceEpoch(noonForecast['dt'] * 1000),
          tempMin: tempMin,
          tempMax: tempMax,
          icon: noonForecast['weather'][0]['icon'],
          description: noonForecast['weather'][0]['description'],
          humidity: noonForecast['main']['humidity'],
          windSpeed: noonForecast['wind']['speed'].toDouble(),
          pop: ((noonForecast['pop'] ?? 0) * 100).toInt(),
        ));
      });

      return dailyForecasts.take(5).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  // Air Quality
  Future<AirQuality> getAirQuality(double lat, double lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return AirQuality.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load air quality data');
    }
  }

  // Search Cities
  Future<List<SavedLocation>> searchCities(String query) async {
    if (query.isEmpty) return [];

    final url = '$geoUrl/direct?q=$query&limit=5&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((city) {
        return SavedLocation(
          name: city['name'],
          lat: city['lat'],
          lon: city['lon'],
          country: city['country'],
        );
      }).toList();
    } else {
      return [];
    }
  }

  // Reverse Geocoding - Get city name from coordinates
  Future<String> getCityName(double lat, double lon) async {
    final url = '$geoUrl/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data[0]['name'] ?? 'Unknown';
      }
    }
    return 'Unknown';
  }
}