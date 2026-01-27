class Forecast {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double? tempMin;
  final double? tempMax;

  Forecast({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    this.tempMin,
    this.tempMax,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      tempMin: json['main']['temp_min'] != null
          ? (json['main']['temp_min'] as num).toDouble()
          : null,
      tempMax: json['main']['temp_max'] != null
          ? (json['main']['temp_max'] as num).toDouble()
          : null,
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
