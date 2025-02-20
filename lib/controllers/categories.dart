import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCategoryController extends GetxController {
  final TextEditingController categoryNameController = TextEditingController();
  final Rx<File?> imageFile = Rx<File?>(null);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final RxBool isLoading = false.obs;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> uploadCategory() async {
    if (categoryNameController.text.isEmpty || imageFile.value == null) {
      Get.snackbar("خطأ", "يرجى إدخال جميع المعلومات");
      return;
    }

    try {
      isLoading.value = true;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('categories/$fileName.jpg');
      UploadTask uploadTask = ref.putFile(imageFile.value!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await firestore.collection('categories').add({
        'categoryId': fileName,
        'categoryName': categoryNameController.text,
        'categoryImages': downloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("نجاح", "تمت إضافة الفئة بنجاح");
      categoryNameController.clear();
      imageFile.value = null;
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء رفع الفئة");
    } finally {
      isLoading.value = false;
    }
  }
}
