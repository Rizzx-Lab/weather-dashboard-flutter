import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast.dart';

class ForecastCard extends StatelessWidget {
  final Forecast forecast;

  const ForecastCard({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(forecast.dateTime),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              DateFormat('HH:mm').format(forecast.dateTime),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(
              forecast.iconUrl,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.cloud,
                  size: 50,
                  color: Colors.blue,
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              '${forecast.temperature.round()}°C',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              forecast.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.water_drop,
                  size: 12,
                  color: Colors.blue,
                ),
                const SizedBox(width: 2),
                Text(
                  '${forecast.humidity}%',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
