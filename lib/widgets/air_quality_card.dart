import 'package:flutter/material.dart';
import '../models/weather_data.dart';

class AirQualityCard extends StatelessWidget {
  final AirQuality airQuality;
  final Color cardColor;
  final Color textColor;

  const AirQualityCard({
    super.key,
    required this.airQuality,
    required this.cardColor,
    required this.textColor,
  });

  Color _getAQIColor() {
    switch (airQuality.aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.air,
                color: _getAQIColor(),
                size: 32,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Air Quality',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getAQIColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          airQuality.getAQIText(),
                          style: TextStyle(
                            color: _getAQIColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AQI ${airQuality.aqi}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            airQuality.getAQIDescription(),
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPollutant('PM2.5', airQuality.pm2_5.toStringAsFixed(1)),
              _buildPollutant('PM10', airQuality.pm10.toStringAsFixed(1)),
              _buildPollutant('O₃', airQuality.o3.toStringAsFixed(1)),
              _buildPollutant('NO₂', airQuality.no2.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPollutant(String name, String value) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            color: textColor.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          'μg/m³',
          style: TextStyle(
            color: textColor.withOpacity(0.5),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
