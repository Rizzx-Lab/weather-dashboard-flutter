import 'package:flutter/material.dart';
import '../../models/weather_data.dart';
import '../../theme/weather_gradients.dart';

class ForecastSummaryCard extends StatelessWidget {
  final List<HourlyForecast> hourlyForecasts;
  final bool isDarkMode;

  const ForecastSummaryCard({
    super.key,
    required this.hourlyForecasts,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyForecasts.isEmpty) return const SizedBox.shrink();

    // Calculate metrics (ambil 8 data pertama = 24 jam)
    final forecasts = hourlyForecasts.take(8).toList();
    final avgTemp = forecasts.fold(0.0, (sum, f) => sum + f.temperature) / forecasts.length;
    final minTemp = forecasts.map((f) => f.temperature).reduce((a, b) => a < b ? a : b);
    final maxTemp = forecasts.map((f) => f.temperature).reduce((a, b) => a > b ? a : b);
    final maxHumidity = forecasts.map((f) => f.humidity).reduce((a, b) => a > b ? a : b);
    final maxWind = forecasts.map((f) => f.windSpeed).reduce((a, b) => a > b ? a : b);
    final tempChange = (forecasts.first.temperature - forecasts.last.temperature).abs();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Ringkasan 24 Jam',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2, // Changed from 1.5 to 1.2 for better height
          children: [
            _buildMetricCard(
              title: 'Suhu Rata-rata',
              value: '${avgTemp.round()}°',
              subtitle: 'Min: ${minTemp.round()}° • Max: ${maxTemp.round()}°',
              icon: Icons.thermostat,
              gradient: WeatherGradients.getMainBlueGradient(isDarkMode),
              progress: ((avgTemp - minTemp) / (maxTemp - minTemp + 0.1)).clamp(0.0, 1.0),
            ),
            _buildMetricCard(
              title: 'Kelembaban Max',
              value: '$maxHumidity%',
              subtitle: 'Rata: ${(forecasts.fold(0, (sum, f) => sum + f.humidity) / forecasts.length).round()}%',
              icon: Icons.water_drop,
              gradient: WeatherGradients.getEmeraldGradient(),
              progress: maxHumidity / 100,
            ),
            _buildMetricCard(
              title: 'Angin Max',
              value: '${maxWind.toStringAsFixed(1)} m/s',
              subtitle: 'Kecepatan tertinggi',
              icon: Icons.air,
              gradient: WeatherGradients.getCyanGradient(),
              progress: (maxWind / 20).clamp(0.0, 1.0),
            ),
            _buildMetricCard(
              title: 'Perubahan Suhu',
              value: '${tempChange.round()}°',
              subtitle: forecasts.first.temperature > forecasts.last.temperature ? 'Turun' : 'Naik',
              icon: Icons.trending_up,
              gradient: WeatherGradients.getPurpleGradient(),
              progress: (tempChange / 10).clamp(0.0, 1.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13, // Increased from 12 to 13
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                icon,
                color: Colors.white.withOpacity(0.8),
                size: 18,
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32, // Increased from 24 to 32
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 11, // Increased from 10 to 11
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}