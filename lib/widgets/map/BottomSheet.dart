import 'package:co2_app_server/models/map_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

import '../field_combi.dart';
import '../field_info.dart';

// class TimeSeriesSales {
//   final DateTime time;
//   final int sales;
//
//   TimeSeriesSales(this.time, this.sales);
// }
//
// final timeSeriesSales = [
//   TimeSeriesSales(DateTime(2017, 9, 19), 5),
//   TimeSeriesSales(DateTime(2017, 9, 26), 25),
//   TimeSeriesSales(DateTime(2017, 10, 3), 100),
//   TimeSeriesSales(DateTime(2017, 10, 10), 75),
// ];

// final _monthDayFormat = DateFormat('MM-dd');

class MapBottomSheet extends StatefulWidget {
  MapBottomSheet({super.key, required this.element});
  late TabController _controller;
  MapElementModel element;

  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {

  int _mainTextIndexSelected = 0;


  Widget _text(){
    return Text("""
Ниже среднего

Что это подразумевает?

1. Имеется некоторый потенциал круговорота питательных веществ;
2. Управление пожнивными остатками все еще может быть проблемой при длительном использовании культур с высоким содержанием углерода;
3. Дан небольшой кредит азота
                """);
  }

  Widget mainTabWidget(){
    switch (_mainTextIndexSelected){
      case 0:
        return RecommendWidget();
      case 1:
        return DiagnosticWidget();
      case 2:
        return DetailWidget(element: widget.element);
      default:
        return RecommendWidget();
    }
  }

  @override
  void didChangeDependencies() {
    print(widget.element);
    super.didChangeDependencies();
  }

  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [
              DefaultTabController(
                length: 3,
                child: DefaultTabControllerListener(
                  onTabChanged: (value) {
                    setState(() {
                      print(value);
                      _mainTextIndexSelected = value;
                    });
                  },
                  child: TabBar(
                    tabs: [
                      Tab(text: 'Рекомендации',),
                      Tab(text: 'Диагностика',),
                      Tab(text: 'Детали',),
                    ],
                  ),
                ),
              ),
              mainTabWidget(),
            ]
        )
    );

  }
}


class DetailWidget extends StatelessWidget {
  DetailWidget({super.key, required this.element});
  MapElementModel element;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CombiCard(title: element.name, subtitle: '', image: '', indicateValue: 12, co2Value: 13, text_value: ''),
        FieldInfoWidget(co2_value: 3.0, gauge_value: 4.0, text_value: 'yrdy'),
        ListTile(leading: Icon(Icons.science_outlined), title: Text('13.5 - 2024-05-01'), subtitle: Text('Низкие значения'), trailing: Icon(Icons.arrow_forward_ios_outlined),),
        ListTile(leading: Icon(Icons.science_outlined), title: Text('13.5 - 2024-05-01'), subtitle: Text('Низкие значения'), trailing: Icon(Icons.arrow_forward_ios_outlined),),
        ListTile(leading: Icon(Icons.science_outlined), title: Text('13.5 - 2024-05-01'), subtitle: Text('Низкие значения'), trailing: Icon(Icons.arrow_forward_ios_outlined),),
        ListTile(leading: Icon(Icons.science_outlined), title: Text('13.5 - 2024-05-01'), subtitle: Text('Низкие значения'), trailing: Icon(Icons.arrow_forward_ios_outlined),),
        ListTile(leading: Icon(Icons.science_outlined), title: Text('13.5 - 2024-05-01'), subtitle: Text('Низкие значения'), trailing: Icon(Icons.arrow_forward_ios_outlined),),
        ListTile(leading: Icon(Icons.science_outlined), title: Text('13.5 - 2024-05-01'), subtitle: Text('Низкие значения'), trailing: Icon(Icons.arrow_forward_ios_outlined),),
      ],
    );
  }
}


class DiagnosticWidget extends StatelessWidget {
  const DiagnosticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DiagnosticSelectorClusterWidget(),
      ],
    );
  }
}

class DiagnosticSelectorClusterWidget extends StatelessWidget {
  const DiagnosticSelectorClusterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [DiagnosticSelectorWidget(), DiagnosticSelectorWidget()],
          mainAxisAlignment: MainAxisAlignment.spaceAround,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [DiagnosticSelectorWidget(), DiagnosticSelectorWidget()],
              mainAxisAlignment: MainAxisAlignment.spaceAround),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [DiagnosticSelectorWidget(), DiagnosticSelectorWidget()],
              mainAxisAlignment: MainAxisAlignment.spaceAround),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [DiagnosticSelectorWidget(), DiagnosticSelectorWidget()],
              mainAxisAlignment: MainAxisAlignment.spaceAround),
        ),
      ],
    );
  }
}


