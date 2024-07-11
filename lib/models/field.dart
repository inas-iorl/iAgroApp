class FieldModel {
  String id;
  String image;
  String name;
  String descr;
  String culture;
  double co2_value;
  double indicateValue;
  String text_value;

  FieldModel(
      this.id,
      this.image,
      this.name,
      this.descr,
      this.culture,
      this.co2_value,
      this.indicateValue,
      this.text_value,
      );

  factory FieldModel.fromJson(dynamic json) {
    return FieldModel(
      json['_id'] ?? '',
      json['image'] ?? '',
      json['name'] ?? '',
      json['descr'] ?? '',
      json['culture'] ?? '',
      json['current_value']['co2_value'] ?? 0.0,
      json['current_value']['indicateValue'] ?? 0.0,
      json['current_value']['text_value'] ?? 'Нет данных',
    );
  }
}


class FieldDetailModel {
  String texture_class;
  Map<String, dynamic> details;
  // Map<dynamic, dynamic> details;
  // dynamic details;

  FieldDetailModel(
      this.texture_class,
      this.details,
      );

  factory FieldDetailModel.fromJson(dynamic json) {
    return FieldDetailModel(
      json['texture_class'] ?? '',
      json['details'],
    );
  }
}