import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load weather data on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialWeather();
    });
  }

  Future<void> _loadInitialWeather() async {
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    await provider.getWeatherByCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            return RefreshIndicator(
              onRefresh: () => weatherProvider.refreshWeather(),
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.blue,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        'Weather Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      centerTitle: true,
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.my_location, color: Colors.white),
                        onPressed: () {
                          weatherProvider.getWeatherByCurrentLocation();
                        },
                        tooltip: 'Use current location',
                      ),
                    ],
                  ),

                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: WeatherSearchBar(
                        onSearch: (city) {
                          weatherProvider.getWeatherByCity(city);
                        },
                      ),
                    ),
                  ),

                  // Loading Indicator
                  if (weatherProvider.isLoading)
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),

                  // Error Message
                  if (weatherProvider.error != null && !weatherProvider.isLoading)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          color: Colors.red[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    weatherProvider.error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Current Weather Card
                  if (weatherProvider.currentWeather != null && !weatherProvider.isLoading)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: WeatherCard(
                          weather: weatherProvider.currentWeather!,
                        ),
                      ),
                    ),

                  // Forecast Section Title
                  if (weatherProvider.forecasts.isNotEmpty && !weatherProvider.isLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: Text(
                          '5-Day Forecast',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                  // Forecast List
                  if (weatherProvider.forecasts.isNotEmpty && !weatherProvider.isLoading)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: weatherProvider.forecasts.length > 15
                              ? 15
                              : weatherProvider.forecasts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ForecastCard(
                                forecast: weatherProvider.forecasts[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // Empty State
                  if (weatherProvider.currentWeather == null &&
                      !weatherProvider.isLoading &&
                      weatherProvider.error == null)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Search for a city to get started',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Bottom Padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
