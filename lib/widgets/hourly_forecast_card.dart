import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import 'weather_icon.dart';

class HourlyForecastCard extends StatelessWidget {
  final HourlyForecast forecast;
  final Color cardColor;
  final Color textColor;

  const HourlyForecastCard({
    super.key,
    required this.forecast,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('HH:mm').format(forecast.time),
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          WeatherIcon(
            icon: forecast.icon,
            size: 36, // Dikurangi dari 48 jadi 36
          ),
          const SizedBox(height: 6),
          Text(
            '${forecast.temperature.round()}°',
            style: TextStyle(
              color: textColor,
              fontSize: 16, // Dikurangi dari 18 jadi 16
              fontWeight: FontWeight.bold,
            ),
          ),
          if (forecast.pop > 20) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.water_drop,
                  size: 10, // Dikurangi dari 12 jadi 10
                  color: Colors.blue.withOpacity(0.7),
                ),
                const SizedBox(width: 2),
                Text(
                  '${forecast.pop}%',
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 10, // Dikurangi dari 11 jadi 10
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}