import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api.dart';
import '../models/device.dart';
import '../widgets/recommend.dart';


class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {

  var api = GetIt.I<Api>();

  int cntDevices = 0;

  final ButtonStyle button_style =
  ElevatedButton.styleFrom(
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );


  Future<void> _loadDevices() async {
    var response = await api.getDevices();
    dynamic data = json.decode(response.data);
    setState(() {
      cntDevices = data['data'].length;
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
      appBar: AppBar(
          title: const Text('Устройства'),
          automaticallyImplyLeading: false,),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox.expand(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Мои устройства'),
                      Divider(),
                      Text('Для диагностики биологического здоровья почв выберите список устройств ниже или нажмите на "Начать диагностирование"'),
                      Card(
                        child: ListTile(
                          title: Text('${cntDevices} наборов'),
                          subtitle: Text('Набор для диагностирования индекса микробиологической активности почвы'),
                          trailing: GestureDetector(
                              onTap: (){Navigator.of(context).pushNamed('/devices/list');},
                              child: Icon(Icons.arrow_forward_ios_sharp)),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: button_style,
                            onPressed: (){Navigator.of(context).pushNamed('/devices/diagnostic');},
                            child: Column(
                                children: [
                                  Icon(Icons.speed),
                                  Text("Начать диагностирования")
                                ]
                            )
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            style: button_style,
                            onPressed: null,
                            icon: Icon(Icons.add),
                            label: Text('Добавить еще одно устройство')
                        ),
                      ),
                      Divider(),
                      Text('Наши диагностирующие устройства'),
                      Text('Онлайн серия', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('Получать объективные данные = принимать верные решения!'
                          'Капсулы с датчиками и метеостанцией для онлайн контроля за посевными площадами.'
                          'Позволяет замерять:'),
                      ItemList(data_items: [
                        'Минеральный азот',
                        'Нитратный азот',
                        'Общий азот',
                        'Фосфор',
                        'Калий',
                        'Активный углерод',
                        'Магний',
                        'Серу',
                        'Кислотность почвы',
                        'Влажность',
                        'Электропроводность',
                        'Температуру',
                        'Микробиологическую активность'
                      ]),
                      Text('Офлайн серия', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      Text('Определяет биологические ограничения почвы'),
                      Text('Набор для дигностирования индекса микробиологической активности почвы'),
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