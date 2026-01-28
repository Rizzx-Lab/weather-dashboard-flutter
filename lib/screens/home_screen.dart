import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../widgets/modern/advanced_weather_card.dart';
import '../widgets/modern/hourly_forecast_chart.dart';
import '../widgets/modern/forecast_summary_card.dart';
import '../widgets/modern/weather_analytics_widget.dart';
import '../widgets/modern/interactive_weather_card.dart';
import '../widgets/animations/fade_in_widget.dart';
import '../widgets/animations/shimmer_loading.dart';
import '../widgets/air_quality_card.dart';
import '../widgets/weather_map_card.dart';
import '../widgets/improved_weather_details.dart';
import 'search_screen.dart';
import 'saved_locations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  WeatherData? _currentWeather;
  List<HourlyForecast> _hourlyForecast = [];
  List<DailyForecast> _dailyForecast = [];
  AirQuality? _airQuality;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _errorMessage = '';
  bool _isDarkMode = false;

  late AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _loadDarkMode();
    _loadWeather();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadDarkMode() async {
    final darkMode = await _storageService.getDarkMode();
    setState(() {
      _isDarkMode = darkMode;
    });
  }

  Future<void> _loadWeather({bool showRefresh = false}) async {
    if (showRefresh) {
      setState(() {
        _isRefreshing = true;
      });
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }

    try {
      final position = await _locationService.getCurrentLocation();
      
      double lat, lon;
      
      if (position != null) {
        lat = position.latitude;
        lon = position.longitude;
        await _storageService.saveLastLocation(lat, lon);
      } else {
        final lastLoc = await _storageService.getLastLocation();
        if (lastLoc != null) {
          lat = lastLoc['lat']!;
          lon = lastLoc['lon']!;
        } else {
          lat = -7.2575;
          lon = 112.7521;
        }
      }

      final results = await Future.wait([
        _weatherService.getCurrentWeather(lat, lon),
        _weatherService.getHourlyForecast(lat, lon),
        _weatherService.getDailyForecast(lat, lon),
        _weatherService.getAirQuality(lat, lon),
      ]);

      setState(() {
        _currentWeather = results[0] as WeatherData;
        _hourlyForecast = results[1] as List<HourlyForecast>;
        _dailyForecast = results[2] as List<DailyForecast>;
        _airQuality = results[3] as AirQuality?;
        _isLoading = false;
        _isRefreshing = false;
      });

      HapticFeedback.lightImpact();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather data: ${e.toString()}';
        _isLoading = false;
        _isRefreshing = false;
      });
      
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _loadWeatherForLocation(double lat, double lon) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _weatherService.getCurrentWeather(lat, lon),
        _weatherService.getHourlyForecast(lat, lon),
        _weatherService.getDailyForecast(lat, lon),
        _weatherService.getAirQuality(lat, lon),
      ]);

      await _storageService.saveLastLocation(lat, lon);

      setState(() {
        _currentWeather = results[0] as WeatherData;
        _hourlyForecast = results[1] as List<HourlyForecast>;
        _dailyForecast = results[2] as List<DailyForecast>;
        _airQuality = results[3] as AirQuality?;
        _isLoading = false;
      });

      HapticFeedback.lightImpact();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather data';
        _isLoading = false;
      });
      HapticFeedback.mediumImpact();
    }
  }

  void _toggleDarkMode() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await _storageService.setDarkMode(_isDarkMode);
  }

  Future<void> _toggleFavorite() async {
    if (_currentWeather == null) return;

    HapticFeedback.lightImpact();
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
        SnackBar(
          content: const Text('Location removed from favorites'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      await _storageService.addLocation(SavedLocation(
        name: _currentWeather!.cityName,
        lat: _currentWeather!.lat,
        lon: _currentWeather!.lon,
        country: '',
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Location added to favorites'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
    setState(() {});
  }

  Widget _buildLoadingScreen() {
    final bgColor = _isDarkMode ? const Color(0xFF1a1d29) : const Color(0xFFF5F7FA);
    
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(
                        width: 200,
                        height: 32,
                        borderRadius: BorderRadius.circular(8),
                        baseColor: Colors.white.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.4),
                      ),
                      const SizedBox(height: 8),
                      ShimmerLoading(
                        width: 150,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                        baseColor: Colors.white.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.4),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ShimmerLoading(
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.circular(20),
                        baseColor: Colors.white.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.4),
                      ),
                      const SizedBox(width: 12),
                      ShimmerLoading(
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.circular(20),
                        baseColor: Colors.white.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.4),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(
                          width: 120,
                          height: 48,
                          borderRadius: BorderRadius.circular(8),
                          baseColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.4),
                        ),
                        const SizedBox(height: 12),
                        ShimmerLoading(
                          width: 180,
                          height: 24,
                          borderRadius: BorderRadius.circular(4),
                          baseColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.4),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ShimmerLoading(
                      width: 100,
                      height: 100,
                      borderRadius: BorderRadius.circular(50),
                      baseColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.white.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    final bgColor = _isDarkMode ? const Color(0xFF1a1d29) : const Color(0xFFF5F7FA);
    final textColor = _isDarkMode ? Colors.white : Colors.black87;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _isDarkMode 
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFF1a1d29),
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFFF5F7FA),
            ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              const Icon(Icons.wb_sunny, color: Color(0xFF3b82f6)),
              const SizedBox(width: 8),
              Text(
                'Weather Dashboard',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: textColor,
              ),
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
        ),
        body: _errorMessage.isNotEmpty
            ? _buildErrorWidget()
            : RefreshIndicator(
                onRefresh: () => _loadWeather(showRefresh: true),
                color: const Color(0xFF3b82f6),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: [
                    // Main Weather Card
                    if (_currentWeather != null)
                      FadeInWidget(
                        delay: const Duration(milliseconds: 100),
                        child: AdvancedWeatherCard(
                          weather: _currentWeather!,
                          isDarkMode: _isDarkMode,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Air Quality
                    if (_airQuality != null)
                      FadeInWidget(
                        delay: const Duration(milliseconds: 200),
                        child: InteractiveWeatherCard(
                          backgroundColor: _isDarkMode ? const Color(0xFF242936) : Colors.white,
                          child: AirQualityCard(
                            airQuality: _airQuality!,
                            cardColor: Colors.transparent,
                            textColor: textColor,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Hourly Forecast Chart (24 jam)
                    if (_hourlyForecast.isNotEmpty)
                      FadeInWidget(
                        delay: const Duration(milliseconds: 300),
                        child: HourlyForecastChart(
                          forecasts: _hourlyForecast,
                          isDarkMode: _isDarkMode,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Summary 24 Jam (4 cards)
                    if (_hourlyForecast.isNotEmpty)
                      FadeInWidget(
                        delay: const Duration(milliseconds: 400),
                        child: ForecastSummaryCard(
                          hourlyForecasts: _hourlyForecast,
                          isDarkMode: _isDarkMode,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Weather Analytics (Charts)
                    if (_hourlyForecast.isNotEmpty && _dailyForecast.isNotEmpty)
                      FadeInWidget(
                        delay: const Duration(milliseconds: 500),
                        child: WeatherAnalyticsWidget(
                          hourlyForecasts: _hourlyForecast,
                          dailyForecasts: _dailyForecast,
                          isDarkMode: _isDarkMode,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Weather Details
                    if (_currentWeather != null)
                      FadeInWidget(
                        delay: const Duration(milliseconds: 600),
                        child: ImprovedWeatherDetails(
                          weather: _currentWeather!,
                          isDarkMode: _isDarkMode,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Weather Map
                    if (_currentWeather != null)
                      FadeInWidget(
                        delay: const Duration(milliseconds: 700),
                        child: WeatherMapCard(
                          lat: _currentWeather!.lat,
                          lon: _currentWeather!.lon,
                          isDarkMode: _isDarkMode,
                        ),
                      ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Favorite Button
            FloatingActionButton(
              heroTag: 'favorite',
              onPressed: _toggleFavorite,
              backgroundColor: _isDarkMode ? const Color(0xFF3b82f6) : Colors.white,
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

            const SizedBox(height: 16),

            // Refresh Button
            FloatingActionButton(
              heroTag: 'refresh',
              onPressed: () => _loadWeather(showRefresh: true),
              backgroundColor: _isDarkMode ? const Color(0xFF3b82f6) : Colors.white,
              child: AnimatedBuilder(
                animation: _refreshController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _isRefreshing ? _refreshController.value * 6.28 : 0,
                    child: Icon(
                      _isRefreshing ? Icons.refresh : Icons.my_location,
                      color: _isDarkMode ? Colors.white : const Color(0xFF3b82f6),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    final bgColor = _isDarkMode ? const Color(0xFF1a1d29) : const Color(0xFFF5F7FA);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _loadWeather(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3b82f6),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}