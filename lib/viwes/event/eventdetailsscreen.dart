import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/eventdetails.dart';
import '../../models/event.dart';
import '../../utils/appconstant.dart';
import '../../widgets/action_button.dart';
import '../../widgets/build_image_carsoul.dart';
import '../../widgets/row_details.dart';
import '../map_page.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;
  EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventDetailsController(event));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.eventName,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppConstant.appMainColor),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventImageCarousel(eventImages:event.eventImages,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.eventName,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.appMainColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.productDescription,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                      DetailRowWidget(title: "📌 الفئة:", value: event.categoryName),
                      DetailRowWidget(title: "📅 التاريخ:", value: event.eventDate),
                      DetailRowWidget(title: "🕒 الوقت:", value: event.eventTime),
                      DetailRowWidget(title: "💰 سعر التذكرة:", value: "${event.fullPrice} ل.س"),
                      Obx(() => DetailRowWidget(title: "📍 الموقع:", value: controller.locationName.value)),
                      const SizedBox(height: 20),
                      EventActionButtons( controller: controller, event: event),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
