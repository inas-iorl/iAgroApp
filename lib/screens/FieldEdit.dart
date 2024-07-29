import 'dart:convert';
import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/widgets/field_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/api.dart';
import '../widgets/recommend.dart';


class FieldScreen extends StatefulWidget {
  const FieldScreen({super.key});

  @override
  _FieldScreenState createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldScreen> {

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
      appBar: AppBar(title: const Text('Редакрировать')),
      // floatingActionButton: FloatingActionButton(onPressed: (){showForm();}, child: Icon(Icons.add)),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    field != null ? FieldScreenItems(api: api, field: field!) : Text('Грузим')
                  ],
                ),
              ),
            )
            ,)
      ),
    );
  }
}

class FieldScreenItems extends StatelessWidget {
  FieldScreenItems({super.key, required this.field, required this.api});

  FieldModel field;
  Api api;

  TextEditingController name = TextEditingController(text: '');
  TextEditingController culture = TextEditingController(text: '');
  TextEditingController descr = TextEditingController(text: '');

  Future<void> saveData() async {
    await api.editField(field.id, field.name, field.culture, field.descr, '');
  }

  Future<void> pickImage() async {
    Permission.camera.request();
    final ImagePicker picker = ImagePicker();
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 480,
      maxWidth: 640,
    );
    api.setFieldImage(field.id, photo!.path);
  }

  @override
  Widget build(BuildContext context) {
    name.text = field.name;
    culture.text = field.culture;
    descr.text = field.descr;
    return Center(
      child: Column(
        children: [
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
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: culture,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Введите описание поля',
                  labelText: 'Описание'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: culture,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Введите описание поля',
                  labelText: 'Описание'),
            ),
          ),
          Container(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                field.image != '' ? Image.network("https://cabinet.btcom.kz/static/user/fields/${field.image}") : Container(),
                IconButton(icon: Icon(Icons.camera_alt), onPressed: () => pickImage())
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // saveData();
                // Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Изменить"),
            ),
          ),
          Text("${field.co2_value}"),
        ],
      ),
    );
  }
}
