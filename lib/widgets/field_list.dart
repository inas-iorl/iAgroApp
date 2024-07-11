import 'package:flutter/material.dart';

import '../models/field.dart';
import 'field_combi.dart';

class FieldListWidget extends StatefulWidget {
  FieldListWidget({required this.fields});

  List<FieldModel> fields;

  @override
  State<FieldListWidget> createState() => _FieldListWidgetState();
}

class _FieldListWidgetState extends State<FieldListWidget> {
  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: widget.fields.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/field', arguments: widget.fields[index].id),
          child:
            CombiCard(
              co2Value: widget.fields[index].co2_value,
              indicateValue: widget.fields[index].indicateValue,
              text_value: widget.fields[index].text_value,
              title: widget.fields[index].name,
              subtitle: widget.fields[index].culture,
              image: widget.fields[index].image,
            ),
        )
          ;
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}