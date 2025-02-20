import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/event.dart';

class EventMapController extends GetxController {
  Rx<LatLng?> userLocation = Rx<LatLng?>(null); // موقع المستخدم
  RxList<LatLng> routePoints = <LatLng>[].obs; // نقاط المسار
  RxDouble zoomLevel = 13.0.obs; // مستوى التكبير الافتراضي
  var mapController = MapController(); // للتحكم في الخريطة
  late EventModel event; // الحدث الذي سيتم استخدامه في المسار

  // استلام بيانات الحدث عند إنشاء الـ Controller
  void setEvent(EventModel eventModel) {
    event = eventModel;
  }

  // 📍 الحصول على موقع المستخدم الحالي
  Future<void> getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      Get.snackbar("خطأ", "يجب السماح بالوصول إلى الموقع لعرض المسار");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userLocation.value = LatLng(position.latitude, position.longitude);
    mapController.move(userLocation.value!, zoomLevel.value);
    fetchRoute(); // 🔄 جلب المسار بعد تحديد الموقع
  }

  // 🛣️ جلب المسار من OpenRouteService API
  Future<void> fetchRoute() async {
    if (userLocation.value == null) return;

    final String apiKey = "5b3ce3597851110001cf6248b2a0a4f35aa3432eab7501a7cc1fd31d"; // 🔑 مفتاح API
    final String url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${userLocation.value!.longitude},${userLocation.value!.latitude}&end=${event.longitude},${event.latitude}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['features'] == null || data['features'].isEmpty) {
          Get.snackbar("خطأ", "لم يتم العثور على مسار صالح.");
          return;
        }

        final List<dynamic>? coordinates = data['features'][0]['geometry']['coordinates'];
        if (coordinates == null || coordinates.isEmpty) {
          Get.snackbar("خطأ", "لا توجد إحداثيات صالحة للمسار.");
          return;
        }

        List<LatLng> points = coordinates
            .map((coord) => LatLng(coord[1], coord[0])) // عكس ترتيب الإحداثيات
            .toList();
        routePoints.assignAll(points);
      } else {
        Get.snackbar("خطأ", "تعذر جلب المسار. حاول مرة أخرى.");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالخدمة.");
    }
  }

  void zoomIn() {
    if (zoomLevel.value < 18) {
      zoomLevel.value += 1;
      mapController.move(mapController.camera.center, zoomLevel.value);
    }
  }

  void zoomOut() {
    if (zoomLevel.value > 5) {
      zoomLevel.value -= 1;
      mapController.move(mapController.camera.center, zoomLevel.value);
    }
  }
}
