import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
    required this.temp,
    required this.wind,
    required this.humidity,
    required this.wind_dir,
    required this.sky,
  });

  final double temp;
  final int wind;
  final int humidity;
  final String wind_dir;
  final String sky;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconText(icon: Icon(Icons.cloud, color: Colors.black), text: '${temp}\u00B0'),
            IconText(icon: Icon(Icons.wind_power, color: Colors.black), text: '${wind} км/ч'),
            IconText(icon: Icon(Icons.water_drop, color: Colors.lightBlue), text: '${humidity}%')
          ],
        ),
      ),
    );
  }
}


class IconText extends StatelessWidget {
  const IconText({required this.text, required this.icon});
  final String text;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        icon,
        VerticalDivider(),
        Text('${text}'),
      ],
    );
  }
}
