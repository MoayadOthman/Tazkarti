// ignore_for_file: prefer_is_empty, unnecessary_cast, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wadiny/consts/colors.dart';

import '../../controllers/products-images-controller.dart';
import '../../models/categories.dart';
import '../../utils/appconstant.dart';
import '../../utils/generate_id.dart';

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({super.key});

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  // إنشاء متحكم لنص اسم التصنيف
  TextEditingController categoryNameController = TextEditingController();
  // متحكم للصور، يستخدم لإضافة وإدارة الصور المحددة
  AddImagesController addProductImagesController = Get.put(AddImagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          'إضافة صنف',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("اختار الصور"),
                    ElevatedButton(
                      onPressed: () {
                        // استدعاء الدالة لعرض منتقي الصور
                        addProductImagesController.showImagesPickerDialog();
                      },
                      child: const Text("حدد الصور",style: TextStyle(color: AppConstant.appMainColor),),
                    )
                  ],
                ),
              ),

              // عرض الصور المختارة
              GetBuilder<AddImagesController>(
                init: AddImagesController(),
                builder: (imageController) {
                  return imageController.selectedIamges.isNotEmpty
                      ? Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: Get.height / 3.0,
                    child: GridView.builder(
                      itemCount: imageController.selectedIamges.length,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Image.file(
                              File(addProductImagesController.selectedIamges[index].path),
                              fit: BoxFit.cover,
                              height: Get.height / 4,
                              width: Get.width / 2,
                            ),
                            Positioned(
                              right: 10,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  // إزالة الصورة عند الضغط على أيقونة الإغلاق
                                  imageController.removeImages(index);
                                  print(imageController.selectedIamges.length);
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppConstant.appMainColor,
                                  child: Icon(
                                    Icons.close,
                                    color: AppConstant.appTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                      : const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 40.0),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    hintText: "اسم الصنف",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  // التحقق من إدخال صورة على الأقل
                  if (addProductImagesController.selectedIamges.isEmpty) {
                    Get.snackbar("خطأ", "حدد صورة واحدة على الأقل");
                    return;
                  }

                  // التحقق من إدخال اسم التصنيف
                  if (categoryNameController.text.isEmpty) {
                    Get.snackbar("خطأ", "ادخل اسم الصنف");
                    return;
                  }

                  try {
                    // عرض مؤشر التحميل
                    EasyLoading.show();

                    // رفع الصور إلى السيرفر أو التخزين السحابي
                    await addProductImagesController.uploadFunction(addProductImagesController.selectedIamges);

                    // توليد معرف فريد للتصنيف
                    String categoryId = GenerateIds().generateCategoryId();
                    // الحصول على رابط الصورة الأولى بعد الرفع
                    String cateImg = addProductImagesController.arrImagesUrl[0] as String;

                    print(cateImg);

                    // إنشاء نموذج بيانات التصنيف
                    CategoryModel categoriesModel = CategoryModel(
                      categoryId: categoryId,
                      categoryName: categoryNameController.text.trim(),
                      categoryImages: cateImg,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    print(categoryId);

                    // إضافة بيانات التصنيف إلى قاعدة البيانات
                    FirebaseFirestore.instance
                        .collection('categories')
                        .doc(categoryId)
                        .set(categoriesModel.toJson());

                    // إخفاء مؤشر التحميل
                    EasyLoading.dismiss();
                  } catch (e) {
                    print("Error: $e");
                  }
                },
                child: const Text("إضافة",style: TextStyle(color: AppConstant.appMainColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
