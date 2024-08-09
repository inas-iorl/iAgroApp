import 'dart:convert';

import 'package:co2_app_server/models/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/api.dart';
import '../models/subfield.dart';

class MapScreen extends StatefulWidget {
const MapScreen({super.key});

@override
State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  bool showMarkers = true;
  bool showSubMarkers = false;
  bool showBorders = true;
  bool showSubBorders = false;
  var api = GetIt.I<Api>();

  List<FieldModel> fields = [];
  List<SubFieldModel> subFields = [];

  // List<LatLng> subFields = [
  //   LatLng(43.594941, 76.623867),
  //   LatLng(43.596414, 76.631126),
  //   LatLng(43.597486, 76.640992),
  //   LatLng(43.591298, 76.622677),
  //   LatLng(43.591557, 76.63137),
  //   LatLng(43.59325, 76.643772),
  //   LatLng(43.587685, 76.622689),
  //   LatLng(43.587831, 76.632052),
  //   LatLng(43.589045, 76.643276),
  //   LatLng(43.58452, 76.623242),
  //   LatLng(43.584219, 76.632049),
  //   LatLng(43.585108, 76.642371),
  // ];

  List<List<LatLng>> subBorders = [
    [
      LatLng(43.593007, 76.618393),
      LatLng(43.593615, 76.6267),
      LatLng(43.598475, 76.626096),
    ],
    [
      LatLng(43.593615, 76.6267),
      LatLng(43.598475, 76.626096),
      LatLng(43.599578, 76.635899),
      LatLng(43.594413, 76.63635),
    ],
    [
      LatLng(43.599578, 76.635899),
      LatLng(43.594413, 76.63635),
      LatLng(43.596242, 76.649572),
      LatLng(43.600321, 76.642802),
    ],
    [
      LatLng(43.592974, 76.618435),
      LatLng(43.589565, 76.618474),
      LatLng(43.589745, 76.627347),
      LatLng(43.593578, 76.626698),
    ],
    [
      LatLng(43.589745, 76.627347),
      LatLng(43.593578, 76.626698),
      LatLng(43.594366, 76.636368),
      LatLng(43.590276, 76.636572),
    ],
    [
      LatLng(43.594366, 76.636368),
      LatLng(43.590276, 76.636572),
      LatLng(43.59193, 76.651503),
      LatLng(43.594197, 76.652922),
      LatLng(43.596223, 76.649548),
    ],
    [
      LatLng(43.589519, 76.618454),
      LatLng(43.585688, 76.618501),
      LatLng(43.585837, 76.627347),
      LatLng(43.589741, 76.627372),
    ],
    [
      LatLng(43.585837, 76.627347),
      LatLng(43.589741, 76.627372),
      LatLng(43.590223, 76.636622),
      LatLng(43.58631, 76.636668),
    ],
    [
      LatLng(43.58631, 76.636668),
      LatLng(43.587266, 76.648547),
      LatLng(43.591865, 76.651488),
      LatLng(43.590253, 76.636617),
    ],
    [
      LatLng(43.585585, 76.618519),
      LatLng(43.584947, 76.618521),
      LatLng(43.583024, 76.627371),
      LatLng(43.585787, 76.627371),
    ],
    [
      LatLng(43.583024, 76.627371),
      LatLng(43.585787, 76.627371),
      LatLng(43.586265, 76.636662),
      LatLng(43.582733, 76.636805),
      LatLng(43.581984, 76.632137),
    ],
    [
      LatLng(43.586243, 76.636629),
      LatLng(43.582768, 76.636788),
      LatLng(43.584298, 76.646718),
      LatLng(43.587282, 76.648533),
    ],
  ];

