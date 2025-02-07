import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api.dart';
import '../models/map_element.dart';

class ElementDataWidget extends StatefulWidget {
  ElementDataWidget({super.key, required this.element});
  MapElementModel element;


  @override
  State<ElementDataWidget> createState() => _ElementDataWidgetState();
}

class _ElementDataWidgetState extends State<ElementDataWidget> {

  List<MapElementDataModel> element_data = [];
  var api = GetIt.I<Api>();

  void loadData() async {
    var response = await api.getElementDataLatest(widget.element.id);
    dynamic data = json.decode(response.data);
    // print(data['data']);
    setState(() {
      element_data = data['data'].map<MapElementDataModel>((rec) => MapElementDataModel.fromJson(rec)).toList();
    });
  }

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dataItems = [];

    if (element_data.length > 0) {
      element_data.forEach((rec) =>
          dataItems.add(ElementDataRecWidget(record: rec,)));
    } else {dataItems.add(Text("Loading"));}


    return Column(children: dataItems);
    // return Column(
    //   children: [
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //     ListTile(title: Text("123")),
    //   ],
    // );
    // return ListView.separated(
    //     padding: const EdgeInsets.all(8),
    //     itemCount: element_data.length,
    //     separatorBuilder: (BuildContext context, int index) => const Divider(),
    //     itemBuilder: (BuildContext context, int index) {
    //       return ListTile(title: Text('${index}'),);
    //     }
    // );
  }
}


class ElementDataRecWidget extends StatelessWidget {
  ElementDataRecWidget({super.key, required this.record});
  MapElementDataModel record;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Container(child: Text("${record.moment} ${record.source}")));
    record.items.forEach((rec) => widgets.add(ElementDataGroupWidget(record: rec)));
    return Column(children: widgets);
  }
}

class ElementDataGroupWidget extends StatelessWidget {
  ElementDataGroupWidget({super.key, required this.record});
  MapElementGroupModel record;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    if (record.items.isNotEmpty){
      record.items.forEach((rec) => widgets.add(ElementDataGroupItemWidget(record: rec)));
    } else {widgets.add(Text(record.value));}
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child: Text(record.name), width: 100,),
          Column(children: widgets, crossAxisAlignment: CrossAxisAlignment.end,),
        ],
      ),
    );
  }
}

class ElementDataGroupItemWidget extends StatelessWidget {
  ElementDataGroupItemWidget({super.key, required this.record});
  MapElementDataItemModel record;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("${record.name} - ${record.value}"));
  }
}
