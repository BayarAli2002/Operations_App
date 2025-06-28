import 'package:crud_app/source/core/manager/routes_manager.dart';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/features/screens/root/view/no_internet_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'widgets/drawer_widget.dart';
import '../../favorite/view/favorite_screen.dart';
import '../../home/view/home_screen.dart';
import '../../root/provider/root_provider.dart';

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
    return const [HomeScreen(), FavoriteScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final theme = Theme.of(context);

    return [
      PersistentBottomNavBarItem(
        inactiveIcon: Icon(
          Icons.home_outlined,
          color:
              theme.iconTheme.color, // use iconTheme color from ThemesManager
        ),
        icon: Icon(Icons.home, color: theme.iconTheme.color),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: Icon(Icons.favorite_border, color: theme.iconTheme.color),
        icon: Icon(Icons.favorite, color: theme.iconTheme.color),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _ = context.locale; // for localization

    return ConditionalBuilder(
      condition: Provider.of<RootProvider>(context).isOnline,
      builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor, // use appBar background color from ThemesManager
          foregroundColor: theme.appBarTheme.titleTextStyle?.color,
          
          centerTitle: true,
          title: Text(
            LocaleKeys.appName.tr(),
            style: theme.appBarTheme.titleTextStyle?.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: theme.iconTheme.color),
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
          navBarStyle: NavBarStyle.style6,
          backgroundColor: theme.appBarTheme.backgroundColor!,
        ),
      ),
      fallback: (context) =>
          const NoInternetScreen(), // ← full screen, no Scaffold
    );
  }
}
