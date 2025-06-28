import 'dart:async';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/features/screens/root/view/bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutBack,
    );

    _animationController.forward();

    timer = Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigationBarScreens()),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).appBarTheme.systemOverlayStyle?.systemNavigationBarColor,
      ),
    );

  }

  @override
  void dispose() {
    _animationController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // Content color depends on brightness
    final contentColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: contentColor.withAlpha((0.1 * 255).round()),
                  boxShadow: [
                    BoxShadow(
                      color: contentColor.withAlpha((0.2 * 255).round()),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_cart_rounded,
                  size: 100.sp,
                  color: contentColor,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              LocaleKeys.appName.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 34.sp,
                fontWeight: FontWeight.w900,
                color: contentColor,
                letterSpacing: 1.5,
                shadows: const [
                  Shadow(
                    offset: Offset(1, 2),
                    blurRadius: 4.0,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              LocaleKeys.your_product_manager.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 18.sp,
                color: contentColor.withAlpha((0.7 * 255).round()),
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 40.h),
            CircularProgressIndicator(color: contentColor, strokeWidth: 4),
          ],
        ),
      ),
    );
  }
}
