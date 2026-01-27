import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String icon;
  final double size;

  const WeatherIcon({
    super.key,
    required this.icon,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://openweathermap.org/img/wn/$icon@4x.png',
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.wb_sunny,
          size: size,
          color: Colors.white,
        );
      },
    );
  }
}