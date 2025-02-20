import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/appconstant.dart';

import 'editprofilescreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Scaffold(
      body:
      StreamBuilder<DocumentSnapshot>(
        stream: currentUser != null
            ? _firestore.collection("users").doc(currentUser.uid).snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // مؤشر تحميل
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('خطأ في تحميل البيانات أو لا توجد بيانات'),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          final userImg = userData?['userImg'] ?? "";
          final username = userData?['username'] ?? "Username";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height / 12,
              ),
              CircleAvatar(
                radius: 75.0,
                backgroundImage: CachedNetworkImageProvider(userImg),
              ),
              Text(
                username,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => ProfileEditScreen(userData: userData));
                },
                child: const ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("تعديل الملف الشخصي"),
                  leading: Icon(Icons.settings),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Get.to(() => AllOrdersScreen());
                },
                child: const ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("الطلبات"),
                  leading: Icon(Icons.category_outlined),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              const ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("حول التطبيق"),
                leading: Icon(Icons.android),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              const ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text("لتواصل"),
                leading: Icon(Icons.help),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              GestureDetector(
                onTap: () {
                  _showShareOptions(context);
                },
                child: const ListTile(
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Text("مشاركة"),
                  leading: Icon(Icons.share),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              ListTile(
                onTap: () async {
                  // GoogleSignIn googleSignIn = GoogleSignIn();
                  // await _auth.signOut();
                  // await googleSignIn.signOut();
                  // Get.offAll(() =>  WelcomeScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: const Text("تسجيل خروج"),
                leading: const Icon(Icons.logout),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          );
        },
      ),

    );
  }
}


void _showShareOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bluetooth),
              title: const Text("مشاركة عبر البلوتوث"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("مشاركة عبر ShareIt"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("إلغاء"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}


