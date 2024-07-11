import 'dart:convert';
import 'package:co2_app_server/models/diagnostic.dart';
import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/widgets/field_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api.dart';
import '../widgets/diagnostic.dart';
import '../widgets/recommend.dart';


class DiagnosticListScreen extends StatefulWidget {
  const DiagnosticListScreen({super.key});

  @override
  _DiagnosticListScreenState createState() => _DiagnosticListScreenState();
}

class _DiagnosticListScreenState extends State<DiagnosticListScreen> {

  var api = GetIt.I<Api>();
  late String field_id;
  List<DiagnosticModel> diagnostics = [];

  final ButtonStyle button_style =
  ElevatedButton.styleFrom(
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );


  Future<void> _loadDIagnostics() async {
    var response = await api.getFieldDiagnostics(field_id);
    dynamic data = json.decode(response.data);
    setState(() {
      diagnostics = data['data'].map<DiagnosticModel>((rec) => DiagnosticModel.fromJson(rec)).toList();
    });
  }

  @override
  void didChangeDependencies() {
    field_id = ModalRoute.of(context)!.settings.arguments as String;
    _loadDIagnostics();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Активные замеры')),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DiagnosticListWidget(diagnostics: diagnostics)
                  ],
                ),
              ),
            )
            ,)
      ),
    );
  }
}
