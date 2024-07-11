import 'dart:convert';
import 'dart:ffi';

import 'package:co2_app_server/models/field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api.dart';
import '../widgets/field_card.dart';
import '../widgets/loading.dart';


class DiagnosticOldScreen extends StatefulWidget {
  @override
  _DiagnosticOldScreenState createState() => _DiagnosticOldScreenState();
}

class _DiagnosticOldScreenState extends State<DiagnosticOldScreen> {

  var api = GetIt.I<Api>();
  late List fields;

  Future<void> _loadData() async {
    var response = await api.getFields();
    fields = json.decode(response.data)['data'].map((rec) => FieldModel.fromJson(rec)).toList();
  }

  final ButtonStyle button_style =
  ElevatedButton.styleFrom(
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Диагностика')),
      body: FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return LoadingWidget();
            case ConnectionState.waiting:
              return LoadingWidget();
            case ConnectionState.none:
              return LoadingWidget();
            case ConnectionState.done:
              return Center(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox.expand(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (var dat in fields)
                            ImageTopCard(image: 'assets/field.jpg',
                                id: dat.id,
                                title: dat.name,
                                subtitle: dat.descr)
                          ],
                        ),
                      ),
                    )
                    ,)
              );
          }
        }
      )

      ,
    );
  }
}
