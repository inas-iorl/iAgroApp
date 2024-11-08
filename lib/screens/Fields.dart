import 'dart:convert';
import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/widgets/field_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api.dart';
import '../widgets/recommend.dart';


class FieldsScreen extends StatefulWidget {
  const FieldsScreen({super.key});

  @override
  _FieldsScreenState createState() => _FieldsScreenState();
}

class _FieldsScreenState extends State<FieldsScreen> {

  var api = GetIt.I<Api>();
  late List<FieldModel> fields = [];

  final ButtonStyle button_style =
  ElevatedButton.styleFrom(
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  void showForm(){
    showDialog(
        context: context,
        builder: (context) {
          return formDialog(parent: this);
        });
  }

  Future<void> _loadFields() async {
    var response = await api.getFields();
    dynamic data = json.decode(response.data);
    setState(() {
      fields = data['data'].map<FieldModel>((rec) => FieldModel.fromJson(rec)).toList();
    });
  }

  @override
  void didChangeDependencies() {
    _loadFields();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Поля'),
          automaticallyImplyLeading: false,),
        floatingActionButton: FloatingActionButton(onPressed: (){showForm();}, child: Icon(Icons.add)),
        body: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox.expand(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldListWidget(fields: fields)
                    ],
                  ),
                ),
              )
              ,)
        ),
      ),
    );
  }
}



class formDialog extends StatelessWidget {
  formDialog({super.key, this.data, this.parent});

  Map? data;
  dynamic parent;

  var api = GetIt.I<Api>();

  late TextEditingController name;
  late TextEditingController culture;
  late TextEditingController descr;
  late TextEditingController cadNumber;

  Future<void> saveData() async {
    if (data != null){
      await api.editField(data?['id'], name.text, culture.text, descr.text, cadNumber.text);
    }
    else {
      await api.addField(name.text, culture: culture.text);
    }
    parent._loadFields();
  }

  @override
  Widget build(BuildContext context) {
    if (data != null){
      name = TextEditingController(text: 'поле');
      culture = TextEditingController(text: 'культура');
      cadNumber = TextEditingController(text: '123456');
    }
    else{
      name = TextEditingController(text: '');
      culture = TextEditingController(text: '');
      cadNumber = TextEditingController(text: '');
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),
      contentPadding: EdgeInsets.only(
        top: 10.0,
      ),
      title: Text(
        data == null ? "Добавить поле":"Редактировать",
        style: TextStyle(fontSize: 24.0),
      ),
      content: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите название поля',
                      labelText: 'Название'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: culture,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите культуру поля',
                      labelText: 'Культура'),
                ),
              ),
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    saveData();
                    // Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    data == null ? "Добавить":"Изменить",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
