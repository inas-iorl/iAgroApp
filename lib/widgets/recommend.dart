import 'package:flutter/material.dart';

class DataElement extends StatelessWidget {
  const DataElement({
    required this.el_title,
    required this.data_list,
    required this.card_list
  });

  final String el_title;
  final List<dynamic> data_list;
  final List<dynamic> card_list;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text(el_title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        children: <Widget>[
          Container(
              child: Column(
                  children: [
                    ItemList(data_items: data_list),
                    // Divider(),
                    Text('или', style: TextStyle(fontSize: 20)),
                    CardList(data_items: card_list)
                  ]
              )

          )
        ]
    );
  }
}

class ItemList extends StatelessWidget {
  const ItemList({required this.data_items});

  final List<dynamic> data_items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.builder(
        itemCount: data_items.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.circle, size: 10),
            title: Text(data_items[index]),
          );
        },
      ),
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({required this.data_items});

  final List<dynamic> data_items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data_items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return AppCard(card_data: data_items[index]);
      },
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    required this.card_data
  });

  final List<dynamic> card_data;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Text('Рекомендации по управлению биологическими ограничениями')
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              title: Text(this.card_data[0]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(this.card_data[1]),
                  Text(this.card_data[2]),
                ],
              )
          )
        ],
      ),
    );
  }
}