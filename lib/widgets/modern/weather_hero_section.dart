import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/weather_gradients.dart';
import '../../widgets/animations/fade_in_widget.dart'; // TAMBAH INI

class WeatherHeroSection extends StatelessWidget {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final bool isDarkMode;

  const WeatherHeroSection({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = WeatherGradients.getGradientByCondition(description, isDarkMode);
    final textColor = WeatherGradients.getTextColorForBackground(gradient, isDarkMode);

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location and date
              FadeInWidget( // INI SUDAH BENAR
                delay: const Duration(milliseconds: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Temperature and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Temperature
                  FadeInWidget( // INI SUDAH BENAR
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              temperature.round().toString(),
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                height: 0.9,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '°C',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                color: textColor.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor.withOpacity(0.9),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Weather Icon
                  FadeInWidget( // INI SUDAH BENAR
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.network(
                        'https://openweathermap.org/img/wn/$icon@4x.png',
                        width: 120,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.wb_sunny,
                            size: 80,
                            color: textColor,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Additional info
              FadeInWidget( // INI SUDAH BENAR
                delay: const Duration(milliseconds: 400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherStat(
                      Icons.arrow_upward,
                      '${(temperature + 5).round()}°',
                      'High',
                      textColor,
                    ),
                    _buildWeatherStat(
                      Icons.arrow_downward,
                      '${(temperature - 5).round()}°',
                      'Low',
                      textColor,
                    ),
                    _buildWeatherStat(
                      Icons.water_drop,
                      '65%',
                      'Humidity',
                      textColor,
                    ),
                    _buildWeatherStat(
                      Icons.air,
                      '3.2 m/s',
                      'Wind',
                      textColor,
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

  Widget _buildWeatherStat(IconData icon, String value, String label, Color textColor) {
    return Column(
      children: [
        Icon(
          icon,
          color: textColor.withOpacity(0.9),
          size: 22,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}