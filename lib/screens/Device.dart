import 'dart:convert';
import 'package:co2_app_server/models/device.dart';
import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/widgets/field_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/api.dart';
import '../widgets/recommend.dart';


class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {

  var api = GetIt.I<Api>();
  bool _loading = true;
  late String device_id;
  late DeviceModel? device = null;

  @override
  void didChangeDependencies() {
    setState(() {
      _loading = true;
    });
    device_id = ModalRoute.of(context)!.settings.arguments as String;
    _loadDevice();
    setState(() {
      _loading = false;
    });
    super.didChangeDependencies();
  }

  Future<void> _loadDevice() async {
    var response = await api.getDevice(device_id);
    dynamic data = json.decode(response.data);
    setState(() {
      device = DeviceModel.fromJson(data['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Набор')),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    device != null ? DeviceScreenItems(api: api, device: device!) : Text('Загрузка данных')
                  ],
                ),
              ),
            )
            ,)
      ),
    );
  }
}

class DeviceScreenItems extends StatelessWidget {
  DeviceScreenItems({super.key, required this.device, required this.api});

  DeviceModel device;
  Api api;

  TextEditingController name = TextEditingController(text: '');
  TextEditingController field_id = TextEditingController(text: '');

  Future<void> saveData() async {
    await api.editDevice(device.id, device.name, device.field_id);
  }


  @override
  Widget build(BuildContext context) {
    name.text = device.name;
    field_id.text = device.field_id;
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: device.id,
                  labelText: 'Номер набора'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Введите название набора',
                  labelText: 'Название'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: field_id,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Привязанное поле',
                  labelText: 'Поле'),
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                saveData();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Изменить"),
            ),
          ),
        ],
      ),
    );
  }
}
