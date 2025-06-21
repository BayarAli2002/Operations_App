import 'package:another_flushbar/flushbar.dart';
import 'package:crud_app/source/features/screens/home/view/widgets/product_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../favorite/provider/favorite_provider.dart';
import '../provider/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<FavoriteProvider>(context, listen: false).fetchFavorites();
    });
  }

  void showFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.black87,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        if (provider.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: EdgeInsets.all(12.w),
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final productModel = provider.products[index];
            return ProductDetails(
              productModel: productModel,
              showFlushbar: (message) => showFlushbar(context, message),
            );
          },
        );
      },
    );
  }
}
