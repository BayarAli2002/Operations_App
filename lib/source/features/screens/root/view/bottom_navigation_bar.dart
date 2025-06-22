import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../../../app/routs.dart';
import 'widgets/drawer_widget.dart';
import '../../favorite/view/favorite_screen.dart';
import '../../home/view/home_screen.dart';

class BottomNavigationBarScreens extends StatefulWidget {
  const BottomNavigationBarScreens({super.key});

  @override
  State<BottomNavigationBarScreens> createState() =>
      _BottomNavigationBarScreensState();
}

class _BottomNavigationBarScreensState
    extends State<BottomNavigationBarScreens> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [const HomeScreen(), const FavoriteScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        inactiveIcon: Icon(Icons.home_outlined),
        icon: const Icon(Icons.home),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black54,
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.favorite_border),
        icon: const Icon(Icons.favorite),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black54,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.teal,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.teal,
          statusBarIconBrightness: Brightness.light,
        ),
        centerTitle: true,
        title: Text(
          LocaleKeys.appName.tr(),
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, Routes.addUpdateProduct);
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style6, // choose the animation style you like

        backgroundColor: Colors.teal,
      ),
    );
  }
}
