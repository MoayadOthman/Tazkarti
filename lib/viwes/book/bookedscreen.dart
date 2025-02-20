import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wadiny/utils/appconstant.dart';
import '../../consts/images.dart';
import '../../models/event.dart';
import '../map_page.dart';

class BookedEventsScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppConstant.appMainColor,
        title: const Text("التذاكر المحجوزة",style:TextStyle(
        fontSize: 22,
        color: AppConstant.appTextColor,
        fontWeight: FontWeight.bold,
      ),),),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .doc(user!.uid)
            .collection('userBookings')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("حدث خطأ في تحميل الحجوزات"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لم تقم بحجز أي تذكرة بعد!"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              EventModel event = EventModel.fromMap(data);

              return ListTile(
                title: Text(event.eventName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text("📍 ${event.eventDate} - ${event.eventTime}"),
                trailing: IconButton(
                  icon:Image.asset(map,height: 40,),
                  onPressed: () {
                    Get.to(MapPage(event: event));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
