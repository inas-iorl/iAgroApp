import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api.dart';
import '../models/recommends.dart';
import '../widgets/loading.dart';
import '../widgets/recommend.dart';

class ChemicalScreen extends StatefulWidget {
  @override
  _ChemicalScreenState createState() => _ChemicalScreenState();
}

class _ChemicalScreenState extends State<ChemicalScreen> {

  var api = GetIt.I<Api>();

  late List recommends_short;
  late List recommends_long;
  late List current_list;
  bool show_short = true;

  Future<void> _loadData() async {
    var response = await api.loadRecommendChem(1);
    recommends_short = json.decode(response.data)['data']['short'].map((rec) => RecommendItemModel.fromJson(rec)).toList();
    recommends_long = json.decode(response.data)['data']['long'].map((rec) => RecommendItemModel.fromJson(rec)).toList();
    if (show_short == true){current_list = recommends_short;}
    else {current_list = recommends_long;}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Химические'),
        ),
        body: FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active: return LoadingWidget();
              case ConnectionState.waiting: return LoadingWidget();
              case ConnectionState.none:  return LoadingWidget();
              case ConnectionState.done:  //return Text('loading');
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        child: Text('Рекомендации по управлению химическими ограничениями'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(onPressed: (){setState(() { current_list = recommends_short; show_short = true; });}, child: Text('Краскосрочные')),
                          ElevatedButton(onPressed: (){setState(() { current_list = recommends_long; show_short = false; });}, child: Text('Долгосрочные')),
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            for ( var pd in current_list )
                              DataElement(el_title: pd.title as String,
                                  data_list: pd.main,
                                  card_list: pd.alternate)
                          ],
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        )
    );
  }
}