  void _loadData() async{
    var response = await api.getFields();
    List res = [];
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        fields = data['data'].map<FieldModel>((rec) => FieldModel.fromJson(rec)).toList();
      });
      if (fields.length > 0) {
        _loadSubData();
      }
    }
  }

  void _loadSubData() async{
    List<SubFieldModel> res = [];
    for (var field in fields){
      var response = await api.getSubFields(field.id);
      if (response != null) {
        dynamic data = json.decode(response.data);
        res.addAll(data['data'].map<SubFieldModel>((rec) =>
            SubFieldModel.fromJson(rec)).toList());
      }
    }
    setState(() {
      subFields = res;
    });
  }


  List<Widget> selectBioChemPh = <Widget>[
    Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Text('Общий'),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Text('Биологический'),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Text('Химический'),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Text('Физический'),
    ),
  ];

  List<Widget> selectBioChemPhSub = <Widget>[
    Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Text('Краскосрочный'),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: Text('Долгосрочный'),
    ),
  ];

  List<bool> _selectBioChemPh = <bool>[true, false, false, false];
  List<bool> _selectBioChemPhSub = <bool>[true, false];

  List<String> _selectBioChemPhCodes = ['common', 'bio', 'chem', 'phys'];
  List<String> _selectBioChemPhSubCodes = ['short', 'long'];

  String _currentBioChemPhCode = 'common';
  String _currentBioChemPhSubCode = 'short';

  void setBioChemPhCode(code){
    _currentBioChemPhCode = code;
  }

  void setBioChemPhSubCode(code){
    _currentBioChemPhSubCode = code;
  }

  double markValue(FieldModel data){
    switch (_currentBioChemPhCode){
      case 'common':
        return data.common;
      case 'bio':
        return data.biological;
      case 'chem':
        return data.chemical;
      case 'phys':
        return data.physical;
      default:
        return 0.0;
    }
  }

  Widget markContainer(FieldModel data){
    double value = markValue(data);
    Color valueColor = Colors.lightBlueAccent;
    switch (value){
      case < 5.0:
        valueColor = Colors.redAccent;
        break;
      case >= 5.0 && < 10.0:
        valueColor = Colors.red;
        break;
      case >= 10.0 && < 20.0:
        valueColor = Colors.orange;
        break;
      case >= 20.0 && < 50.0:
        valueColor = Colors.amber;
        break;
      case >= 50.0 && < 100.0:
        valueColor = Colors.lightGreen;
        break;
      default:
        valueColor = Colors.lightBlueAccent;
    }

    return Container(
        width: 20.0,
        height: 20.0,
        child: Center(child: Text('${value}')),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: valueColor,
            border: Border.all(width: 2)));
  }

  double submarkValue(SubFieldModel data){
    switch (_currentBioChemPhCode){
      case 'common':
        return data.common;
      case 'bio':
        return data.biological;
      case 'chem':
        return data.chemical;
      case 'phys':
        return data.physical;
      default:
        return 0.0;
    }
  }

  Widget submarkContainer(SubFieldModel data){
    double value = submarkValue(data);
    Color valueColor = Colors.lightBlueAccent;
    switch (value){
      case < 5.0:
        valueColor = Colors.redAccent;
        break;
      case >= 5.0 && < 10.0:
        valueColor = Colors.red;
        break;
      case >= 10.0 && < 20.0:
        valueColor = Colors.orange;
        break;
      case >= 20.0 && < 50.0:
        valueColor = Colors.amber;
        break;
      case >= 50.0 && < 100.0:
        valueColor = Colors.lightGreen;
        break;
      default:
        valueColor = Colors.lightBlueAccent;
    }

    return Container(
        width: 20.0,
        height: 20.0,
        child: Center(child: Text('${value}')),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: valueColor,
            border: Border.all(width: 2)));
  }

  List<Marker> cordToMark(List<FieldModel> fields){
    List<Marker> output = [];
    for (var field in fields) {
      if (field.point != null) {
        output.add(Marker(
          point: field.point as LatLng,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              showMenu(field);
              print('markerTap');
            },
            child: markContainer(field),
          ),
        ));
      }
    }
    return output;
  }

  List<Polygon> cordToBorder(List<FieldModel> fields){
    List<Polygon> output = [];
    for (var field in fields) {
      output.add(
          Polygon(
            points: field.borders,
            color: Colors.blue.withOpacity(0.5),
            borderStrokeWidth: 2,
            borderColor: Colors.blue,
          )
      );
    }
    return output;
  }

  List<Polygon> cordToSubBorder(List cords){
    List<Polygon> output = [];
    for (var cord in cords) {
      output.add(
          Polygon(
            points: cord,
            color: Colors.green.withOpacity(0.5),
            borderStrokeWidth: 2,
            borderColor: Colors.greenAccent,
          )
      );
    }
    return output;
  }

  List<Marker> cordToSubMark(List<SubFieldModel> fields){
    List<Marker> output = [];
    for (var field in fields) {
      if (field.point != null) {
        output.add(Marker(
          point: field.point as LatLng,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              print('markerTap');
            },
            child: submarkContainer(field),
          ),
        ));
      }
    }
    return output;
  }

  void showMenu(FieldModel field){
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) => Material(
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("""
Ниже среднего

Что это подразумевает?

1. Имеется некоторый потенциал круговорота питательных веществ;
2. Управление пожнивными остатками все еще может быть проблемой при длительном использовании культур с высоким содержанием углерода;
3. Дан небольшой кредит азота
                """),
                ),
              ],
            ),
          )),
    );
  }

  @override
  void didChangeDependencies() {
    _loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карта')),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.refresh), onPressed: () {
        _loadData();
      }),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: FlutterMap(
            options: MapOptions(
              maxZoom: 15,
              onTap: (tapPosition, point){print(point);},
              initialCenter: LatLng(43.59301, 76.631282),
              onPositionChanged: (position, hasGesture) {
                if (position.zoom! >= 13 ){
                  if (showSubMarkers == false) {
                    setState(() {
                      showMarkers = false; showSubMarkers = true;
                      showBorders = false; showSubBorders = true;
                    });
                  }
                } else {
                  if (showSubMarkers == true) {
                    setState(() {
                      showMarkers = true; showSubMarkers = false;
                      showBorders = true; showSubBorders = false;
                    });
                  }
                }
              }
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(40, 40),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  maxZoom: 15,
                  markers: showMarkers ? cordToMark(fields): [],
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              MarkerLayer(
                markers: showSubMarkers ? cordToSubMark(subFields) : [],
              ),
              PolygonLayer(
                    polygonCulling: false,
                    polygons: showBorders ? cordToBorder(fields) : cordToSubBorder(subBorders),
              ),
            ],
                    ),
          ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _selectBioChemPh.length; i++) {
                      _selectBioChemPh[i] = i == index;
                    }
                    setBioChemPhCode(_selectBioChemPhCodes[index]);
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 60.0,
                ),
                isSelected: _selectBioChemPh,
                children: selectBioChemPh,
              ),
              SizedBox(height: 10),
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _selectBioChemPhSub.length; i++) {
                      _selectBioChemPhSub[i] = i == index;
                    }
                    setBioChemPhSubCode(_selectBioChemPhSubCodes[index]);
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 60.0,
                ),
                isSelected: _selectBioChemPhSub,
                children: selectBioChemPhSub,
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
