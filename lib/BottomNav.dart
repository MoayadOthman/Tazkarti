import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wadiny/viwes/event/eventscreen.dart';
import '../../utils/appconstant.dart';
import 'viwes/book/bookedscreen.dart';
import 'viwes/category/allcategoriesscreen.dart';
import 'viwes/favoritescreen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});
  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _bottomNavIndex = 0;

  final List<Widget> pages = [
    EventsScreen(),
    const AllCategoriesScreen(),
    const FavoriteScreen(),
    BookedEventsScreen(),
  ];

  final List<IconData> iconList = [
    Icons.home,
    Icons.category_outlined,
    Icons.favorite,
    Icons.event_available,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_bottomNavIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: AppConstant.appMainColor,
        height: 60,
        index: _bottomNavIndex,
        animationDuration: const Duration(milliseconds: 300),
        items: iconList.map((icon) {
          return Icon(icon, size: 30, color: Colors.white);
        }).toList(),
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
