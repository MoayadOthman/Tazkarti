import 'package:cached_network_image/cached_network_image.dart'; // مكتبة لعرض الصور المخزنة مؤقتًا
import 'package:cloud_firestore/cloud_firestore.dart'; // مكتبة Firestore للوصول إلى قاعدة البيانات
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // مكتبة GetX للتحكم في التنقل والحالة
import '../../../models/categories.dart'; // استيراد موديل الفئات
import 'singlecategoryscreen.dart'; // شاشة العرض الفردي للفئة
import '../../../utils/appconstant.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "جميع التصنيفات",
          style: TextStyle(
            fontSize: 22,
            color: AppConstant.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // ✅ إضافة مسافة بين AppBar والمحتوى
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('categories').get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("لا يوجد تصنيفات!"));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                      CategoryModel categoryModel = CategoryModel(
                        categoryId: docData["categoryId"],
                        categoryImages: docData["categoryImages"],
                        categoryName: docData["categoryName"],
                        createdAt: docData["createdAt"],
                        updatedAt: docData["updatedAt"],
                      );

                      return GestureDetector(
                        onTap: () => Get.to(() => SingleCategoryScreen(
                          categoryId: categoryModel.categoryId,
                          categoryName: categoryModel.categoryName,
                        )),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: categoryModel.categoryImages,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                placeholder: (context, url) =>
                                const Center(child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                            Positioned(
                              child: Text(
                                categoryModel.categoryName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