class DiagnosticSelectorWidget extends StatelessWidget {
  const DiagnosticSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.orange
      ),
      width: 180,
      height: 80,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Icon(Icons.add_call),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
              child: Column(
                children: [
                  Text("Название услуги", style: TextStyle(fontSize: 14.0,)),
                  Text("Жмякни чтобы получить что-то", style: TextStyle(fontSize: 10.0)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}



class RecommendWidget extends StatefulWidget {
  RecommendWidget({super.key});

  @override
  State<RecommendWidget> createState() => _RecommendWidgetState();
}

class _RecommendWidgetState extends State<RecommendWidget> {

  List<String> _recomendlistTextTabToggle = ['Краткосрочные', 'Долгосрочные'];
  int _recomendTextIndexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          // FlutterToggleTab(
          //   width: 90, // width in percent
          //   borderRadius: 30,
          //   height: 50,
          //   selectedIndex: _recomendTextIndexSelected,
          //   selectedBackgroundColors: [Colors.blue, Colors.blueAccent],
          //   selectedTextStyle: TextStyle(
          //       color: Colors.white,
          //       fontSize: 18,
          //       fontWeight: FontWeight.w700),
          //   unSelectedTextStyle: TextStyle(
          //       color: Colors.black87,
          //       fontSize: 14,
          //       fontWeight: FontWeight.w500),
          //   labels: _recomendlistTextTabToggle,
          //   selectedLabelIndex: (index) {
          //     setState(() {
          //       print(index);
          //       _recomendTextIndexSelected = index;
          //     });
          //   },
          //   isScroll:false,
          // ),
          DefaultTabController(
            length: 2,
            child: DefaultTabControllerListener(
              onTabChanged: (value) {
                setState(() {
                  print(value);
                  _recomendTextIndexSelected = value;
                });
              },
              child: TabBar(
                tabs: [
                  Tab(text: 'Краткосрочный',),
                  Tab(text: 'Долгосрочный',),
                ],
              ),
            ),
          ),
          _recomendTextIndexSelected == 0 ? RecomendShortWidget() : RecomendLongWidget(),
        ]
    );
  }
}


class RecomendShortWidget extends StatelessWidget {
  const RecomendShortWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecommendItemWidget(co_value: 0.001, index_value: 'Критичный'),
          Divider(),
          RecommendItemWidget(co_value: 0.905, index_value: 'Средний'),
          Divider(),
          RecommendItemWidget(co_value: 1.156, index_value: 'Выше среднего'),
          Divider(),
          RecommendItemWidget(co_value: 0.156, index_value: 'Ниже среднего'),
        ],
      ),
    );
  }
}

class RecomendLongWidget extends StatelessWidget {
  const RecomendLongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecommendItemWidget(co_value: 0.156, index_value: 'Ниже среднего'),
          Divider(),
          RecommendItemWidget(co_value: 1.156, index_value: 'Выше среднего'),
          Divider(),
          RecommendItemWidget(co_value: 0.905, index_value: 'Средний'),
          Divider(),
          RecommendItemWidget(co_value: 0.001, index_value: 'Критичный'),
        ],
      ),
    );
  }
}



class DetailWidgetContainer extends StatelessWidget {
  const DetailWidgetContainer({super.key, required this.inner});
  final Widget inner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 60,
      decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5,5,2,2),
            child: inner,
          ),
        ),
      ),
    );
  }
}


class DetailCO2Widget extends StatelessWidget {
  const DetailCO2Widget({super.key, required this.co_value});

  final double co_value;

  @override
  Widget build(BuildContext context) {
    return DetailWidgetContainer(
        inner: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CO2', style: TextStyle(fontWeight: FontWeight.bold),),
                Text('мкг/м2', style: TextStyle(fontSize: 11.0),),
              ],
            ),
            Row(
              children: [
                Text('$co_value', style: TextStyle(fontSize: 18.0),),
              ],
            )
          ],
        )
    );
  }
}


class DetailMicroWidget extends StatelessWidget {
  DetailMicroWidget({super.key, required this.index_value});
  String index_value;

  @override
  Widget build(BuildContext context) {
    return DetailWidgetContainer(
        inner: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Индекс микробиологической активности',
              style: TextStyle(fontSize: 8.0),
            ),
            Text(index_value, style:
            TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
          ],
        )
    );
  }
}


class BulletList extends StatelessWidget {
  final List<String> strings;

  BulletList(this.strings);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(16, 15, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u2022',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.55,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    str,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6),
                      height: 1.55,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class RecommendItemWidget extends StatelessWidget {
  RecommendItemWidget({super.key,
    required this.co_value, required this.index_value});
  double co_value;
  String index_value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,8,0,0),
        child: Column(
          children: [
            Text('Усредненное состояние'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DetailCO2Widget(co_value: co_value),
                DetailMicroWidget(index_value: index_value)],
            ),
            Text('Что это подразумевает?'),
            BulletList(
                ['Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  'Praesent porttitor mi in semper malesuada.',
                  'Ut tempor justo ac massa eleifend venenatis.']
            ),
          ],
        ),
      ),
    );
  }
}


class DefaultTabControllerListener extends StatefulWidget {
  const DefaultTabControllerListener({
    required this.onTabChanged,
    required this.child,
    super.key,
  });

  final ValueChanged<int> onTabChanged;

  final Widget child;

  @override
  State<DefaultTabControllerListener> createState() =>
      _DefaultTabControllerListenerState();
}

class _DefaultTabControllerListenerState
    extends State<DefaultTabControllerListener> {
  TabController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final TabController? defaultTabController =
    DefaultTabController.maybeOf(context);

    assert(() {
      if (defaultTabController == null) {
        throw FlutterError(
          'No DefaultTabController for ${widget.runtimeType}.\n'
              'When creating a ${widget.runtimeType}, you must ensure that there '
              'is a DefaultTabController above the ${widget.runtimeType}.',
        );
      }
      return true;
    }());

    if (defaultTabController != _controller) {
      _controller?.removeListener(_listener);
      _controller = defaultTabController;
      _controller?.addListener(_listener);
    }
  }

  void _listener() {
    final TabController? controller = _controller;

    if (controller == null || controller.indexIsChanging) {
      return;
    }

    widget.onTabChanged(controller.index);
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}