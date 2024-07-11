import 'package:co2_app_server/models/diagnostic.dart';
import 'package:flutter/material.dart';

class DiagnosticListWidget extends StatefulWidget {
  DiagnosticListWidget({required this.diagnostics});

  List<DiagnosticModel> diagnostics;

  @override
  State<DiagnosticListWidget> createState() => _DiagnosticListWidgetState();
}

class _DiagnosticListWidgetState extends State<DiagnosticListWidget> {
  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: widget.diagnostics.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return DiagnosticListItemWidget(diagnostic: widget.diagnostics[index]);
        // return ListTile(
        //   title: Text(widget.devices[index].name),
        //   subtitle: Text(widget.devices[index].id),
        // );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}


class DiagnosticListItemWidget extends StatefulWidget {
  DiagnosticListItemWidget({super.key, required this.diagnostic});

  DiagnosticModel diagnostic;

  @override
  State<DiagnosticListItemWidget> createState() => _DiagnosticListItemWidgetState();
}

class _DiagnosticListItemWidgetState extends State<DiagnosticListItemWidget> {
  @override
  Widget build(BuildContext context) {

    Widget current_widget;
    if (widget.diagnostic.result_image != '' && widget.diagnostic.result == ''){
      current_widget = Text("В обработке");
    } else if (widget.diagnostic.result_image != '' && widget.diagnostic.result != '') {
      current_widget = Text(widget.diagnostic.result);
    } else {
      // current_widget = Text("Замер через ${widget.diagnostic.measureInStr()}(${widget.diagnostic.measure_time})");
      current_widget = Text("Замер через ${widget.diagnostic.measureInStr()}");
    }

    return GestureDetector(
      onTap: (){Navigator.of(context).pushNamed('/devices/diagnostic', arguments: {"field_id": widget.diagnostic.field_id, "diagnostic_id": widget.diagnostic.id});},
      child: Padding(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("id - ${widget.diagnostic.id}"),
                          Text("field_id - ${widget.diagnostic.field_id}"),
                          current_widget,
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: (){Navigator.of(context).pushNamed('/devices/diagnostic', arguments: {"field_id": widget.diagnostic.field_id, "diagnostic_id": widget.diagnostic.id});},
                              // onPressed: null,
                              icon: Icon(Icons.arrow_forward_ios_outlined))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
