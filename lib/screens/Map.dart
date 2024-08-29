import 'dart:convert';

import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/models/map_element.dart';
import 'package:co2_app_server/widgets/map/BottomSheet.dart';
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

  int showMarkerElementType = 1;
  int showBorderElementType = 1;
  bool showMarkers = true;
  bool showSubMarkers = false;
  bool showBorders = true;
  bool showSubBorders = false;
  double? zoom;
  var api = GetIt.I<Api>();

  List<MapElementModel> elements = [];
  List<FieldModel> fields = [];
  List<SubFieldModel> subFields = [];

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

    response = await api.getMapElements();
    res = [];
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        elements = data['data'].map<MapElementModel>((rec) => MapElementModel.fromJson(rec)).toList();
      });
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


  List<bool> _selectBioChemPh = <bool>[true, false, false, false];

  List<String> _selectBioChemPhCodes = ['common', 'bio', 'chem', 'phys'];

  String _currentBioChemPhCode = 'common';

  void setBioChemPhCode(code){
    _currentBioChemPhCode = code;
  }

  double markValue(MapElementModel data){
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

  Widget markContainer(MapElementModel data){
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

  List<Marker> elementsToMark() {
    List<Marker> output = [];
    for (var element in elements) {
      if (element.point != null && element.point_type == showMarkerElementType) {
        output.add(Marker(
          point: element.point as LatLng,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              showMenu(element);
              print('markerTap');
            },
            child: markContainer(element),
          ),
        ));
      }

      if (element.point_type == 2 && showMarkerElementType >= 2) {
        output.add(Marker(
          point: element.point as LatLng,
          width: 80,
          height: 80,
          child: Container(
              width: 40.0,
              height: 40.0,
              child: Center(child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Text('${element.name}'),
              ))
          ),
        ));
      }
    }
    return output;
  }

  List<Polygon> elementsToBorder(){
    List<Polygon> output = [];
    for (var element in elements) {
      if (element.borders != null && element.point_type == showBorderElementType) {
        output.add(
            Polygon(
              points: element.borders,
              color: Colors.blue.withOpacity(0.5),
              borderStrokeWidth: 2,
              borderColor: Colors.blue,
            )
        );
      }
    }
    // if (output.length == 0){
    //   for (var element in elements) {
    //     if (element.borders != null && element.point_type == showMarkerElementType-1) {
    //       output.add(
    //           Polygon(
    //             points: element.borders,
    //             color: Colors.blue.withOpacity(0.5),
    //             borderStrokeWidth: 2,
    //             borderColor: Colors.blue,
    //           )
    //       );
    //     }
    //   }
    // }
    return output;
  }


  void showMenu(MapElementModel element){
    showMaterialModalBottomSheet(
      context: context,
      enableDrag: true,
      // builder: (context) => MapBottomSheet(),
      builder: (context) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.75,
            child: SingleChildScrollView(child: MapBottomSheet(element: element)),
          );
        });
  }

  void setMarkerShowType(int _type){
    if (_type != showMarkerElementType){
      setState(() {
        showMarkerElementType = _type;
      });
    }
  }

  void setBorderShowType(int _type){
    if (_type != showBorderElementType){
      setState(() {
        showBorderElementType = _type;
      });
    }
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
                // print('zoom ${position.zoom}');
                setState(() {
                  zoom = position.zoom;
                });

                if (position.zoom! < 11 ){setMarkerShowType(1);setBorderShowType(0);}
                if (position.zoom! < 12.87 && position.zoom! >= 11){setMarkerShowType(1);setBorderShowType(1);}
                if (position.zoom! >= 12.87 && position.zoom! < 14){setMarkerShowType(2);setBorderShowType(2);}
                if (position.zoom! >= 14 ){setMarkerShowType(3);setBorderShowType(2);}
              }
            ),
            children: <Widget>[
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: elementsToMark(),
              ),
              PolygonLayer(
                    polygonCulling: false,
                    polygons: elementsToBorder(),
              ),
            ],
                    ),
          ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Text('$zoom'),
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
            ],
          ),
        ),
        ],
      ),
    );
  }
}
