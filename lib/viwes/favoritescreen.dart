import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wadiny/viwes/event/eventdetailsscreen.dart';

import '../../utils/appconstant.dart';
import '../models/event.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("الأحداث المفضلة",style: TextStyle(
            fontSize: 22,fontWeight: FontWeight.bold,color:AppConstant.appTextColor
        ),),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .doc(user!.uid)
            .collection('favoriteEvents')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("خطأ في تحميل المنتجات المفضلة"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("قائمتك المفضلة فارغة!"),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: (){
                    EventModel event = EventModel.fromMap(docData);
                    Get.to(() => EventDetailsScreen(event: event));
                  },
                  child: Card(
                    elevation: 5,
                    color:Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: docData['eventImages'][0] ?? '', // التأكد من وجود 'productImage' وليس 'productImages'
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    title: Text(
                      docData['eventName'] , // Assuming 'productName' field
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${docData['fullPrice']?.toString()} ل.س', // Assuming 'productPrice' field
                      style: const TextStyle(fontSize: 16, color:AppConstant.appMainColor),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: AppConstant.appMainColor),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('favorites')
                            .doc(user!.uid)
                            .collection('favoriteEvents')
                            .doc(docData['eventId']) // Assuming 'productId' field
                            .delete();
                      },
                    ),
                  ),
                  ),
                );
              },
            );
          }

          return Container(); // Return empty container if none of the conditions match
        },
      ),
    );
  }
}
