import 'dart:convert';

import 'package:co2_app_server/models/recommends.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api.dart';


class RecommendTab extends StatefulWidget {
  const RecommendTab({super.key});

  @override
  _RecommendTabState createState() => _RecommendTabState();
}

class _RecommendTabState extends State<RecommendTab> {

  var api = GetIt.I<Api>();

  late RecommendItemModel recomment_item;

  // Future<void> _loadWeather() async {
  //   var response = await api.loadRecommends(1);
  //   recomment_item = RecommendItemModel.fromJson(json.decode(response.data)['data']);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Рекомендации'),
        automaticallyImplyLeading: false,),
      body:
      Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Text('Рекомендации по управлению ограничениями',
                    textAlign: TextAlign.center),
                  ),
                ),
                Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                          onPressed: (){Navigator.of(context).pushNamed('/recommend/biological');},
                          child: Text('Биологические')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                          onPressed: (){Navigator.of(context).pushNamed('/recommend/physical');},
                          child: Text('Физические')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                          onPressed: (){Navigator.of(context).pushNamed('/recommend/chemical');},
                          child: Text('Химические')),
                    ),
                  ],
                )
              ],
            )
            ,)
      ),
    );
  }
}