import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/cart.dart';
import '../../../utils/appconstant.dart';
import '../../models/event.dart';
import '../event/eventdetailsscreen.dart';

class SingleCategoryScreen extends StatefulWidget {
  String? categoryId;
  String? categoryName;
  SingleCategoryScreen({super.key, required this.categoryId,required this.categoryName});

  @override
  State<SingleCategoryScreen> createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  User? user = FirebaseAuth.instance.currentUser;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName??'', // عرض اسم التصنيف إذا كان متوفراً
          style: const TextStyle(
            color: AppConstant.appMainColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('events').where("categoryId",isEqualTo:widget.categoryId).get(), // تعديل الاستعلام
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 7,
              child: const Center(child: CupertinoActivityIndicator()),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لم يتم العثور على منتجات!"));
          }

          if (snapshot.hasData) {
            return Container(
              height: Get.height / 2.1,
              width: Get.width ,
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.1, // ضبط نسبة العرض إلى الارتفاع
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  //لان المنتج الذي نريد عرضه
                  EventModel productModel = EventModel(
                    categoryId: docData['categoryId'],
                    categoryName: docData['categoryName'],
                    createdAt: docData['createdAt'],
                    updatedAt: docData['updatedAt'],
                    fullPrice: docData['fullPrice'],
                    salePrice: docData['salePrice'],
                    productDescription: docData['productDescription']??'',
                    eventId: docData['eventId'],
                    eventImages: List<String>.from(docData['eventImages']),
                    eventName: docData['eventName'],
                    isSale: docData['isSale'],
                    latitude:  docData['latitude'],
                    longitude:  docData['longitude'],
                    eventDate: docData['eventDate'],
                    eventDay:  docData['eventDay'],
                    eventTime: docData['eventTime'],
                    notes: docData['notes'],

                  );

                  RxBool isFavorite = false.obs;
                  checkIfFavorite(productModel.eventId).then((isFav) => isFavorite.value = isFav);


                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(() => EventDetailsScreen(event: productModel,)),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    child: CachedNetworkImage(
                                      imageUrl: productModel.eventImages[0],
                                      fit: BoxFit.fill,
                                      height: Get.height / 4,
                                      width: Get.width,
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),

                                  Positioned(
                                    child: Obx(() => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.3),
                                      ),
                                      child: IconButton(
                                        icon: Icon(isFavorite.value ? Icons.favorite : Icons.favorite_border),
                                        onPressed: () => toggleFavorite(productModel, isFavorite),
                                        color: isFavorite.value ? Colors.red : Colors.grey,
                                      ),
                                    )),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible( // أو يمكنك استخدام Flexible بدلاً منه
                              child: Text(
                                productModel.eventName,
                                textAlign:TextAlign.end,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.visible, // يمكنك ضبط هذا إذا أردت التقطيع أو الإظهار الكامل
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "سعر التذكرة",
                              style: const TextStyle(fontSize: 18, color:Colors.black54,),
                            ),

                            Text(
                              "${productModel.fullPrice} ل.س",
                              style: const TextStyle(fontSize: 20, color:AppConstant.appMainColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
