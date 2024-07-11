import 'dart:convert';
import 'package:co2_app_server/models/device.dart';
import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/widgets/device_list.dart';
import 'package:co2_app_server/widgets/field_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/api.dart';
import '../widgets/recommend.dart';


class DevicesListScreen extends StatefulWidget {
  const DevicesListScreen({super.key});

  @override
  _DevicesListScreenState createState() => _DevicesListScreenState();
}

class _DevicesListScreenState extends State<DevicesListScreen> {

  var api = GetIt.I<Api>();
  late List<DeviceModel> devices = [];

  void showForm(){
    showDialog(
        context: context,
        builder: (context) {
          return formDialog(parent: this);
        });
  }

  Future<void> _loadDevices() async {
    var response = await api.getDevices();
    dynamic data = json.decode(response.data);
    setState(() {
      devices = data['data'].map<DeviceModel>((rec) => DeviceModel.fromJson(rec)).toList();
    });
  }

  @override
  void didChangeDependencies() {
    _loadDevices();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои устройства')),
      floatingActionButton: FloatingActionButton(onPressed: (){showForm();}, child: Icon(Icons.add)),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DeviceListWidget(devices: devices)
                  ],
                ),
              ),
            )
            ,)
      ),
    );
  }
}



class formDialog extends StatelessWidget {
  formDialog({super.key, this.data, this.parent});

  Map? data;
  dynamic parent;

  var api = GetIt.I<Api>();

  late TextEditingController device_id;
  late TextEditingController name;
  late TextEditingController field_id;

  Future<void> saveData() async {
    if (data != null){
      await api.editDevice(data?['id'], name.text, field_id.text);
    }
    else {
      await api.addDevice(device_id.text, name.text, field_id.text);
    }
    parent._loadDevices();
  }

  Future<void> scanDeviceCode() async {
    await Permission.camera.request();
    var scan = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    device_id.text = scan;
  }

  @override
  Widget build(BuildContext context) {
    if (data != null){
      name = TextEditingController(text: 'Имя');
      field_id = TextEditingController(text: 'Поле');
      device_id = TextEditingController(text: 'Код набора');
    }
    else{
      name = TextEditingController(text: '');
      field_id = TextEditingController(text: '');
      device_id = TextEditingController(text: '');
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
        data == null ? "Добавить устройство":"Редактировать",
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
                  controller: device_id,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){scanDeviceCode();},
                        icon: Icon(Icons.qr_code_scanner),
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Код набора',
                      labelText: 'Код набора'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите название устройства',
                      labelText: 'Название'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: field_id,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите поле',
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
                    // Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
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
