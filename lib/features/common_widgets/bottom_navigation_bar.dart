
import 'package:crud_app/features/favorite/view/favorite_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../add_update/add_product_screen.dart';

import '../home/view/home_screen.dart';
import 'drawer.dart';

class BottomNavigationBarScreens extends StatefulWidget {
  const BottomNavigationBarScreens({super.key});

  @override
  State<BottomNavigationBarScreens> createState() => _BottomNavigationBarScreensState();
}

class _BottomNavigationBarScreensState extends State<BottomNavigationBarScreens> {

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  List<Widget> _pages = [
    MyHomePage(),
    FavoriteScreen(),
    AddUpdateProductScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        centerTitle: true,
        title: Text(
          "appName".tr(),
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Builder(
        builder: (context) {
          // this will trigger rebuild when locale changes
          final _ = context.locale;

          return BottomNavigationBar(
            selectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            backgroundColor: Colors.teal.shade300,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "home".tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "favorite".tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_photo_alternate_outlined),
                label: "add_update".tr(),
              ),
            ],
          );
        },
      ),

      drawer: DrawerWidget(),
    );
  }
}
