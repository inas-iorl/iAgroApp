import 'dart:convert';

import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/models/weather.dart';
import 'package:co2_app_server/widgets/buttons.dart';
import 'package:co2_app_server/widgets/loading.dart';
import 'package:co2_app_server/widgets/map.dart';
import 'package:co2_app_server/widgets/weather.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../models/api.dart';
import '../widgets/announcement.dart';
import '../widgets/field_card.dart';
import '../widgets/field_combi.dart';
import '../widgets/field_info.dart';
import 'package:latlong2/latlong.dart';


class MyFieldScreen extends StatefulWidget {
  const MyFieldScreen({super.key});

  @override
  State<MyFieldScreen> createState() => _MyFieldScreenState();
}

class _MyFieldScreenState extends State<MyFieldScreen> {

  var api = GetIt.I<Api>();

  late String field_id;

  late FieldWeather? weather = null;
  late FieldDetailModel? field_detail;
  late FieldModel? field = null;
  late String? announce_msg = null;
  late int _diagnostic_cnt = 0;

  Future<void> _loadWeather() async {
    var response = await api.loadWeather(field_id);
    weather = FieldWeather.fromJson(json.decode(response.data)['data']);
  }

  Future<void> _diagnosticCnt() async {
    var response = await api.fieldCntDiagnostic(field_id);
    _diagnostic_cnt = json.decode(response.data)['data'];
  }

  Future<void> _loadFieldDetail() async {
    var response = await api.loadFieldDetail(field_id);
    if (response != null) {
      field_detail =
          FieldDetailModel.fromJson(json.decode(response.data)['data']);
    }
  }


  Future<void> _loadAnnoucement() async {
    var response = await api.loadAnnouncement(field_id);
    announce_msg = json.decode(response.data)['data']['msg'];
  }

  Future<void> _loadField() async {
    var response = await api.getField(field_id);
    if (response != null){
      dynamic data = json.decode(response.data);
      setState(() {
        field = FieldModel.fromJson(data['data']);
      });
    }
  }

  Future<dynamic> _loadData() async {

      await _diagnosticCnt();
      await _loadWeather();
      await _loadAnnoucement();
      await _loadFieldDetail();
      await _loadField();
      setState(() {});
  }

  @override
  void didChangeDependencies() async {
    field_id = ModalRoute.of(context)!.settings.arguments as String;
    await _loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetList = [];

    widgetList.add(StButton(label: 'map', url: '/map'));
    widgetList.add(StButton(label: 'Наборы поля', url: '/devices/list'));
    widgetList.add(StButton(label: 'Начать диагностирования', url: '/devices/diagnostic', arguments: {"field_id": field_id},));
    widgetList.add(StButton(label: 'Активные замеры ${_diagnostic_cnt}', url: '/field/diagnostics', arg: field_id,));

    if (field != null) {
      widgetList.add(CombiCard(title: field!.name,
          subtitle: field!.descr,
          image: field!.image,
          co2Value: field!.co2_value,
          text_value: field!.text_value,
          indicateValue: field!.indicateValue)
      );
    }
    if (weather != null){
      widgetList.add(WeatherWidget(temp: weather!.temp,
          wind: weather!.wind, humidity: weather!.humidity,
          wind_dir: weather!.wind_dir, sky: weather!.sky));
    }
    if (field != null){
      widgetList.add(FieldInfoWidget(co2_value: field!.co2_value, gauge_value: field!.indicateValue, text_value: field!.text_value));
      widgetList.add(Text('Обновленно ${DateTime.now().toString()}'));
      widgetList.add(MapWidget(position: LatLng(43.59301, 76.631282), showPlace: true,));
    }
    if(announce_msg != null){
      widgetList.add(Announcement(msg: announce_msg!, goto: ''));
    }

    if (field != null){
      widgetList.add(Divider());
      widgetList.add(FieldPropertyCard(
          texture_class: field_detail!.texture_class,
          details: field_detail!.details
      ));
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('Мое поле'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Open shopping cart',
              onPressed: () {
                Navigator.of(context).pushNamed('/field/edit', arguments: field_id);
              },
            ),
          ]
      ),
      body: Padding(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: widgetList,
                  ),
                )
                ,)
    );
  }
}

