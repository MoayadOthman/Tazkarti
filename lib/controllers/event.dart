import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';

class EventController extends GetxController {
  // قائمة تحتوي على جميع الأحداث التي يتم جلبها من Firestore
  var events = <EventModel>[].obs;

  // قائمة تحتوي على الأحداث بعد تطبيق التصفية أو البحث
  var filteredEvents = <EventModel>[].obs;
  final RxString selectedCategory = 'الكل'.obs;
  final RxString selectedName = ''.obs;

  final TextEditingController searchController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  // دالة لجلب الفئات من Firestore

  void applyFilters() {
    filterEvents(searchController.text, selectedCategory.value);
  }

  Future<List<String>> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();
      List<String> categories = ['الكل'];  // إضافة "الكل" كخيار أول

      snapshot.docs.forEach((doc) {
        categories.add(doc['categoryName']);
      });
      return categories;
    } catch (e) {
      return ['الكل'];  // في حال حدوث خطأ، نعرض "الكل" فقط
    }
  }


  // دالة لإضافة أو إزالة الحدث من المفضلة
  Future<void> toggleFavorite(EventModel event, RxBool isFavorite) async {
    if (user != null) {
      try {
        final favoriteRef = FirebaseFirestore.instance
            .collection('favorites')
            .doc(user!.uid)
            .collection('favoriteEvents')
            .doc(event.eventId);

        if (isFavorite.value) {
          await favoriteRef.delete();
          isFavorite.value = false;
          Get.snackbar('تمت الإزالة', 'تمت إزالة الحدث من المفضلة!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        } else {
          await favoriteRef.set({
            'eventId': event.eventId,
            'eventName': event.eventName,
            'eventImages': event.eventImages,
            'salePrice': event.salePrice,
            'fullPrice': event.fullPrice,
            'categoryId': event.categoryId,
            'eventDate': event.eventDate,
            'eventTime': event.eventTime,
            'categoryName': event.categoryName,
            'latitude': event.latitude,
            'longitude': event.longitude,
            'createdAt': event.createdAt,
            'updatedAt': event.updatedAt,
            'productDescription': event.productDescription,
            'isSale': event.isSale,
          });
          isFavorite.value = true;
          Get.snackbar('تمت الإضافة', 'تمت إضافة الحدث إلى المفضلة!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        }
      } catch (e) {
        Get.snackbar('خطأ', 'فشل تحديث المفضلة!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }

  // دالة للتحقق إذا كان الحدث موجود في المفضلة
  Future<bool> checkIfFavorite(String eventId) async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(user!.uid)
          .collection('favoriteEvents')
          .doc(eventId)
          .get();
      return doc.exists;
    }
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchEvents(); // جلب الأحداث عند تحميل المتحكم
  }

  // وظيفة لجلب الأحداث من Firestore
  void fetchEvents() async {
    FirebaseFirestore.instance.collection('events').snapshots().listen((snapshot) {
      // تحويل البيانات إلى كائنات EventModel وتحديث القائمة
      events.value = snapshot.docs.map((doc) => EventModel.fromMap(doc.data())).toList();

      // تعيين جميع الأحداث كقائمة افتراضية للعرض
      filteredEvents.value = events;
    });
  }

  // وظيفة البحث والتصفية حسب الاسم والفئة
  void filterEvents(String query, String category) {
    filteredEvents.value = events.where((event) {
      // التحقق مما إذا كان اسم الحدث يحتوي على النص المدخل في البحث
      final matchesQuery = query.isEmpty || event.eventName.toLowerCase().contains(query.toLowerCase());

      // تجاهل التصفية حسب الفئة إذا كان هناك نص بحث
      final matchesCategory = query.isNotEmpty ? true : (category.isEmpty || category == 'الكل' || event.categoryName == category);

      return matchesQuery && matchesCategory;
    }).toList();
  }
}
