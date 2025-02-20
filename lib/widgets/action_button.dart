import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/eventdetails.dart';
import '../models/event.dart';
import '../utils/appconstant.dart';
import '../viwes/map_page.dart';

class EventActionButtons extends StatelessWidget {
  final EventDetailsController controller;
  final EventModel event;

  const EventActionButtons({super.key, required this.controller, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(MapPage(event: event));
            },
            icon: const Icon(Icons.map),
            label: const Text("عرض على الخريطة"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.appMainColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: controller.bookTicket,
            child: const Text("حجز التذكرة"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
