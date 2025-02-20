// استيراد المكتبات الضرورية
import 'package:cloud_firestore/cloud_firestore.dart'; // لاستخدام قاعدة بيانات Firestore
import 'package:firebase_auth/firebase_auth.dart'; // لإدارة عمليات تسجيل الدخول والمستخدمين
import 'package:flutter/material.dart'; // مكونات واجهة المستخدم في Flutter
import 'package:get/get.dart'; // إدارة الحالة والتنقل باستخدام GetX
import 'package:geocoding/geocoding.dart'; // لتحويل الإحداثيات الجغرافية إلى عناوين نصية
import '../../models/event.dart'; // استيراد نموذج البيانات للحدث

// كلاس للتحكم في بيانات الحدث باستخدام GetX
class EventDetailsController extends GetxController {
  final EventModel event; // متغير يحتوي على بيانات الحدث الحالي
  EventDetailsController(this.event); // التهيئة باستخدام الحدث الممرر

  // متغير لحفظ اسم الموقع بناءً على الإحداثيات، ويتم تحديثه باستخدام Rx
  var locationName = "جاري جلب الموقع...".obs;

  // الحصول على المستخدم الحالي المسجل في Firebase
  User? user = FirebaseAuth.instance.currentUser;

  // يتم استدعاء هذه الدالة تلقائيًا عند إنشاء الكائن
  @override
  void onInit() {
    super.onInit();
    _getLocationName(); // استدعاء دالة جلب اسم الموقع
  }

  // دالة لجلب اسم الموقع بناءً على الإحداثيات الجغرافية
  Future<void> _getLocationName() async {
    try {
      // جلب تفاصيل الموقع من إحداثيات الحدث (خط الطول والعرض)
      List<Placemark> placemarks =
      await placemarkFromCoordinates(event.latitude, event.longitude);

      // إذا تم العثور على بيانات الموقع
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first; // الحصول على أول عنوان متاح
        locationName.value =
        "${place.street ?? "غير معروف"} ${place.subLocality ?? ""}, ${place.locality ?? "غير معروف"}, ${place.country ?? "غير معروف"}";
        // يتم تحديث متغير الموقع وعرضه للمستخدم
      }
    } catch (e) {
      // إذا حدث خطأ أثناء جلب الموقع
      locationName.value = "تعذر العثور على الموقع";
    }
  }

  // دالة لحجز التذكرة وحفظها في قاعدة بيانات Firestore
  Future<void> bookTicket() async {
    try {
      // إضافة بيانات الحدث إلى مجموعة "bookings" داخل Firestore تحت حساب المستخدم
      await FirebaseFirestore.instance
          .collection('bookings') // المجموعة الرئيسية
          .doc(user!.uid) // تحديد المستخدم الحالي
          .collection('userBookings') // مجموعة فرعية لكل مستخدم
          .doc(event.eventId) // حفظ التذكرة باستخدام معرف الحدث
          .set(event.toMap()); // تحويل الحدث إلى خريطة بيانات وحفظه

      // إظهار رسالة نجاح عند الحجز
      Get.snackbar(
        "نجاح",
        "تم حجز التذكرة بنجاح!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // في حال حدوث خطأ أثناء الحجز
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء الحجز: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
