import 'package:co2_app_server/models/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../models/subfield.dart';

class MapPointLayer extends StatefulWidget {
  MapPointLayer({super.key});

  String _currentBioChemPhCode = 'common';
  bool showMarkers = true;
  bool showSubMarkers = false;

  List<FieldModel> fields = [];
  List<SubFieldModel> subFields = [];

  @override
  State<MapPointLayer> createState() => _MapPointLayerState();
}

class _MapPointLayerState extends State<MapPointLayer> {

  double submarkValue(SubFieldModel data){
    switch (widget._currentBioChemPhCode){
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

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      // markers: showSubMarkers ? cordToSubMark(subFields) : [],
      markers: widget.showSubMarkers ? cordToSubMark(subFields) : [],
    );
  }
}

