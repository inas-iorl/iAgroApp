import 'dart:convert';

import 'package:latlong2/latlong.dart';

class FieldModel {
  String id;
  String image;
  String name;
  String descr;
  String culture;
  double co2_value;
  double common;
  double physical;
  double chemical;
  double biological;
  double indicateValue;
  String text_value;
  LatLng? point;
  List<LatLng> borders;

  FieldModel(
      this.id,
      this.image,
      this.name,
      this.descr,
      this.culture,
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

  factory FieldModel.fromJson(dynamic data) {
    var borders;
    var point;
    var current_values = json.decode(data['current_values']);
    if (data['point'].runtimeType == String){
      point = json.decode(data['point']);
    } else {
      point = data['point'];
    }
    if (data['borders'].runtimeType == String){
      borders = json.decode(data['borders']);
    } else {
      borders = data['borders'];
    }
    return FieldModel(
      data['_id'] ?? '', //this.id,
      data['image'] ?? '', //this.image,
      data['name'] ?? '', //this.name,
      data['descr'] ?? '', //this.descr,
      data['culture'] ?? '', //this.culture,
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