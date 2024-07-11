import 'package:co2_app_server/widgets/weather.dart';
import 'package:flutter/material.dart';

class CombiCard extends StatelessWidget {
  const CombiCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.indicateValue,
    required this.co2Value,
    required this.text_value,
  });

  final String title;
  final String subtitle;
  final String image;
  final double indicateValue;
  final double co2Value;
  final String text_value;

  Color getIndicateColor(double value){
    switch (value){
      case <= 15: return Colors.red;
      case <= 30: return Colors.redAccent;
      case <= 45: return Colors.orange;
      case <= 60: return Colors.yellow;
      case <= 75: return Colors.lime;
      case <= 90: return Colors.lightGreenAccent;
      case <= 100: return Colors.green;
      default: return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = image == '' ? Image.asset('assets/field.jpg') : Image.network("https://cabinet.btcom.kz/static/user/fields/${image}");
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        // color: Colors.indigo[50],
        decoration: BoxDecoration(
          color: Colors.indigo[50],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(child: imageWidget, height: 80, width: 80),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(title), Text(subtitle)],
                    ),
                    Column(
                      children: [
                        IconText(text: '${indicateValue}', icon: Icon(Icons.circle, color: getIndicateColor(indicateValue))),
                        Text(text_value),
                        Text('${co2Value} мгС/м2')
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}