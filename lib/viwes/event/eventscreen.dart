import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadiny/consts/consts.dart';
import 'package:wadiny/utils/appconstant.dart';
import '../../controllers/event.dart';
import '../../models/event.dart';
import '../admin/addeventscreen.dart';
import 'eventdetailsscreen.dart';

class EventsScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(Icons.notifications, size: 25, color: AppConstant.appTextColor,)
        ],
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          'الأحداث المحلية',
          style: TextStyle(
            fontSize: 22,
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: eventController.searchController,
              onChanged: (value) {
                eventController.selectedName.value = value;
                eventController.applyFilters();
              },
              decoration: InputDecoration(
                hintText: 'بحث عن حدث...',
                prefixIcon: Image.asset(search, height: 40, width: 40,),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FutureBuilder<List<String>>(
              future: eventController.fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('خطأ في جلب الفئات');
                }

                List<String> categories = snapshot.data ?? [];
                if (!categories.contains('الكل')) {
                  categories.insert(0, 'الكل');  // تأكد من أن "الكل" موجود أولاً في القائمة
                }

                return Obx(() {
                  return DropdownButtonFormField<String>(
                    value: eventController.selectedCategory.value.isEmpty
                        ? 'الكل'  // إذا كانت القيمة فارغة اختر "الكل"
                        : eventController.selectedCategory.value,
                    hint: const Text('اختر الفئة'),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      eventController.selectedCategory.value = value!;
                      eventController.applyFilters();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  );
                });
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: eventController.filteredEvents.length,
                itemBuilder: (context, index) {
                  EventModel event = eventController.filteredEvents[index];
                  RxBool isFavorite = false.obs;
                  eventController.checkIfFavorite(event.eventId)
                      .then((isFav) => isFavorite.value = isFav);

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () => Get.to(EventDetailsScreen(event: event)),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.network(
                                event.eventImages.isNotEmpty
                                    ? event.eventImages.first
                                    : 'https://via.placeholder.com/150',
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.eventName,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    event.productDescription,
                                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Obx(() => Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isFavorite.value
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavorite.value ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () => eventController.toggleFavorite(event, isFavorite),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
