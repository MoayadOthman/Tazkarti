import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:wadiny/utils/appconstant.dart';
import '../controllers/map.dart';
import '../models/event.dart';

class MapPage extends StatelessWidget {
  final EventModel event;

  MapPage({required this.event});

  @override
  Widget build(BuildContext context) {
    // استخدم GetX لربط ال Controller وتمرير بيانات الحدث
    final EventMapController mapController = Get.put(EventMapController());
    mapController.setEvent(event); // تمرير الحدث إلى الـ Controller

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          event.eventName,
          style: TextStyle(color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: AppConstant.appTextColor),
            onPressed: mapController.getUserLocation, // 📌 استدعاء الوظيفة عند الضغط على الزر
          ),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            FlutterMap(
              mapController: mapController.mapController,
              options: MapOptions(
                initialCenter: mapController.userLocation.value ?? LatLng(event.latitude, event.longitude),
                initialZoom: mapController.zoomLevel.value,
              ),
              children: [
                TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
                if (mapController.userLocation.value != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: mapController.userLocation.value!,
                        child: Icon(Icons.my_location, color: Colors.blue, size: 30),
                      ),
                      Marker(
                        width: 40,
                        height: 40,
                        point: LatLng(event.latitude, event.longitude),
                        child: Icon(Icons.location_on, color: Colors.red, size: 30),
                      ),
                    ],
                  ),
                if (mapController.routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: mapController.routePoints,
                        color: Colors.blue,
                        strokeWidth: 5,
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "zoomIn",
                    onPressed: mapController.zoomIn,
                    backgroundColor: AppConstant.appMainColor,
                    child: Icon(Icons.add, color: Colors.white),
                    mini: true,
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: "zoomOut",
                    onPressed: mapController.zoomOut,
                    backgroundColor: AppConstant.appMainColor,
                    child: Icon(Icons.remove, color: Colors.white),
                    mini: true,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
