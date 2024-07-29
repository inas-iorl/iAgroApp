import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
const MapScreen({super.key});

@override
State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialZoom: 10.0,
              onTap:  (tapPosition, point) => {
                print(point.toString()),
              },
          ),
          children: [
            TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [
                    LatLng(38.73, -9.14), // Lisbon, Portugal
                    LatLng(51.50, -0.12), // London, United Kingdom
                    LatLng(52.37, 4.90), // Amsterdam, Netherlands
                  ],
                  color: Colors.blue,
                  strokeWidth: 2,
                ),
              ],
            ),
            PolygonLayer(
              polygonCulling: false,
              polygons: [
                Polygon(
                    points: [
                      LatLng(36.95, -9.5),
                      LatLng(42.25, -9.5),
                      LatLng(42.25, -6.2),
                      LatLng(36.95, -6.2),
                      LatLng(35.95, -5.2),
                    ],
                    color: Colors.blue.withOpacity(0.5),
                    borderStrokeWidth: 2,
                    borderColor: Colors.blue,
                    isFilled: true
                ),
              ],
            ),
          ],
          ),
        ],
      ),
    );
  }
}
