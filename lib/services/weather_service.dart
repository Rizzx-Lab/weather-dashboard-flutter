import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';
  late final String apiKey;

  WeatherService() {
    apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  }

  // Get current weather by city name
  Future<Weather> getCurrentWeather(String cityName) async {
    final url = Uri.parse(
      '$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Get current weather by coordinates
  Future<Weather> getCurrentWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Get 5-day forecast
  Future<List<Forecast>> getForecast(String cityName) async {
    final url = Uri.parse(
      '$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> forecastList = data['list'];
      
      return forecastList.map((item) => Forecast.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  // Get 5-day forecast by coordinates
  Future<List<Forecast>> getForecastByCoordinates(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> forecastList = data['list'];
      
      return forecastList.map((item) => Forecast.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
