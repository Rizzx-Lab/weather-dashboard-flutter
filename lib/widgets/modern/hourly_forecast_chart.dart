import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather_data.dart';
import '../weather_icon.dart';

class HourlyForecastChart extends StatelessWidget {
  final List<HourlyForecast> forecasts;
  final bool isDarkMode;

  const HourlyForecastChart({
    super.key,
    required this.forecasts,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    // Ambil 8 data pertama (24 jam)
    final hourlyData = forecasts.take(8).toList();

    // Calculate metrics
    final avgTemp = hourlyData.fold(0.0, (sum, h) => sum + h.temperature) / hourlyData.length;
    final maxHumidity = hourlyData.map((h) => h.humidity).reduce((a, b) => a > b ? a : b);
    final maxWind = hourlyData.map((h) => h.windSpeed).reduce((a, b) => a > b ? a : b);
    final minTemp = hourlyData.map((h) => h.temperature).reduce((a, b) => a < b ? a : b);
    final maxTemp = hourlyData.map((h) => h.temperature).reduce((a, b) => a > b ? a : b);
    final tempChange = (hourlyData.first.temperature - hourlyData.last.temperature).abs();

    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardBg = isDarkMode ? const Color(0xFF242936) : Colors.white;
    final subtleBg = isDarkMode ? const Color(0xFF1e293b) : const Color(0xFFF8F9FA);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3b82f6), Color(0xFF06b6d4)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prakiraan 24 Jam ke Depan',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Detail per 3 jam • ${hourlyData.length} interval',
                        style: TextStyle(
                          color: textColor.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: subtleBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${hourlyData.length * 3} jam',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Hourly Forecast Cards (Horizontal Scroll)
          SizedBox(
            height: 148, // Increased from 155 to 165 for more space
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: hourlyData.length,
              itemBuilder: (context, index) {
                final forecast = hourlyData[index];
                final time = DateFormat('HH:00').format(forecast.time);
                final period = forecast.time.hour < 12 ? 'Pagi' : 
                               forecast.time.hour < 18 ? 'Siang' : 'Malam';

                return Container(
                  width: 140,
                  margin: EdgeInsets.only(
                    right: index == hourlyData.length - 1 ? 0 : 12,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Adjusted padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode 
                          ? [const Color(0xFF1e293b), const Color(0xFF242936)]
                          : [const Color(0xFFF8F9FA), Colors.white],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Time and Period
                      Column(
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            period,
                            style: TextStyle(
                              color: textColor.withOpacity(0.5),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      
                      // Weather Icon
                      WeatherIcon(
                        icon: forecast.icon,
                        size: 38,
                      ),
                      
                      // Temperature
                      Text(
                        '${forecast.temperature.round()}°',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Details
                      Column(
                        children: [
                          _buildDetailRow(
                            Icons.water_drop,
                            'Hum',
                            '${forecast.humidity}%',
                            const Color(0xFF3b82f6),
                            textColor,
                          ),
                          const SizedBox(height: 3),
                          _buildDetailRow(
                            Icons.air,
                            'Wind',
                            '${forecast.windSpeed.toStringAsFixed(1)} m/s',
                            const Color(0xFF06b6d4),
                            textColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Summary Section
          Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: textColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Color(0xFF3b82f6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ringkasan 24 Jam',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${DateFormat('HH:mm').format(hourlyData.first.time)} - ${DateFormat('HH:mm').format(hourlyData.last.time)}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: [
                    _buildSummaryCard(
                      'Suhu Rata-rata',
                      '${avgTemp.round()}°',
                      'Min: ${minTemp.round()}° • Max: ${maxTemp.round()}°',
                      Icons.thermostat,
                      const Color(0xFF3b82f6),
                      ((avgTemp - minTemp) / (maxTemp - minTemp + 0.1)).clamp(0.0, 1.0),
                      isDarkMode,
                    ),
                    _buildSummaryCard(
                      'Kelembaban Max',
                      '$maxHumidity%',
                      'Rata: ${(hourlyData.fold(0, (sum, h) => sum + h.humidity) / hourlyData.length).round()}%',
                      Icons.water_drop,
                      const Color(0xFF10b981),
                      maxHumidity / 100,
                      isDarkMode,
                    ),
                    _buildSummaryCard(
                      'Angin Max',
                      '${maxWind.toStringAsFixed(1)} m/s',
                      'Kecepatan tertinggi',
                      Icons.air,
                      const Color(0xFFf59e0b),
                      (maxWind / 20).clamp(0.0, 1.0),
                      isDarkMode,
                    ),
                    _buildSummaryCard(
                      'Perubahan Suhu',
                      '${tempChange.round()}°',
                      hourlyData.first.temperature > hourlyData.last.temperature ? 'Turun' : 'Naik',
                      Icons.trending_up,
                      const Color(0xFFa855f7),
                      (tempChange / 10).clamp(0.0, 1.0),
                      isDarkMode,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Footer
          Center(
            child: Column(
              children: [
                Text(
                  'Data prakiraan setiap 3 jam • ${hourlyData.length * 3} jam ke depan • Sumber: OpenWeather API',
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Update terakhir: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
                  style: TextStyle(
                    color: textColor.withOpacity(0.4),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
    Color textColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    double progress,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 10,
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black45,
              fontSize: 9,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}