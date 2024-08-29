import 'dart:convert';

import 'package:co2_app_server/models/field.dart';
import 'package:co2_app_server/models/weather.dart';
import 'package:co2_app_server/widgets/loading.dart';
import 'package:co2_app_server/widgets/weather.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../models/api.dart';
import '../widgets/announcement.dart';
import '../widgets/field_card.dart';
import '../widgets/field_combi.dart';
import '../widgets/field_info.dart';


class MyFieldScreen extends StatefulWidget {
  const MyFieldScreen({super.key});

  @override
  State<MyFieldScreen> createState() => _MyFieldScreenState();
}

class _MyFieldScreenState extends State<MyFieldScreen> {

  var api = GetIt.I<Api>();

  late FieldWeather? weather = null;
  late FieldDetailModel? field_detail;
  late FieldModel? field = null;
  late String? announce_msg = null;

  Future<void> _loadWeather() async {
    var response = await api.loadWeather('1');
    weather = FieldWeather.fromJson(json.decode(response.data)['data']);
  }

  Future<void> _loadFieldDetail() async {
    var response = await api.loadFieldDetail('1');
    if (response != null) {
      field_detail =
          FieldDetailModel.fromJson(json.decode(response.data)['data']);
    }
  }


  Future<void> _loadAnnoucement() async {
    var response = await api.loadAnnouncement('');
    announce_msg = json.decode(response.data)['data']['msg'];
  }

  Future<void> _loadField() async {
    var response = await api.getFields();
    if (response != null){
      dynamic data = json.decode(response.data);
      // setState(() {
        field = FieldModel.fromJson(data['data'][0]);
      // });
    }
  }

  Future<dynamic> _loadData() async {
    setState(() async {
      await _loadWeather();
      await _loadAnnoucement();
      await _loadFieldDetail();
      await _loadField();
    });
  }

  final ButtonStyle button_style =
  ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  );

  @override
  void didChangeDependencies() {
    _loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> widgetList = [];

    widgetList.add(
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: button_style,
              onPressed: (){Navigator.of(context).pushNamed('/devices');},
              child: Text('Устройства')
          ),
        ),
      ),
    );

    if (field != null) {
      widgetList.add(CombiCard(title: field!.name,
          subtitle: field!.descr,
          image: field!.image,
          co2Value: field!.co2_value,
          text_value: field!.text_value,
          indicateValue: field!.indicateValue)
      );
    } else {
      widgetList.add(Text('Добро пожаловать в iAgroInApp'));
      widgetList.add(TextButton(onPressed: (){Navigator.of(context).pushNamed('/fields');},
          child: Text('Добавьте первое поле')));
    }
    if (weather != null){
      widgetList.add(WeatherWidget(temp: weather!.temp,
          wind: weather!.wind, humidity: weather!.humidity,
          wind_dir: weather!.wind_dir, sky: weather!.sky));
    }
    if (field != null){
      widgetList.add(FieldInfoWidget(co2_value: field!.co2_value, gauge_value: field!.indicateValue, text_value: field!.text_value,));
      widgetList.add(Text('Обновленно ${DateTime.now().toString()}'));
    }
    if(announce_msg != null){
      widgetList.add(Announcement(msg: announce_msg!, goto: ''));
    }

    if (field != null){
      widgetList.add(Divider());
      widgetList.add(FieldPropertyCard(texture_class: 'Пылеватый суглинок', details: {"Песок": 5, "Ил": 85, "Глина": 10}));
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('Мое поле'),
          automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.active: return LoadingWidget();
            case ConnectionState.waiting: return LoadingWidget();
            case ConnectionState.done:
              return Center(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: widgetList,
                      ),
                    )
                    ,)
              );
            default: return const Text('loading');
          }
        },
      )
    );
  }
}

