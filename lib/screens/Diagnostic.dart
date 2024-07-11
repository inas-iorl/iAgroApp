import 'dart:convert';

import 'package:co2_app_server/models/diagnostic.dart';
import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/utils/notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
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

  late CheckListStep step1;
  late CheckListStep step2;
  late CheckListStep step3;
  late CheckListStep step4;
  late CheckListStep step5;
  late CheckListStep step6;
  late CheckListStep step7;
  late CheckListStep step8;
  late CheckListStep step9;
  late CheckListStep step10;

  String device_id = '';
  var api = GetIt.I<Api>();

  // var notice = Notify;

  List<bool> enList = [false,false,false,false,false,false,false,false,false,false,false];


  List<Widget?> steps = [];

  void complete(int idx){
    setState(() {
      enList[idx] = false;
      if (enList.asMap().containsKey(idx+1)){
        enList[idx+1] = true;
      }
    });
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
        enList[idx] = false;
        int diff = widget.diagnostic!.measure_time!.difference(DateTime.now()).inSeconds;
        Notify.scheduledNotification(
            title: 'Время для измерения',
            body: "${widget.diagnostic?.field_id}",
            seconds: diff
        );
      });
    }
  }

  void moke_scanQR(int idx) async {
    String device_id = '666fef37a9cb413bd56086d2';
    var response = await api.addDiagnostic(device_id, widget.field_id, '');
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        widget.diagnostic = DiagnosticModel.fromJson(data['data']);
        enList[idx] = false;
        int diff = widget.diagnostic!.measure_time!.difference(DateTime.now()).inSeconds;
        print('diff $diff');
        print('measure_time ${widget.diagnostic!.measure_time}');
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
    List<Widget> list_widgets = [];
    if (widget.diagnostic != null) {
      enList[0] = false;
      int date_compare = widget.diagnostic!.measure_time!.compareTo(DateTime?.now());

      if (date_compare <= 0) { // time to measure

        if (widget.diagnostic!.result_image.length > 5){ // image taken
          enList[9] = true;
        } else { // take image
          enList[8] = true;
        }
      }

      if (date_compare > 0) { // waiting
        enList[7] = true;
      }
    }
    else {
      enList[0] = true;
    }

  step1 = CheckListStep(title: 'Шаг 1', subtitle: 'Подготовьте набор и лопату', enabled: enList[0], itemIcon: Icons.add, onTap: () => complete(0));
  step2 = CheckListStep(title: 'Шаг 2', subtitle: 'Веберите локацию где будет происходить измерение', enabled: enList[1], itemIcon: Icons.add, onTap: () => complete(1));
  step3 = CheckListStep(title: 'Шаг 3', subtitle: 'В выбранной локации выберите место откуда будет взят образец', enabled: enList[2], itemIcon: Icons.add, onTap: () => complete(2));
  step4 = CheckListStep(title: 'Шаг 4', subtitle: 'Извлеките образец земли минимум с глубины в 15см и поместите в транспортный контейнер и плотно закройте крышку', enabled: enList[3], itemIcon: Icons.add, onTap: () => complete(3));
  step5 = CheckListStep(title: 'Шаг 5', subtitle: 'Отсканируйте QR-код с контейнера', enabled: enList[4], itemIcon: Icons.add, onTap: () => scanQR(4));
  step6 = CheckListStep(title: 'Шаг 6', subtitle: 'Приложение уведомит когда надо будет произвести изменение, переходите к следующему участку', enabled: enList[5], itemIcon: Icons.add, onTap: () => complete(5));
  step7 = CheckListStep(title: 'Шаг 7', subtitle: 'Отсканируйте QR-код с контейнера', enabled: enList[6], itemIcon: Icons.add, onTap: () => complete(6));
  step8 = CheckListStep(title: 'Шаг 8', subtitle: 'Подождите 24 часа для срабатывания реактивов', enabled: enList[7], itemIcon: Icons.add, onTap: null);
  step9 = CheckListStep(title: 'Шаг 9', subtitle: 'Сфотографируйте содержимое контейнера', enabled: enList[8], itemIcon: Icons.add, onTap: () => takeMeasure(8));
  step10 = CheckListStep(title: 'Шаг 10', subtitle: 'Дождитесь результата', enabled: enList[9], itemIcon: Icons.add);

  list_widgets.add(step1);
  list_widgets.add(step2);
  list_widgets.add(step3);
  list_widgets.add(step4);
  list_widgets.add(step5);
  list_widgets.add(step6);
  list_widgets.add(step7);
  list_widgets.add(step8);
  list_widgets.add(step9);
  list_widgets.add(step10);

  if (widget.diagnostic != null){
    if (widget.diagnostic?.result != ''){ // got result
      list_widgets = [
        ResultWidget(diagnoctic: widget.diagnostic!,)
      ];
    } else { // waiting result
      enList[9] = true;
    }
  }


  return Column(
  mainAxisAlignment: MainAxisAlignment.start,
  children: list_widgets);
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