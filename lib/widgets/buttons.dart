import 'package:flutter/material.dart';

class StButton extends StatelessWidget {
  StButton({super.key,
    required this.label,
    required this.url,
    this.arg,
    this.arguments
  });

  String label;
  String url;
  String? arg = '';
  Map? arguments = null;

  final ButtonStyle button_style =
  ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            style: button_style,
            onPressed: (){
              if (arguments != null){
                Navigator.of(context).pushNamed(url, arguments: arguments);
              } else {
                Navigator.of(context).pushNamed(url, arguments: arg);
              }
              },
            child: Text(label)
        ),
      ),
    );
  }
}
