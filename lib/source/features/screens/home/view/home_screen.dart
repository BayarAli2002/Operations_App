import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart'; // import your flushbar extension here
import 'package:crud_app/source/core/transations/local_keys.g.dart';
import 'package:crud_app/source/features/screens/home/view/widgets/product_widget.dart';
import 'package:easy_localization/easy_localization.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final isEmpty = provider.products.isEmpty;
        return ConditionalBuilder(
          condition: !provider.isLoading && provider.errorMessage == null && !isEmpty,
          builder: (context) {
            return ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final productModel = provider.products[index];
                return ProductDetails(
                  productModel: productModel,
                
                );
              },
            );
          },
          fallback: (context) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (isEmpty) {
              return Center(
                child: Text(
                  LocaleKeys.noProductsFound.tr(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return Center(
                child: Text(
                  provider.errorMessage ?? "Something went wrong.",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
          },
        );
      },
    );
  }
}
