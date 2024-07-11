class FieldWeather {

  double temp;
  int wind;
  int humidity;
  String wind_dir;
  String sky;

  FieldWeather(
      this.temp,
      this.wind,
      this.humidity,
      this.wind_dir,
      this.sky
      );

  factory FieldWeather.fromJson(dynamic json) {
    return FieldWeather(
        json['temp'] as double ?? 0.0,
        json['wind'] ?? 0,
        json['humidity'] as int ?? 0,
        json['wind_dir'] ?? '',
        json['sky'] ?? ''
    );
  }
}