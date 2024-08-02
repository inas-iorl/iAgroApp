import 'dart:convert';

import 'package:co2_app_server/models/diagnostic.dart';
import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/utils/notice.dart';
import 'package:co2_app_server/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
import 'package:latlong2/latlong.dart' as ll;
import 'package:permission_handler/permission_handler.dart';
import '../models/api.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';


class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {

  var api = GetIt.I<Api>();
  late String field_id;
  String? diagnostic_id;
  late FieldModel? field = null;
  DiagnosticModel? diagnostic;

  Future<void> _loadField() async {
    var response = await api.getField(field_id);
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        field = FieldModel.fromJson(data['data']);
      });
    }
  }

  Future<void> _loadDiagnostic() async {
    var response = await api.getDiagnostic(diagnostic_id!);
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        diagnostic = DiagnosticModel.fromJson(data['data']);
      });
    }
  }

  @override
  void didChangeDependencies() async {
    var args = ModalRoute.of(context)!.settings.arguments as Map;
    field_id = args["field_id"];
    diagnostic_id = args["diagnostic_id"];
    await _loadField();
    if (diagnostic_id != null) {
      await _loadDiagnostic();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetList = [];

    return Scaffold(
        appBar: AppBar(
          title: Text('Диагностика поля $diagnostic_id'),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: CheckListWidget(field_id: field_id, diagnostic: diagnostic,),
          )
          ,)
    );
  }
}


class CheckListWidget extends StatefulWidget {
  CheckListWidget({super.key, required this.field_id, this.diagnostic});

  String field_id;
  late DiagnosticModel? diagnostic;

