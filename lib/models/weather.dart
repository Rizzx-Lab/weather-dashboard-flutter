class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final DateTime dateTime;
  final double? tempMin;
  final double? tempMax;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.dateTime,
    this.tempMin,
    this.tempMax,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
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
