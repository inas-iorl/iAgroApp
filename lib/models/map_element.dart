import 'dart:convert';

import 'package:latlong2/latlong.dart';

class MapElementModel {
  int id;
  int parent_id;
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
  int value;

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
      this.value,
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
    else {current_values = {};}

    return MapElementModel(
      data['id'] ?? '', //this.id,
      data['parent_id'] ?? 0, //this.parent_id,
      data['name'] ?? '', //this.name,
      data['element_type_id'] ?? 1, //this.point_type,
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
      data['value'] ?? 0, //this.borders,
    );
  }

  toString(){
    return "${id} ${name}";
  }
}


class MapElementDataItemModel {
  String name;
  String value;

  MapElementDataItemModel(
      this.name,
      this.value,
      );

  factory MapElementDataItemModel.fromJson(dynamic data) {
    // print(data['items']);
    return MapElementDataItemModel(
      data['name'] ?? '', //this.name,
      data['value'] ?? '', //this.code,
    );
  }
}

class MapElementGroupModel {
  String name;
  String code;
  List<MapElementDataItemModel> items;
  String source;
  String value;

  MapElementGroupModel(
      this.name,
      this.code,
      this.items,
      this.source,
      this.value,
      );

  factory MapElementGroupModel.fromJson(dynamic data) {
    List<MapElementDataItemModel> items = [];
    if (data['items'] != null){
      items = data['items'].map<MapElementDataItemModel>((rec) => MapElementDataItemModel.fromJson(rec)).toList();
    }
    return MapElementGroupModel(
      data['name'] ?? '', //this.name,
      data['code'] ?? '', //this.code,
      items, //this.source,
      data['source'] ?? '', //this.source,
      data['value'] ?? '', //this.source,
    );
  }
}

class MapElementDataModel {
  String moment;
  List<MapElementGroupModel> items;
  String source;

  MapElementDataModel(
      this.moment,
      this.items,
      this.source,
      );

  factory MapElementDataModel.fromJson(dynamic data) {
    return MapElementDataModel(
      data['moment'] ?? '', //this.name,
      data['items'].map<MapElementGroupModel>((rec) => MapElementGroupModel.fromJson(rec)).toList() ?? [], //this.code,
      data['source'] ?? '', //this.source,
    );
  }
}