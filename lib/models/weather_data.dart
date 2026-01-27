class WeatherData {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDeg;
  final String description;
  final String icon;
  final int cloudiness;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;
  final double? rainVolume;
  final double? snowVolume;
  final double lat;
  final double lon;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDeg,
    required this.description,
    required this.icon,
    required this.cloudiness,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    this.rainVolume,
    this.snowVolume,
    required this.lat,
    required this.lon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? 'Unknown',
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDeg: json['wind']['deg'] ?? 0,
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
      cloudiness: json['clouds']['all'] ?? 0,
      visibility: json['visibility'] ?? 10000,
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      rainVolume: json['rain']?['1h']?.toDouble(),
      snowVolume: json['snow']?['1h']?.toDouble(),
      lat: json['coord']['lat'].toDouble(),
      lon: json['coord']['lon'].toDouble(),
    );
  }

  String getWindDirection() {
    if (windDeg >= 337.5 || windDeg < 22.5) return 'N';
    if (windDeg >= 22.5 && windDeg < 67.5) return 'NE';
    if (windDeg >= 67.5 && windDeg < 112.5) return 'E';
    if (windDeg >= 112.5 && windDeg < 157.5) return 'SE';
    if (windDeg >= 157.5 && windDeg < 202.5) return 'S';
    if (windDeg >= 202.5 && windDeg < 247.5) return 'SW';
    if (windDeg >= 247.5 && windDeg < 292.5) return 'W';
    return 'NW';
  }

  String getVisibilityText() {
    final km = visibility / 1000;
    if (km >= 10) return 'Excellent';
    if (km >= 5) return 'Good';
    if (km >= 2) return 'Moderate';
    if (km >= 1) return 'Poor';
    return 'Very Poor';
  }
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String icon;
  final String description;
  final int humidity;
  final double windSpeed;
  final int pop; // Probability of precipitation

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pop: ((json['pop'] ?? 0) * 100).toInt(),
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String icon;
  final String description;
  final int humidity;
  final double windSpeed;
  final int pop;

  DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });
}

class AirQuality {
  final int aqi;
  final double co;
  final double no2;
  final double o3;
  final double pm2_5;
  final double pm10;

  AirQuality({
    required this.aqi,
    required this.co,
    required this.no2,
    required this.o3,
    required this.pm2_5,
    required this.pm10,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    final components = json['list'][0]['components'];
    return AirQuality(
      aqi: json['list'][0]['main']['aqi'],
      co: components['co'].toDouble(),
      no2: components['no2'].toDouble(),
      o3: components['o3'].toDouble(),
      pm2_5: components['pm2_5'].toDouble(),
      pm10: components['pm10'].toDouble(),
    );
  }

  String getAQIText() {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  String getAQIDescription() {
    switch (aqi) {
      case 1:
        return 'Air quality is satisfactory';
      case 2:
        return 'Air quality is acceptable';
      case 3:
        return 'Sensitive groups may experience health effects';
      case 4:
        return 'Everyone may experience health effects';
      case 5:
        return 'Health alert: everyone may experience serious health effects';
      default:
        return 'Unknown air quality';
    }
  }
}

class SavedLocation {
  final String name;
  final double lat;
  final double lon;
  final String country;

  SavedLocation({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
      'country': country,
    };
  }

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
      country: json['country'],
    );
  }
}