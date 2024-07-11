import 'package:flutter/material.dart';

final ButtonStyle buttonStyle =
ElevatedButton.styleFrom(
  shape:RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
);

class Announcement extends StatelessWidget {
  const Announcement({required this.msg, required this.goto});

  final String msg;
  final String goto;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Внимание'),
            subtitle: Text(msg),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
                child: Text("Подробнее"),
                style: buttonStyle,
                onPressed: null
            ),
          )
        ],
      ),
    );
  }
}

