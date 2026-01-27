import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';

class ImprovedWeatherDetails extends StatelessWidget {
  final WeatherData weather;
  final bool isDarkMode;

  const ImprovedWeatherDetails({
    super.key,
    required this.weather,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final accentColor = isDarkMode ? const Color(0xFF4FC3F7) : const Color(0xFF1976D2);
    final secondaryColor = isDarkMode ? Colors.white70 : Colors.grey.shade600;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weather Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Real-time',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Atmospheric Conditions
          _buildSection(
            title: 'Atmospheric Conditions',
            icon: Icons.cloud,
            color: accentColor,
            children: [
              _buildDetailItem(
                context: context,
                icon: Icons.compress,
                title: 'Pressure',
                value: '${weather.pressure} hPa',
                secondary: weather.getPressureLevel(),
                progress: weather.getPressureProgress(),
                progressColor: weather.getPressureColor(),
                isDarkMode: isDarkMode,
              ),
              _buildDetailItem(
                context: context,
                icon: Icons.water_drop,
                title: 'Humidity',
                value: '${weather.humidity}%',
                secondary: weather.getHumidityLevel(),
                progress: weather.getHumidityProgress(),
                progressColor: weather.getHumidityColor(),
                isDarkMode: isDarkMode,
              ),
              _buildDetailItem(
                context: context,
                icon: Icons.cloud_queue,
                title: 'Cloudiness',
                value: '${weather.cloudiness}%',
                secondary: weather.getCloudinessLevel(),
                progress: weather.getCloudinessProgress(),
                progressColor: weather.getCloudinessColor(),
                isDarkMode: isDarkMode,
              ),
            ],
          ),

          // Visibility & Wind
          _buildSection(
            title: 'Visibility & Wind',
            icon: Icons.air,
            color: const Color(0xFF4CAF50),
            children: [
              _buildDetailItem(
                context: context,
                icon: Icons.visibility,
                title: 'Visibility',
                value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                secondary: weather.getVisibilityText(),
                progress: weather.getVisibilityProgress(), // FIXED: Pakai method dari WeatherData
                progressColor: weather.getVisibilityColor(),
                showProgress: true,
                isDarkMode: isDarkMode,
              ),
              _buildWindDetail(
                context: context,
                windSpeed: weather.windSpeed,
                windDeg: weather.windDeg,
                isDarkMode: isDarkMode,
              ),
            ],
          ),

          // Sun & Moon
          _buildSection(
            title: 'Sun & Moon',
            icon: Icons.wb_sunny,
            color: const Color(0xFFFF9800),
            children: [
              _buildTimeDetail(
                context: context,
                icon: Icons.wb_sunny,
                title: 'Sunrise',
                time: weather.sunrise,
                isDarkMode: isDarkMode,
              ),
              _buildTimeDetail(
                context: context,
                icon: Icons.nights_stay,
                title: 'Sunset',
                time: weather.sunset,
                isDarkMode: isDarkMode,
              ),
              _buildMoonPhase(isDarkMode: isDarkMode),
            ],
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last updated: ${DateFormat('HH:mm').format(DateTime.now())}',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showDetailedAnalytics(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        'View Analytics',
                        style: TextStyle(
                          fontSize: 12,
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: accentColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        ...children,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDetailItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String secondary,
    required double progress,
    required Color progressColor,
    bool showProgress = true,
    required bool isDarkMode,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryColor = isDarkMode ? Colors.white70 : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: progressColor),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryColor,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    secondary,
                    style: TextStyle(
                      fontSize: 12,
                      color: progressColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (showProgress) ...[
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: isDarkMode ? Colors.white10 : Colors.grey.shade200,
                        color: progressColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWindDetail({
    required BuildContext context,
    required double windSpeed,
    required int windDeg,
    required bool isDarkMode,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final windDirection = _getWindDirection(windDeg);
    final windLevel = _getWindLevel(windSpeed);
    final windColor = _getWindColor(windLevel);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Transform.rotate(
                angle: (windDeg - 45) * 3.14159 / 180,
                child: Icon(
                  Icons.navigation,
                  size: 24,
                  color: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wind',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${windSpeed.toStringAsFixed(1)} m/s',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                windDirection,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: windColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  windLevel,
                  style: TextStyle(
                    fontSize: 11,
                    color: windColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDetail({
    required BuildContext context,
    required IconData icon,
    required String title,
    required DateTime time,
    required bool isDarkMode,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryColor = isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final isPast = time.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isPast ? const Color(0xFFFF9800) : Colors.blue,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryColor,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm').format(time),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            isPast ? 'Today' : 'Upcoming',
            style: TextStyle(
              fontSize: 12,
              color: isPast ? const Color(0xFFFF9800) : Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      )
    );
  }

  Widget _buildMoonPhase({required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF9C27B0),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '🌙',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Moon Phase',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Waning Crescent',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '23% visible',
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF9C27B0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods (tidak pakai weather.visibility langsung)
  String _getWindDirection(int degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'N';
    if (degrees >= 22.5 && degrees < 67.5) return 'NE';
    if (degrees >= 67.5 && degrees < 112.5) return 'E';
    if (degrees >= 112.5 && degrees < 157.5) return 'SE';
    if (degrees >= 157.5 && degrees < 202.5) return 'S';
    if (degrees >= 202.5 && degrees < 247.5) return 'SW';
    if (degrees >= 247.5 && degrees < 292.5) return 'W';
    return 'NW';
  }

  String _getWindLevel(double speed) {
    if (speed < 0.5) return 'Calm';
    if (speed < 1.6) return 'Light Air';
    if (speed < 3.4) return 'Light Breeze';
    if (speed < 5.5) return 'Gentle Breeze';
    if (speed < 8.0) return 'Moderate Breeze';
    if (speed < 10.8) return 'Fresh Breeze';
    if (speed < 13.9) return 'Strong Breeze';
    return 'High Wind';
  }

  Color _getWindColor(String level) {
    switch (level) {
      case 'Calm':
        return Colors.green;
      case 'Light Air':
      case 'Light Breeze':
        return Colors.lightGreen;
      case 'Gentle Breeze':
      case 'Moderate Breeze':
        return Colors.orange;
      case 'Fresh Breeze':
      case 'Strong Breeze':
        return Colors.deepOrange;
      default:
        return Colors.red;
    }
  }

  void _showDetailedAnalytics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: const Center(
            child: Text(
              'Detailed Analytics Coming Soon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}