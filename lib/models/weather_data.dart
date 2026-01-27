import 'package:flutter/material.dart';
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

  // ===================== HELPER METHODS UNTUK IMPROVED DETAILS =====================
  
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

  String getWindDirectionText() {
    if (windDeg >= 337.5 || windDeg < 22.5) return 'North';
    if (windDeg >= 22.5 && windDeg < 67.5) return 'Northeast';
    if (windDeg >= 67.5 && windDeg < 112.5) return 'East';
    if (windDeg >= 112.5 && windDeg < 157.5) return 'Southeast';
    if (windDeg >= 157.5 && windDeg < 202.5) return 'South';
    if (windDeg >= 202.5 && windDeg < 247.5) return 'Southwest';
    if (windDeg >= 247.5 && windDeg < 292.5) return 'West';
    return 'Northwest';
  }

  String getHumidityLevel() {
    if (humidity < 30) return 'Dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 80) return 'Humid';
    return 'Very Humid';
  }

  Color getHumidityColor() {
    if (humidity < 30) return Colors.blue;
    if (humidity < 60) return Colors.green;
    if (humidity < 80) return Colors.orange;
    return Colors.red;
  }

  String getCloudinessLevel() {
    if (cloudiness < 20) return 'Clear';
    if (cloudiness < 50) return 'Partly Cloudy';
    if (cloudiness < 80) return 'Mostly Cloudy';
    return 'Overcast';
  }

  Color getCloudinessColor() {
    if (cloudiness < 20) return Colors.blue;
    if (cloudiness < 50) return Colors.lightBlue;
    if (cloudiness < 80) return Colors.grey;
    return Colors.blueGrey;
  }

  String getPressureLevel() {
    if (pressure < 1000) return 'Low';
    if (pressure < 1015) return 'Normal';
    if (pressure < 1030) return 'High';
    return 'Very High';
  }

  Color getPressureColor() {
    if (pressure < 1000) return Colors.red;
    if (pressure < 1015) return Colors.green;
    if (pressure < 1030) return Colors.orange;
    return Colors.red;
  }

  String getVisibilityText() {
    final km = visibility / 1000;
    if (km >= 10) return 'Excellent';
    if (km >= 5) return 'Good';
    if (km >= 2) return 'Moderate';
    if (km >= 1) return 'Poor';
    return 'Very Poor';
  }

  Color getVisibilityColor() {
    final km = visibility / 1000;
    if (km >= 10) return Colors.green;
    if (km >= 5) return Colors.lightGreen;
    if (km >= 2) return Colors.orange;
    if (km >= 1) return Colors.deepOrange;
    return Colors.red;
  }

  double getVisibilityProgress() {
    // Normalize visibility 0-10km to 0-1
    return (visibility / 10000).clamp(0.0, 1.0);
  }

  String getWindLevel() {
    if (windSpeed < 0.5) return 'Calm';
    if (windSpeed < 1.6) return 'Light Air';
    if (windSpeed < 3.4) return 'Light Breeze';
    if (windSpeed < 5.5) return 'Gentle Breeze';
    if (windSpeed < 8.0) return 'Moderate Breeze';
    if (windSpeed < 10.8) return 'Fresh Breeze';
    if (windSpeed < 13.9) return 'Strong Breeze';
    return 'High Wind';
  }

  Color getWindColor() {
    if (windSpeed < 0.5) return Colors.green;
    if (windSpeed < 1.6) return Colors.lightGreen;
    if (windSpeed < 3.4) return Colors.yellow;
    if (windSpeed < 5.5) return Colors.orange;
    if (windSpeed < 8.0) return Colors.deepOrange;
    if (windSpeed < 10.8) return Colors.red;
    if (windSpeed < 13.9) return Colors.red.shade900;
    return Colors.purple;
  }

  double getHumidityProgress() {
    return humidity / 100.0;
  }

  double getCloudinessProgress() {
    return cloudiness / 100.0;
  }

  double getPressureProgress() {
    // Normalize pressure 970-1030 hPa to 0-1
    return ((pressure - 970) / 60).clamp(0.0, 1.0);
  }

  String getSunStatus() {
    final now = DateTime.now();
    if (now.isBefore(sunrise)) {
      return 'Sunrise in ${sunrise.difference(now).inHours}h';
    } else if (now.isBefore(sunset)) {
      return 'Daylight';
    } else {
      return 'Night';
    }
  }

  bool getIsDayTime() {
    final now = DateTime.now();
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }

  Duration getDaylightDuration() {
    return sunset.difference(sunrise);
  }

  String getDaylightDurationText() {
    final duration = getDaylightDuration();
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  String getFormattedSunrise() {
    return '${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')}';
  }

  String getFormattedSunset() {
    return '${sunset.hour.toString().padLeft(2, '0')}:${sunset.minute.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'humidity': humidity,
      'pressure': pressure,
      'windSpeed': windSpeed,
      'windDeg': windDeg,
      'description': description,
      'icon': icon,
      'cloudiness': cloudiness,
      'visibility': visibility,
      'sunrise': sunrise.millisecondsSinceEpoch,
      'sunset': sunset.millisecondsSinceEpoch,
      'lat': lat,
      'lon': lon,
    };
  }

  // ===================== END HELPER METHODS =====================
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

  // Helper untuk HourlyForecast
  String getFormattedTime() {
    return '${time.hour.toString().padLeft(2, '0')}:00';
  }

  String getPopText() {
    if (pop < 20) return '';
    if (pop < 50) return 'Light Rain';
    if (pop < 80) return 'Rain';
    return 'Heavy Rain';
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

  // Helper untuk DailyForecast
  String getDayName() {
    final now = DateTime.now();
    if (date.day == now.day) return 'Today';
    if (date.day == now.day + 1) return 'Tomorrow';
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String getFormattedDate() {
    return '${date.month}/${date.day}';
  }

  String getPopText() {
    if (pop < 20) return 'No Rain';
    if (pop < 50) return 'Chance of Rain';
    if (pop < 80) return 'Rain Expected';
    return 'Heavy Rain';
  }
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

  Color getAQIColor() {
    switch (aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getDominantPollutant() {
    final pollutants = {
      'PM2.5': pm2_5,
      'PM10': pm10,
      'O₃': o3,
      'NO₂': no2,
      'CO': co,
    };
    
    var dominant = '';
    var maxValue = 0.0;
    
    pollutants.forEach((key, value) {
      if (value > maxValue) {
        maxValue = value;
        dominant = key;
      }
    });
    
    return dominant;
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

  String getCoordinates() {
    return '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';
  }
}