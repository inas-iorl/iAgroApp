import 'package:co2_app_server/models/map_element.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SelectorMapWidget extends StatefulWidget {
  SelectorMapWidget({super.key,
    required this.position,
    required this.elements,
    this.showPlace = false,
    this.showBoundaryPoints = false,
    this.onTap,
    this.onLongPress
  });
  LatLng position;
  List<MapElementModel> elements;
  bool showPlace;
  bool showBoundaryPoints;
  final Function? onTap;
  final Function? onLongPress;

  LatLng? markerMoveStart;

  @override
  State<SelectorMapWidget> createState() => _SelectorMapWidgetState();
}

class _SelectorMapWidgetState extends State<SelectorMapWidget> {

  @override
  Widget build(BuildContext context) {
    List<Marker> mapMarkers = [];
    List<Polygon> mapBorders = [];

    widget.elements.forEach((element){
      if (element.point_type == 2) {
        mapBorders.add(
            Polygon(
              points: element.borders,
              color: Colors.blue.withOpacity(0.5),
              borderStrokeWidth: 2,
              borderColor: Colors.blue,
            )
        );
      }
      if (element.point_type == 3) {
        mapMarkers.add(
            Marker(
              point: element.point!,
              height: 80,
              child: GestureDetector(
                child: Icon(Icons.place, color: Colors.green,),
                onTap: (){widget.onTap!(element.id);}
              ),
            )
        );

        mapMarkers.add(
            Marker(
              point: element.point!,
              height: 80,
              child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: Center(child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: Text('${element.name}'),
                  ))
              ),
            )
        );
      }
    });

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: FlutterMap(
        options: MapOptions(
          initialZoom: 15.0,
          initialCenter: LatLng(43.59301, 76.631282),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: mapMarkers,),
          PolygonLayer(polygonCulling: false, polygons: mapBorders,),
        ],
      ),
    );
  }
}
