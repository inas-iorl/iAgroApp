import 'package:flutter/material.dart';

class ImageTopCard extends StatelessWidget {
  const ImageTopCard({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final int id;
  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed('/devices/diagnostic/detail', arguments: id);
              },
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 335,
                      height: 110,
                      child: Image.asset(
                        image,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(subtitle)
                          ]
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}


class FieldCard extends StatelessWidget {
  const FieldCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image.asset(image, fit: BoxFit.fill,),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ],
      ),
    );
  }
}


class FieldPropertyCard extends StatelessWidget {
  const FieldPropertyCard({
    required this.texture_class,
    required this.details
  });

  final String texture_class;
  final Map<String, dynamic> details;

  // 'Песок: 2% - Ил: 83% - Глина: 15%'

  @override
  Widget build(BuildContext context) {
    List t = [];
    details.forEach((key, value) => t.add("${key} - ${value}%"));
    String details_str = t.join(', ');
    return Container(
      width: double.infinity,
      child: Card(
          child: Column(
              children: [
                Text('Измеренный класс текстуры почв:'),
                Text(texture_class),
                Text(details_str),
              ])
      ),
    );
  }
}

