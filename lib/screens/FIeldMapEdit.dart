import 'dart:convert';
import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/widgets/field_list.dart';
import 'package:co2_app_server/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../models/api.dart';
import '../widgets/recommend.dart';


class FieldMapEditScreen extends StatefulWidget {
  const FieldMapEditScreen({super.key});

  @override
  _FieldMapEditScreenState createState() => _FieldMapEditScreenState();
}

class _FieldMapEditScreenState extends State<FieldMapEditScreen> {

  var api = GetIt.I<Api>();
  bool _loading = true;
  late String field_id;
  late FieldModel? field = null;

  @override
  void didChangeDependencies() {
    setState(() {
      _loading = true;
    });
    field_id = ModalRoute.of(context)!.settings.arguments as String;
    _loadField();
    setState(() {
      _loading = false;
    });
    super.didChangeDependencies();
  }

  Future<void> _loadField() async {
    var response = await api.getField(field_id);
    dynamic data = json.decode(response.data);
    setState(() {
      field = FieldModel.fromJson(data['data']);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редакрировать карту')),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    field != null ? FieldMapEdit(api: api, field: field!) : Text('Грузим')
                  ],
                ),
              ),
            )
            ,)
      ),
    );
  }
}

class FieldMapEdit extends StatelessWidget {
  FieldMapEdit({super.key, required this.field, required this.api});

  FieldModel field;
  Api api;
  List<LatLng> newPoints = [];

  // Future<void> saveData() async {
  //   await api.editFieldMap(field.id, newPoints);
  // }

  addMapBound(ll.LatLng poinValue){
    print(poinValue);
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(position: ll.LatLng(43.59301, 76.631282), showPlace: true, showBoundaryPoints: true, onLongPress: addMapBound,);
  }
}

// class FieldMapEdit extends StatefulWidget {
//   FieldMapEdit({super.key, required this.field, required this.api});
//
//   FieldModel field;
//   Api api;
//   List<LatLng> newPoints = [];
//
//   @override
//   State<FieldMapEdit> createState() => _FieldMapEditState();
// }
//
// class _FieldMapEditState extends State<FieldMapEdit> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

