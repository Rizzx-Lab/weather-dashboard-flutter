import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/weather_gradients.dart';

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
              Column(
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

              const SizedBox(height: 20),

              // Temperature and icon - FIXED: Made responsive
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Temperature - FIXED: Added Flexible to prevent overflow
                  Flexible(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Weather Icon - FIXED: Made smaller on mobile
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8),
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
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.wb_sunny,
                            size: 60,
                            color: textColor,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Additional info - FIXED: Made responsive with GridView
              LayoutBuilder(
                builder: (context, constraints) {
                  // If screen is too narrow, use 2 columns instead of 4
                  final crossAxisCount = constraints.maxWidth < 400 ? 2 : 4;
                  
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: textColor.withOpacity(0.9),
          size: 20,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}