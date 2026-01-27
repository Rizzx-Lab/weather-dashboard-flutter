import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';
import 'weather_icon.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  final Color cardColor;
  final Color textColor;

  const DailyForecastCard({
    super.key,
    required this.forecast,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              DateFormat('EEE, MMM d').format(forecast.date),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          WeatherIcon(
            icon: forecast.icon,
            size: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  forecast.description,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (forecast.pop > 20)
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 12,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${forecast.pop}%',
                        style: TextStyle(
                          color: textColor.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Text(
                '${forecast.tempMax.round()}°',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' / ',
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                ),
              ),
              Text(
                '${forecast.tempMin.round()}°',
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}