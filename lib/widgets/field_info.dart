import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../chart/line_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FieldInfoWidget extends StatelessWidget {
  FieldInfoWidget({
    required this.gauge_value,
    required this.co2_value, required this.text_value});

  final double gauge_value;
  final double co2_value;
  final String text_value;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amberAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FieldGauge(value: gauge_value),
          Text(gauge_value.toInt().toString(), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Column(children: [
            Text('Общее здоровье почвы'),
            Text(text_value),
            Text('CO2 ${co2_value} мгС/м2'),
          ],)
        ],
      ),
    );
  }
}


class FieldGauge extends StatelessWidget {
  FieldGauge({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        color: Colors.white,
        child: SizedBox(
            width: 80,
            height: 80,
            child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(minimum: 0, maximum: 100,
                    axisLabelStyle: GaugeTextStyle(fontSize: 0, color: Colors.white),
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 0, endValue: 15, color:Colors.red, label: null),
                      GaugeRange(startValue: 15,endValue: 30,color: Colors.redAccent, label: null),
                      GaugeRange(startValue: 30,endValue: 45,color: Colors.orange, label: null),
                      GaugeRange(startValue: 45,endValue: 60,color: Colors.yellow, label: null),
                      GaugeRange(startValue: 60,endValue: 75,color: Colors.lime, label: null),
                      GaugeRange(startValue: 75,endValue: 90,color: Colors.lightGreenAccent, label: null),
                      GaugeRange(startValue: 90,endValue: 100,color: Colors.green, label: null)],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: this.value)],
                  )])
        ),
      ),
    );
  }
}