  @override
  State<CheckListWidget> createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {

  String device_id = '';
  var api = GetIt.I<Api>();
  bool showMap = false;
  ll.LatLng? point;
  List<Widget> list_widgets = [];

  // var notice = Notify;

  int currentStep = 0;

  List<Widget?> steps = [];

  void complete(int idx){
    setState(() {
      (list_widgets[idx] as CheckListStep).enabled = false;
      currentStep = idx+1;
      (list_widgets[currentStep] as CheckListStep).enabled = true;
    });
  }

  getMapPoint(ll.LatLng poinValue){
    List<maps_toolkit.LatLng> polygon = [
      maps_toolkit.LatLng(43.593498, 76.628047),
      maps_toolkit.LatLng(43.595432, 76.632052),
      maps_toolkit.LatLng(43.59218, 76.635876),
      maps_toolkit.LatLng(43.590158, 76.631142),
    ];

    if (maps_toolkit.PolygonUtil.containsLocation(maps_toolkit.LatLng(poinValue.latitude, poinValue.longitude), polygon, false)){
      setState(() {
        point=poinValue;
        showMap = false;
        complete(1);
        (list_widgets[0] as CheckListStep).enabled = false;
      });
    }
  }

  void scanQR(int idx) async {
    await Permission.camera.request();
    var device_id = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
    // String device_id = '666fef37a9cb413bd56086d2';
    var response = await api.addDiagnostic(device_id, widget.field_id, '');
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        widget.diagnostic = DiagnosticModel.fromJson(data['data']);
        // enList[idx] = false;
        complete(idx);
        int diff = widget.diagnostic!.measure_time!.difference(DateTime.now()).inSeconds;
        Notify.scheduledNotification(
            title: 'Время для измерения',
            body: "${widget.diagnostic?.field_id}",
            seconds: diff
        );
      });
    }
  }

  void selectPoint(int idx) async {
    setState(() {
      showMap = true;
    });
  }

  void moke_scanQR(int idx) async {
    String device_id = '666fef37a9cb413bd56086d2';
    var response = await api.addDiagnostic(device_id, widget.field_id, '');
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        widget.diagnostic = DiagnosticModel.fromJson(data['data']);
        complete(idx);
        int diff = widget.diagnostic!.measure_time!.difference(DateTime.now()).inSeconds;
        // print('diff $diff');
        // print('measure_time ${widget.diagnostic!.measure_time}');
        Notify.scheduledNotification(
            title: 'Время для измерения',
            body: "${widget.diagnostic?.field_id}",
            seconds: diff
        );
      });
    }
  }

  void takeMeasure(int idx) async {
    Permission.camera.request();
    final ImagePicker picker = ImagePicker();
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 480,
      maxWidth: 640,
    );
    var response = await api.co2Sample(widget.diagnostic!.id, photo!.path);;
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        widget.diagnostic = DiagnosticModel.fromJson(data['data']);
      });
    }
    complete(idx);
  }

  @override
  Widget build(BuildContext context) {

    list_widgets = [
      CheckListStep(title: 'Шаг 1', subtitle: 'Подготовьте набор и лопату', enabled: false, itemIcon: Icons.add, onTap: () => complete(0)),
      CheckListStep(title: 'Шаг 2', subtitle: 'Веберите локацию где будет происходить измерение', enabled: false, itemIcon: Icons.add, onTap: () => selectPoint(1)),
      CheckListStep(title: 'Шаг 3', subtitle: 'В выбранной локации выберите место откуда будет взят образец', enabled: false, itemIcon: Icons.add, onTap: () => complete(2)),
      CheckListStep(title: 'Шаг 4', subtitle: 'Извлеките образец земли минимум с глубины в 15см и поместите в транспортный контейнер и плотно закройте крышку', enabled: false, itemIcon: Icons.add, onTap: () => complete(3)),
      CheckListStep(title: 'Шаг 5', subtitle: 'Отсканируйте QR-код с контейнера', enabled: false, itemIcon: Icons.add, onTap: () => scanQR(4)),
      CheckListStep(title: 'Шаг 6', subtitle: 'Приложение уведомит когда надо будет произвести изменение, переходите к следующему участку', enabled: false, itemIcon: Icons.add, onTap: () => complete(5)),
      CheckListStep(title: 'Шаг 7', subtitle: 'Отсканируйте QR-код с контейнера', enabled: false, itemIcon: Icons.add, onTap: () => complete(6)),
      CheckListStep(title: 'Шаг 8', subtitle: 'Подождите 24 часа для срабатывания реактивов', enabled: false, itemIcon: Icons.add, onTap: null),
      CheckListStep(title: 'Шаг 9', subtitle: 'Сфотографируйте содержимое контейнера', enabled: false, itemIcon: Icons.add, onTap: () => takeMeasure(8)),
      CheckListStep(title: 'Шаг 10', subtitle: 'Дождитесь результата', enabled: false, itemIcon: Icons.add)
    ];

    if (widget.diagnostic != null) {
      int date_compare = widget.diagnostic!.measure_time!.compareTo(DateTime?.now());

      if (date_compare <= 0) { // time to measure
        if (widget.diagnostic!.result_image.length > 5){ // image taken
          currentStep = 9;
        } else { // take image
          currentStep = 8;
        }
      }

      if (date_compare > 0) { // waiting
        currentStep = 7;
      }
    }
    else {
      if (point == null && currentStep == 0){
        currentStep = 0;
      }
    }

    if (widget.diagnostic != null){
      if (widget.diagnostic?.result != ''){ // got result
        list_widgets = [
          ResultWidget(diagnoctic: widget.diagnostic!,)
        ];
      } else { // waiting result
        currentStep = 9;
      }
    }

    (list_widgets[currentStep] as CheckListStep).enabled = true;
    return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: showMap ? [MapWidget(position: ll.LatLng(43.59301, 76.631282),onTap: getMapPoint)] : list_widgets);
  }
}


class CheckListStep extends StatelessWidget {
  CheckListStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.itemIcon,
    this.onTap,
    this.enabled = true,
  });

  late var subtitle;
  late var title;
  late var itemIcon;
  final Function()? onTap;
  bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(itemIcon),
      onTap: onTap,
      enabled: enabled,
    );
  }
}

class ResultWidget extends StatelessWidget {
  ResultWidget({
    super.key,
    required this.diagnoctic,
  });

  DiagnosticModel diagnoctic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text('Результат ${diagnoctic.result}'),
          Text('Создан ${diagnoctic.moment}'),
          Text('Измерить в ${diagnoctic.measure_time}'),
          Text('Измерено ${diagnoctic.actual_measure_time}'),
      ]
    );
  }
}


// final int dif = widget.diagnostic!.measure_time!.difference(
//     DateTime.now()).inSeconds;
//
// Widget timer = TimerCountdown(
//   endTime: DateTime.now().add(
//     Duration(
//       seconds: dif,
//     ),
//   ),
//   onEnd: () {
//     print("Timer finished");
//   },
// );