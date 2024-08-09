import 'dart:convert';

import 'package:latlong2/latlong.dart';

class SubFieldModel {
  String id;
  String field_id;
  double co2_value;
  double common;
  double physical;
  double chemical;
  double biological;
  double indicateValue;
  String text_value;
  LatLng? point;
  List<LatLng> borders;

  SubFieldModel(
      this.id,
      this.field_id,
      this.co2_value,
      this.common,
      this.physical,
      this.chemical,
      this.biological,
      this.indicateValue,
      this.text_value,
      this.point,
      this.borders,
      );

  factory SubFieldModel.fromJson(dynamic data) {
    var current_values = json.decode(data['current_values']);
    var point = data['point'];
    var borders = data['borders'];
    return SubFieldModel(
      data['_id'] ?? '', //this.id,
      data['field_id'] ?? '', //this.image,
      current_values['co2_value'] ?? 0.0,//this.co2_value,
      current_values['com'] ?? 0.0, //this.common,
      current_values['phys'] ?? 0.0, //this.physical,
      current_values['chem'] ?? 0.0, //this.chemical,
      current_values['bio'] ?? 0.0, //this.biological,
      current_values['indicate_value'] ?? 0.0, //this.indicateValue,
      '',
      LatLng(point[0], point[1])  ?? null, //this.point,
      borders.map<LatLng>((rec) => LatLng(rec[0], rec[1])).toList() ?? [], //this.borders,
    );
  }
}
