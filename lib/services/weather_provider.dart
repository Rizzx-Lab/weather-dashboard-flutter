import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  Weather? _currentWeather;
  List<Forecast> _forecasts = [];
  bool _isLoading = false;
  String? _error;
  String _currentCity = '';

  Weather? get currentWeather => _currentWeather;
  List<Forecast> get forecasts => _forecasts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCity => _currentCity;

  // Get weather by city name
  Future<void> getWeatherByCity(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeather(cityName);
      _forecasts = await _weatherService.getForecast(cityName);
      _currentCity = cityName;
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch weather data: ${e.toString()}';
      _currentWeather = null;
      _forecasts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get weather by current location
  Future<void> getWeatherByCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Position position = await _locationService.getCurrentPosition();
      
      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      
      _forecasts = await _weatherService.getForecastByCoordinates(
        position.latitude,
        position.longitude,
      );

      _currentCity = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );
      
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch weather data: ${e.toString()}';
      _currentWeather = null;
      _forecasts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh weather data
  Future<void> refreshWeather() async {
    if (_currentCity.isNotEmpty) {
      await getWeatherByCity(_currentCity);
    } else {
      await getWeatherByCurrentLocation();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
