import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../widgets/modern/interactive_weather_card.dart';
import '../widgets/modern/weather_hero_section.dart';
import '../widgets/animations/fade_in_widget.dart';
import '../widgets/animations/shimmer_loading.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/air_quality_card.dart';
import '../widgets/weather_map_card.dart';
import '../widgets/improved_weather_details.dart'; // IMPORT BARU
import '../theme/weather_gradients.dart';
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
    final bgColor = _isDarkMode ? const Color(0xFF121212) : const Color(0xFF87CEEB);
    
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

              const SizedBox(height: 32),

              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(
                          width: 150,
                          height: 24,
                          borderRadius: BorderRadius.circular(4),
                          baseColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                margin: EdgeInsets.only(
                                  right: index == 4 ? 0 : 12,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ShimmerLoading(
                                      width: 60,
                                      height: 16,
                                      borderRadius: BorderRadius.circular(4),
                                      baseColor: Colors.white.withOpacity(0.2),
                                      highlightColor: Colors.white.withOpacity(0.4),
                                    ),
                                    const SizedBox(height: 12),
                                    ShimmerLoading(
                                      width: 40,
                                      height: 40,
                                      borderRadius: BorderRadius.circular(20),
                                      baseColor: Colors.white.withOpacity(0.2),
                                      highlightColor: Colors.white.withOpacity(0.4),
                                    ),
                                    const SizedBox(height: 12),
                                    ShimmerLoading(
                                      width: 40,
                                      height: 24,
                                      borderRadius: BorderRadius.circular(4),
                                      baseColor: Colors.white.withOpacity(0.2),
                                      highlightColor: Colors.white.withOpacity(0.4),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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

    final bgColor = _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final textColor = _isDarkMode ? Colors.white : Colors.black87;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _isDarkMode 
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFF121212),
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: const Color(0xFFF5F7FA),
            ),
      child: Scaffold(
        backgroundColor: bgColor,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: textColor,
          title: Text(
            _currentWeather?.cityName ?? 'Weather Dashboard',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
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
                color: _isDarkMode ? const Color(0xFF1976D2) : Colors.white,
                backgroundColor: _isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFF1976D2),
                displacement: 60,
                strokeWidth: 3,
                notificationPredicate: (notification) {
                  return notification.depth == 0;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    if (_currentWeather != null)
                      SliverToBoxAdapter(
                        child: WeatherHeroSection(
                          cityName: _currentWeather!.cityName,
                          temperature: _currentWeather!.temperature,
                          description: _currentWeather!.description,
                          icon: _currentWeather!.icon,
                          isDarkMode: _isDarkMode,
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            gradient: WeatherGradients.getGradientByCondition('clear', _isDarkMode),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        ),
                      ),

                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (_airQuality != null)
                            FadeInWidget(
                              delay: const Duration(milliseconds: 100),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: InteractiveWeatherCard(
                                  backgroundColor: _isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                                  enableHapticFeedback: true,
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                  },
                                  child: AirQualityCard(
                                    airQuality: _airQuality!,
                                    cardColor: Colors.transparent,
                                    textColor: textColor,
                                  ),
                                ),
                              ),
                            ),

                          // Hourly Forecast
                          FadeInWidget(
                            delay: const Duration(milliseconds: 200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12, left: 4),
                                  child: Text(
                                    'Hourly Forecast',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _hourlyForecast.length,
                                    itemBuilder: (context, index) {
                                      return FadeInWidget(
                                        delay: Duration(milliseconds: 300 + (index * 50)),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right: index == _hourlyForecast.length - 1 ? 0 : 12,
                                            left: index == 0 ? 4 : 0,
                                          ),
                                          child: InteractiveWeatherCard(
                                            backgroundColor: _isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                                            enableHapticFeedback: true,
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                            },
                                            child: HourlyForecastCard(
                                              forecast: _hourlyForecast[index],
                                              cardColor: Colors.transparent,
                                              textColor: textColor,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Daily Forecast
                          FadeInWidget(
                            delay: const Duration(milliseconds: 400),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12, left: 4),
                                  child: Text(
                                    '5-Day Forecast',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                ..._dailyForecast.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final forecast = entry.value;
                                  return FadeInWidget(
                                    delay: Duration(milliseconds: 500 + (index * 100)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: InteractiveWeatherCard(
                                        backgroundColor: _isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                                        enableHapticFeedback: true,
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                        },
                                        child: DailyForecastCard(
                                          forecast: forecast,
                                          cardColor: Colors.transparent,
                                          textColor: textColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Weather Map Card
                          if (_currentWeather != null)
                            FadeInWidget(
                              delay: const Duration(milliseconds: 600),
                              child: WeatherMapCard(
                                lat: _currentWeather!.lat,
                                lon: _currentWeather!.lon,
                                isDarkMode: _isDarkMode,
                              ),
                            ),

                          const SizedBox(height: 28),

                          // IMPROVED WEATHER DETAILS - YANG BARU
                          if (_currentWeather != null)
                            FadeInWidget(
                              delay: const Duration(milliseconds: 700),
                              child: ImprovedWeatherDetails(
                                weather: _currentWeather!,
                                isDarkMode: _isDarkMode,
                              ),
                            ),

                          const SizedBox(height: 32),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 16),

            // Favorite Button
            FadeInWidget(
              delay: const Duration(milliseconds: 850),
              child: FloatingActionButton(
                heroTag: 'favorite',
                onPressed: _toggleFavorite,
                backgroundColor: _isDarkMode ? const Color(0xFF1565C0) : Colors.white,
                foregroundColor: Colors.red,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: FutureBuilder<bool>(
                  future: _currentWeather != null
                      ? _storageService.isLocationSaved(
                          _currentWeather!.lat, _currentWeather!.lon)
                      : Future.value(false),
                  builder: (context, snapshot) {
                    final isSaved = snapshot.data ?? false;
                    return Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      size: 24,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Current Location Button
            FadeInWidget(
              delay: const Duration(milliseconds: 900),
              child: FloatingActionButton(
                heroTag: 'refresh',
                onPressed: () => _loadWeather(showRefresh: true),
                backgroundColor: _isDarkMode ? const Color(0xFF1565C0) : Colors.white,
                foregroundColor: _isDarkMode ? Colors.white : const Color(0xFF1976D2),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedBuilder(
                  animation: _refreshController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _isRefreshing ? _refreshController.value * 6.28 : 0,
                      child: Icon(
                        _isRefreshing ? Icons.refresh : Icons.my_location,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    final bgColor = _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final errorBlue = const Color(0xFF1976D2);
    
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInWidget(
                child: Icon(
                  Icons.error_outline,
                  size: 80,
                  color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isDarkMode ? Colors.white70 : Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInWidget(
                delay: const Duration(milliseconds: 300),
                child: InteractiveWeatherCard(
                  backgroundColor: _isDarkMode ? errorBlue : errorBlue,
                  enableHapticFeedback: true,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _loadWeather();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Try Again',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}