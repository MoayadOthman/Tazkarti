import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/appconstant.dart';

class MapScreen extends StatefulWidget {
  final Function(LatLng) onLocationSelected; // تمرير الموقع المحدد إلى الصفحة الأصلية

  MapScreen({required this.onLocationSelected, Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  LatLng? selectedLocation;
  double zoomLevel = 13.0; // مستوى الزوم الافتراضي

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // دالة لتحديد الموقع
  void _selectLocation(LatLng location) {
    setState(() {
      selectedLocation = location; // تحديث الموقع المحدد
    });
    widget.onLocationSelected(location); // إرسال الموقع المحدد
  }

  // دالة لتكبير الخريطة
  void _zoomIn() {
    if (zoomLevel < 18) {
      setState(() {
        zoomLevel += 1;
      });
      _mapController.move(_mapController.camera.center, zoomLevel); // تحديث مستوى الزوم
    }
  }

  // دالة لتصغير الخريطة
  void _zoomOut() {
    if (zoomLevel > 5) {
      setState(() {
        zoomLevel -= 1;
      });
      _mapController.move(_mapController.camera.center, zoomLevel); // تحديث مستوى الزوم
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: const Text("حدد الموقع",style: TextStyle(color: AppConstant.appTextColor,fontWeight: FontWeight.bold),),
        centerTitle: true,

      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(36.276987, 37.296249), // الموقع الافتراضي
              initialZoom: zoomLevel, // تعيين مستوى الزوم
              onTap: (_, latlng) {
                _selectLocation(latlng); // تحديد الموقع عند الضغط على الخريطة
              },
            ),
            mapController: _mapController,
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: selectedLocation != null
                    ? [
                  Marker(
                    width: 40,
                    height: 40,
                    point: selectedLocation!,
                    child: const Icon(Icons.location_on, color: AppConstant.appMainColor),
                  ),
                ]
                    : [],
              ),
            ],
          ),
          // أزرار التكبير والتصغير
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: _zoomIn,
                  backgroundColor: AppConstant.appMainColor, // اللون المخصص
                  child: const Icon(Icons.add, color: Colors.white),
                  mini: true,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: _zoomOut,
                  backgroundColor: AppConstant.appMainColor, // اللون المخصص
                  child: const Icon(Icons.remove, color: Colors.white),
                  mini: true,
                ),
              ],
            ),
          ),
          // زر العودة إلى الصفحة السابقة
        ],
      ),
    );
  }
}
