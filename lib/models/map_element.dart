import 'dart:convert';

import 'package:latlong2/latlong.dart';

class MapElementModel {
  String id;
  String parent_id;
  String name;
  int point_type;
  double co2_value;
  double common;
  double physical;
  double chemical;
  double biological;
  double indicateValue;
  String text_value;
  LatLng? point;
  List<LatLng> borders;

  MapElementModel(
      this.id,
      this.parent_id,
      this.name,
      this.point_type,
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

  factory MapElementModel.fromJson(dynamic data) {
    var point = [];
    if (data['point'].runtimeType == String){point = json.decode(data['point']);}
    else {point = data['point'];}

    var borders = [];
    if (data['borders'].runtimeType == String){borders = json.decode(data['borders']);}
    else {borders = data['borders'];}

    var current_values = {};
    if (data['current_values'].runtimeType == String){current_values = json.decode(data['current_values']);}
    else {borders = data['current_values'];}

    return MapElementModel(
      data['_id'] ?? '', //this.id,
      data['parent_id'] ?? '', //this.parent_id,
      data['name'] ?? '', //this.name,
      int.parse(data['point_type']) ?? 1, //this.point_type,
      current_values['co2_value'] ?? 0.0,//this.co2_value,
      current_values['com'] ?? 0.0, //this.common,
      current_values['phys'] ?? 0.0, //this.physical,
      current_values['chem'] ?? 0.0, //this.chemical,
      current_values['bio'] ?? 0.0, //this.biological,
      current_values['indicate_value'] ?? 0.0, //this.indicateValue,
      // current_values['text_value'] ?? 'Нет данных', //this.text_value,
      '',
      LatLng(point[0], point[1])  ?? null, //this.point,
      borders.map<LatLng>((rec) => LatLng(rec[0], rec[1])).toList() ?? [], //this.borders,
    );
  }
}
