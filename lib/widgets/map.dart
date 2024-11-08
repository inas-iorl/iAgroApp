import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  MapWidget({super.key,
    required this.position,
    this.showPlace = false,
    this.showBoundaryPoints = false,
    this.onTap,
    this.onLongPress
  });
  LatLng position;
  List<LatLng> markers = [];
  List<LatLng> bounds = [];
  bool showPlace;
  bool showBoundaryPoints;
  final Function? onTap;
  final Function? onLongPress;

  LatLng? markerMoveStart;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {

  // moveBound(LatLng oldPoint, LatLng newPoint){
  //   var point_idx = widget.bounds.indexWhere((point) => point.longitude == oldPoint.longitude && point.latitude == oldPoint.latitude);
  //   setState(() {
  //     widget.bounds[point_idx] = newPoint;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List<DragMarker> boundMarkers = [];

    // widget.bounds.forEach((mark){
    //   boundMarkers.add(
    //       DragMarker(
    //         point: mark,
    //         offset: const Offset(0.0, 0.0),
    //         builder: (_, __, ___) => Icon(Icons.add, size: 30),
    //         onDragStart: (details, latLng) {
    //           widget.markerMoveStart = latLng;
    //         },
    //         onDragEnd: (details, latLng) {
    //           moveBound(widget.markerMoveStart!, latLng);
    //         },
    //         size: const Size.square(50),
    //       )
    //   );
    // });

    return Container(
      width: double.infinity,
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          initialZoom: 15.0,
          initialCenter: LatLng(43.59301, 76.631282),
          onTap:  (tapPosition, point) {
            if (widget.onTap != null){
              widget.onTap!(point);
            }
          },
          onLongPress: (tapPosition, point) {
            print(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          widget.showPlace ? MarkerLayer(
            markers: [
              Marker(
                point: widget.position,
                height: 80, child: Icon(Icons.place),
              ),
            ],
          ) : Container(),
          widget.showBoundaryPoints ? DragMarkers(
            markers: boundMarkers,
          ) : Container(),
          PolygonLayer(
            polygonCulling: false,
            polygons: [
              Polygon(
                points: widget.bounds,
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



// class MapWidget extends StatelessWidget {
//   MapWidget({super.key, required this.position, this.showPlace = false, this.showBoundaryPoints = false, this.onTap});
//
//   LatLng position;
//   bool showPlace;
//   bool showBoundaryPoints;
//   final Function? onTap;
//
//   LatLng? markerMoveStart;
//   List<LatLng> bounds = [
//     LatLng(43.593498, 76.628047),
//     LatLng(43.595432, 76.632052),
//     LatLng(43.59218, 76.635876),
//     LatLng(43.590158, 76.631142)
//   ];
//
//
//   moveBound(LatLng oldPoint, LatLng newPoint){
//     print(oldPoint.latitude);
//     print(oldPoint.longitude);
//     var point_idx = bounds.indexWhere((point) => point.longitude == oldPoint.longitude && point.latitude == oldPoint.latitude);
//     bounds[point_idx] = newPoint;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     List<DragMarker> boundMarkers = [];
//
//     bounds.forEach((mark){
//       boundMarkers.add(
//           DragMarker(
//             point: mark,
//             offset: const Offset(0.0, 0.0),
//             builder: (_, __, ___) => Icon(Icons.add, size: 30),
//             onDragStart: (details, latLng) {
//               markerMoveStart = latLng;
//             },
//             onDragEnd: (details, latLng) {
//               // print('from ${markerMoveStart}');
//               // print('to ${latLng}');
//               moveBound(markerMoveStart!, latLng);
//             },
//             size: const Size.square(50),
//           )
//       );
//     });
//
//     return Container(
//       width: double.infinity,
//       height: 300,
//       child: FlutterMap(
//         options: MapOptions(
//           initialZoom: 15.0,
//           initialCenter: LatLng(43.59301, 76.631282),
//           onTap:  (tapPosition, point) {
//             if (this.onTap != null){
//               this.onTap!(point);
//             }
//           },
//           onLongPress: (tapPosition, point) {
//             print(point);
//           },
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.example.app',
//           ),
//           showPlace ? MarkerLayer(
//             markers: [
//               Marker(
//                 point: position,
//                 height: 80, child: Icon(Icons.place),
//               ),
//             ],
//           ) : Container(),
//           showBoundaryPoints ? DragMarkers(
//             markers: boundMarkers,
//           ) : Container(),
//           PolygonLayer(
//             polygonCulling: false,
//             polygons: [
//               Polygon(
//                   points: bounds,
//                   color: Colors.blue.withOpacity(0.5),
//                   borderStrokeWidth: 2,
//                   borderColor: Colors.blue,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
