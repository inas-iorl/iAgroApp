import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';


class MapWidget extends StatelessWidget {
  MapWidget({super.key, required this.position, this.showPlace = false, this.onTap});

  LatLng position;
  bool showPlace;
  final Function? onTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          initialZoom: 15.0,
          initialCenter: LatLng(43.59301, 76.631282),
          onTap:  (tapPosition, point) {
            if (this.onTap != null){
              this.onTap!(point);
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          showPlace ? MarkerLayer(
            markers: [
              Marker(
                point: position,
                height: 80, child: Icon(Icons.place),
              ),
            ],
          ) : Container(),
          PolygonLayer(
            polygonCulling: false,
            polygons: [
              Polygon(
                  points: [
                    LatLng(43.593498, 76.628047),
                    LatLng(43.595432, 76.632052),
                    LatLng(43.59218, 76.635876),
                    LatLng(43.590158, 76.631142),
                  ],
                  color: Colors.blue.withOpacity(0.5),
                  borderStrokeWidth: 2,
                  borderColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
