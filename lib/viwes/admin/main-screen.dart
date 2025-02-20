import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wadiny/viwes/admin/addcatrgoryscreen.dart';
import 'package:wadiny/viwes/admin/addeventscreen.dart';
import '../../utils/appconstant.dart';
import '../auth/signinscreen.dart';
import '../category/allcategoriesscreen.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // final NotificationController notificationController = Get.put(NotificationController());
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(

        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "لوحة التحكم",
          style: TextStyle(color: AppConstant.appTextColor, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.notifications,size: 26,color: AppConstant.appTextColor,)
        ],
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2, // عدد الأعمدة في الشبكة
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: [
            _buildGridItem("المستخدمين", Icons.person, () {
              // Get.to(() => const AllUsersScreen());
            }),
            _buildGridItem("الحجوزات", Icons.credit_card_rounded, () {
              // Get.to(() => const AllOrdersScreen());
            }),
            _buildGridItem("الأحداث", Icons.event, () {
              // Get.to(() => const AllProductsScreen());
            }),

            _buildGridItem("إضافة التصنيفات", Icons.category, () {
              Get.to(() => const AddCategoriesScreen());
            }),
            _buildGridItem("إضافة حدث", Icons.event_available, () {
              Get.to(() =>  AddEventScreen());
            }),

            if (user != null)
              _buildGridItem("تقييمات", Icons.reviews_rounded, () {
                // هنا يمكنك إضافة تنقل إلى شاشة مراجعات العملاء
              }),
            _buildGridItem("جديدنا", Icons.fiber_new, () {
              // Get.to(() => const NewArrivalScreen());
            }),

            _buildGridItem("تسجيل خروج",
                Icons.login, () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(() => const SignInScreen());
                }
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildGridItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        child: GridTile(
          footer: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 50,
              color: AppConstant.appMainColor,
            ),
          ),
        ),
      ),
    );
  }
}
