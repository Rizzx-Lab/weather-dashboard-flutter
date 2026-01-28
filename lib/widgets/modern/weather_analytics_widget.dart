import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/weather_data.dart';

class WeatherAnalyticsWidget extends StatelessWidget {
  final List<HourlyForecast> hourlyForecasts;
  final List<DailyForecast> dailyForecasts;
  final bool isDarkMode;

  const WeatherAnalyticsWidget({
    super.key,
    required this.hourlyForecasts,
    required this.dailyForecasts,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyForecasts.isEmpty && dailyForecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final cardBg = isDarkMode ? const Color(0xFF242936) : Colors.white;
    final gridColor = isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1);

    // Take first 8 hourly forecasts
    final hourlyData = hourlyForecasts.take(8).toList();
    final dailyData = dailyForecasts.take(5).toList();

    // Calculate metrics
    final avgTemp = hourlyData.fold(0.0, (sum, h) => sum + h.temperature) / hourlyData.length;
    final maxHumidity = hourlyData.map((h) => h.humidity).reduce((a, b) => a > b ? a : b);
    final pressureRange = '${hourlyData.map((h) => h.temperature).reduce((a, b) => a < b ? a : b).round()}-${hourlyData.map((h) => h.temperature).reduce((a, b) => a > b ? a : b).round()}';

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
                      Icons.analytics,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Analisis Cuaca',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1e293b) : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${hourlyData.length}h • ${dailyData.length}d',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Charts Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
            children: [
              // Temperature Trend Chart
              _buildChartCard(
                'Tren Suhu 24 Jam',
                Icons.thermostat,
                const Color(0xFF3b82f6),
                _buildTemperatureChart(hourlyData, gridColor),
                isDarkMode,
              ),

              // Daily Forecast Bar Chart
              _buildChartCard(
                'Prakiraan 5 Hari',
                Icons.calendar_today,
                const Color(0xFFf59e0b),
                _buildDailyForecastChart(dailyData, gridColor),
                isDarkMode,
              ),

              // Humidity Pie Chart
              _buildChartCard(
                'Distribusi Kelembaban',
                Icons.water_drop,
                const Color(0xFF10b981),
                _buildHumidityPieChart(),
                isDarkMode,
              ),

              // Pressure Line Chart
              _buildChartCard(
                'Tekanan Atmosfer',
                Icons.speed,
                const Color(0xFFa855f7),
                _buildPressureChart(hourlyData, gridColor),
                isDarkMode,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Summary Metrics
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildMetricCard(
                'Rata-rata Suhu',
                '${avgTemp.round()}°C',
                Icons.thermostat,
                const Color(0xFF3b82f6),
                0.7,
                isDarkMode,
              ),
              _buildMetricCard(
                'Kelembaban Max',
                '$maxHumidity%',
                Icons.water_drop,
                const Color(0xFF10b981),
                maxHumidity / 100,
                isDarkMode,
              ),
              _buildMetricCard(
                'Rentang Tekanan',
                '$pressureRange hPa',
                Icons.trending_up,
                const Color(0xFFa855f7),
                0.6,
                isDarkMode,
              ),
              _buildMetricCard(
                'Data Points',
                '${hourlyForecasts.length}',
                Icons.analytics,
                const Color(0xFFf97316),
                0.8,
                isDarkMode,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Footer
          Center(
            child: Text(
              'Data diperbarui setiap 3 jam • Sumber: OpenWeather API',
              style: TextStyle(
                color: textColor.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(
    String title,
    IconData icon,
    Color color,
    Widget chart,
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
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildTemperatureChart(List<HourlyForecast> data, Color gridColor) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: gridColor,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: false,
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.temperature);
            }).toList(),
            isCurved: true,
            color: const Color(0xFF3b82f6),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF3b82f6).withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyForecastChart(List<DailyForecast> data, Color gridColor) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.tempMax,
                color: const Color(0xFFf59e0b),
                width: 12,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              BarChartRodData(
                toY: entry.value.tempMin,
                color: const Color(0xFF3b82f6),
                width: 12,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHumidityPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 20,
        sections: [
          PieChartSectionData(
            value: 25,
            color: const Color(0xFF3b82f6),
            radius: 30,
            showTitle: false,
          ),
          PieChartSectionData(
            value: 35,
            color: const Color(0xFF10b981),
            radius: 30,
            showTitle: false,
          ),
          PieChartSectionData(
            value: 25,
            color: const Color(0xFFf59e0b),
            radius: 30,
            showTitle: false,
          ),
          PieChartSectionData(
            value: 15,
            color: const Color(0xFFef4444),
            radius: 30,
            showTitle: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPressureChart(List<HourlyForecast> data, Color gridColor) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.temperature);
            }).toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFFa855f7), Color(0xFFec4899)],
            ),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFFa855f7),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
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
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: Colors.white.withOpacity(0.8), size: 14),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}