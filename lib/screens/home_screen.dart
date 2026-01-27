import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../widgets/weather_icon.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_card.dart';
import '../widgets/air_quality_card.dart';
import 'search_screen.dart';
import 'map_screen.dart';
import 'saved_locations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  WeatherData? _currentWeather;
  List<HourlyForecast> _hourlyForecast = [];
  List<DailyForecast> _dailyForecast = [];
  AirQuality? _airQuality;
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
    _loadWeather();
  }

  Future<void> _loadDarkMode() async {
    final darkMode = await _storageService.getDarkMode();
    setState(() {
      _isDarkMode = darkMode;
    });
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Try to get current location
      final position = await _locationService.getCurrentLocation();
      
      double lat, lon;
      
      if (position != null) {
        lat = position.latitude;
        lon = position.longitude;
        await _storageService.saveLastLocation(lat, lon);
      } else {
        // Try to load last location
        final lastLoc = await _storageService.getLastLocation();
        if (lastLoc != null) {
          lat = lastLoc['lat']!;
          lon = lastLoc['lon']!;
        } else {
          // Default to Surabaya if no location available
          lat = -7.2575;
          lon = 112.7521;
        }
      }

      // Load all weather data
      final weather = await _weatherService.getCurrentWeather(lat, lon);
      final hourly = await _weatherService.getHourlyForecast(lat, lon);
      final daily = await _weatherService.getDailyForecast(lat, lon);
      final airQuality = await _weatherService.getAirQuality(lat, lon);

      setState(() {
        _currentWeather = weather;
        _hourlyForecast = hourly;
        _dailyForecast = daily;
        _airQuality = airQuality;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherForLocation(double lat, double lon) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.getCurrentWeather(lat, lon);
      final hourly = await _weatherService.getHourlyForecast(lat, lon);
      final daily = await _weatherService.getDailyForecast(lat, lon);
      final airQuality = await _weatherService.getAirQuality(lat, lon);

      await _storageService.saveLastLocation(lat, lon);

      setState(() {
        _currentWeather = weather;
        _hourlyForecast = hourly;
        _dailyForecast = daily;
        _airQuality = airQuality;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather data';
        _isLoading = false;
      });
    }
  }

  void _toggleDarkMode() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await _storageService.setDarkMode(_isDarkMode);
  }

  Future<void> _toggleFavorite() async {
    if (_currentWeather == null) return;

    final isSaved = await _storageService.isLocationSaved(
      _currentWeather!.lat,
      _currentWeather!.lon,
    );

    if (isSaved) {
      await _storageService.removeLocation(SavedLocation(
        name: _currentWeather!.cityName,
        lat: _currentWeather!.lat,
        lon: _currentWeather!.lon,
        country: '',
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location removed from favorites')),
      );
    } else {
      await _storageService.addLocation(SavedLocation(
        name: _currentWeather!.cityName,
        lat: _currentWeather!.lat,
        lon: _currentWeather!.lon,
        country: '',
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location added to favorites')),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDarkMode;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFF87CEEB);
    final cardColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: _loadWeather,
                  color: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      _buildAppBar(isDark, textColor),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCurrentWeather(isDark, cardColor, textColor),
                              const SizedBox(height: 24),
                              _buildAirQuality(cardColor, textColor),
                              const SizedBox(height: 24),
                              _buildHourlyForecast(cardColor, textColor),
                              const SizedBox(height: 24),
                              _buildDailyForecast(cardColor, textColor),
                              const SizedBox(height: 24),
                              _buildWeatherDetails(cardColor, textColor),
                              const SizedBox(height: 250),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'map',
            onPressed: () {
              if (_currentWeather != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      lat: _currentWeather!.lat,
                      lon: _currentWeather!.lon,
                    ),
                  ),
                );
              }
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.map, color: Colors.blue),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'favorite',
            onPressed: _toggleFavorite,
            backgroundColor: Colors.white,
            child: FutureBuilder<bool>(
              future: _currentWeather != null
                  ? _storageService.isLocationSaved(
                      _currentWeather!.lat, _currentWeather!.lon)
                  : Future.value(false),
              builder: (context, snapshot) {
                final isSaved = snapshot.data ?? false;
                return Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isDark, Color textColor) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _currentWeather?.cityName ?? 'Weather Dashboard',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      actions: [
        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: textColor),
          onPressed: _toggleDarkMode,
        ),
        IconButton(
          icon: Icon(Icons.bookmarks, color: textColor),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SavedLocationsScreen(),
              ),
            );
            if (result != null && result is SavedLocation) {
              _loadWeatherForLocation(result.lat, result.lon);
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.search, color: textColor),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
            if (result != null && result is SavedLocation) {
              _loadWeatherForLocation(result.lat, result.lon);
            }
          },
        ),
      ],
    );
  }

  Widget _buildCurrentWeather(bool isDark, Color cardColor, Color textColor) {
    if (_currentWeather == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF2D2D2D), const Color(0xFF1E1E1E)]
              : [const Color(0xFF87CEEB), const Color(0xFF4A90E2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, MMM d').format(DateTime.now()),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_currentWeather!.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _currentWeather!.description.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Feels like ${_currentWeather!.feelsLike.round()}°C',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              WeatherIcon(
                icon: _currentWeather!.icon,
                size: 120,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherStat(
                Icons.arrow_upward,
                '${_currentWeather!.tempMax.round()}°',
                'High',
              ),
              _buildWeatherStat(
                Icons.arrow_downward,
                '${_currentWeather!.tempMin.round()}°',
                'Low',
              ),
              _buildWeatherStat(
                Icons.water_drop,
                '${_currentWeather!.humidity}%',
                'Humidity',
              ),
              _buildWeatherStat(
                Icons.air,
                '${_currentWeather!.windSpeed.toStringAsFixed(1)} m/s',
                'Wind',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAirQuality(Color cardColor, Color textColor) {
    if (_airQuality == null) return const SizedBox();

    return AirQualityCard(
      airQuality: _airQuality!,
      cardColor: cardColor,
      textColor: textColor,
    );
  }

  Widget _buildHourlyForecast(Color cardColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _hourlyForecast.length,
            itemBuilder: (context, index) {
              return HourlyForecastCard(
                forecast: _hourlyForecast[index],
                cardColor: cardColor,
                textColor: textColor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast(Color cardColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5-Day Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        ..._dailyForecast.map((forecast) {
          return DailyForecastCard(
            forecast: forecast,
            cardColor: cardColor,
            textColor: textColor,
          );
        }),
      ],
    );
  }

  Widget _buildWeatherDetails(Color cardColor, Color textColor) {
    if (_currentWeather == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weather Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            WeatherDetailCard(
              icon: Icons.compress,
              title: 'Pressure',
              value: '${_currentWeather!.pressure} hPa',
              cardColor: cardColor,
              textColor: textColor,
            ),
            WeatherDetailCard(
              icon: Icons.visibility,
              title: 'Visibility',
              value: '${(_currentWeather!.visibility / 1000).toStringAsFixed(1)} km',
              subtitle: _currentWeather!.getVisibilityText(),
              cardColor: cardColor,
              textColor: textColor,
            ),
            WeatherDetailCard(
              icon: Icons.explore,
              title: 'Wind Direction',
              value: _currentWeather!.getWindDirection(),
              subtitle: '${_currentWeather!.windDeg}°',
              cardColor: cardColor,
              textColor: textColor,
            ),
            WeatherDetailCard(
              icon: Icons.cloud,
              title: 'Cloudiness',
              value: '${_currentWeather!.cloudiness}%',
              cardColor: cardColor,
              textColor: textColor,
            ),
            WeatherDetailCard(
              icon: Icons.wb_sunny,
              title: 'Sunrise',
              value: DateFormat('HH:mm').format(_currentWeather!.sunrise),
              cardColor: cardColor,
              textColor: textColor,
            ),
            WeatherDetailCard(
              icon: Icons.nights_stay,
              title: 'Sunset',
              value: DateFormat('HH:mm').format(_currentWeather!.sunset),
              cardColor: cardColor,
              textColor: textColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadWeather,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}