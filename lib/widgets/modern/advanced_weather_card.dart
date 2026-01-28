import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather_data.dart';
import '../../theme/weather_gradients.dart';
import '../weather_icon.dart';

class AdvancedWeatherCard extends StatelessWidget {
  final WeatherData weather;
  final bool isDarkMode;

  const AdvancedWeatherCard({
    super.key,
    required this.weather,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = WeatherGradients.getMainBlueGradient(isDarkMode);
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMM').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

    return Container(
      height: 260, // Increased from 240 to 260
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF242936) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // LEFT SIDE - Blue Gradient Section
          Expanded(
            flex: 5, // Changed from 3 to 5
            child: Container(
              padding: const EdgeInsets.all(16), // Reduced from 20 to 16
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weather.cityName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12), // Reduced from 20 to 12
                  
                  // Temperature & Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.temperature.round()}°',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 52, // Reduced from 56 to 52
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            weather.description[0].toUpperCase() + 
                            weather.description.substring(1),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      WeatherIcon(
                        icon: weather.icon,
                        size: 80,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12), // Reduced from 16 to 12
                  
                  // Min/Max Temp
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10), // Reduced from 12
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_upward,
                                        color: Colors.white,
                                        size: 12, // Reduced from 14
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Max',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 11, // Reduced from 12
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${weather.tempMax.round()}°',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18, // Reduced from 20
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4), // Reduced from 6
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: 1.0,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Reduced from 12
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10), // Reduced from 12
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white,
                                        size: 12, // Reduced from 14
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Min',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 11, // Reduced from 12
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${weather.tempMin.round()}°',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18, // Reduced from 20
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4), // Reduced from 6
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: 1.0,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // RIGHT SIDE - Metrics Section (FIXED!)
          Expanded(
            flex: 3, // Changed from 2 to 3
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1e293b) : const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView( // Add scrollable wrapper
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Metrics Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 8, // Reduced from 10 to 8
                      crossAxisSpacing: 8, // Reduced from 10 to 8
                      childAspectRatio: 0.95, // Changed from 1.1 to 0.95 for smaller cards
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                      _buildMetricCard(
                        'Terasa',
                        '${weather.feelsLike.round()}°',
                        Icons.thermostat,
                        const Color(0xFFf97316),
                        isDarkMode,
                      ),
                      _buildMetricCard(
                        'Kelembaban',
                        '${weather.humidity}%',
                        Icons.water_drop,
                        const Color(0xFF3b82f6),
                        isDarkMode,
                      ),
                      _buildMetricCard(
                        'Angin',
                        '${weather.windSpeed.toStringAsFixed(1)}',
                        Icons.air,
                        const Color(0xFF06b6d4),
                        isDarkMode,
                        subtitle: weather.getWindDirection(),
                      ),
                      _buildMetricCard(
                        'Tekanan',
                        '${weather.pressure}',
                        Icons.speed,
                        const Color(0xFFa855f7),
                        isDarkMode,
                        subtitle: 'hPa',
                      ),
                      ],
                    ), // Close GridView.count
                  
                  const SizedBox(height: 8), // Reduced from 12 to 8
                  
                  // Sun Times
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSunTime(
                          'Terbit',
                          weather.getFormattedSunrise(),
                          Icons.wb_sunny,
                          const Color(0xFFf59e0b),
                          isDarkMode,
                        ),
                        _buildSunTime(
                          'Terbenam',
                          weather.getFormattedSunset(),
                          Icons.nights_stay,
                          const Color(0xFF6366f1),
                          isDarkMode,
                        ),
                      ],
                    ),
                  ),
                  
                  // Footer
                  const SizedBox(height: 6), // Reduced from 8 to 6
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10b981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Update: ${formattedTime}',
                            style: TextStyle(
                              color: isDarkMode 
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.4),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${weather.lat.toStringAsFixed(2)}, ${weather.lon.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.4),
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ), // Close SingleChildScrollView
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark, {
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(8), // Reduced from 10 to 8
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242936) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark 
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 18, // Reduced from 20 to 18
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: isDark 
                    ? Colors.white.withOpacity(0.5)
                    : Colors.black.withOpacity(0.4),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSunTime(
    String label,
    String time,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDark 
                    ? Colors.white.withOpacity(0.6)
                    : Colors.black.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
            Text(
              time,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}