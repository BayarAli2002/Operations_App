import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
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
    final theme = Theme.of(context);

    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final isEmpty = provider.products.isEmpty;

        return ConditionalBuilder(
          condition: provider.isLoading,
          builder: (context) => Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ),
          fallback: (context) {
            return ConditionalBuilder(
              condition: !isEmpty,
              builder: (context) => ListView.builder(
                padding: EdgeInsets.all(12.w),
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final productModel = provider.products[index];
                  return ProductDetails(productModel: productModel);
                },
              ),
              fallback: (context) => Center(
                child: Text(
                  LocaleKeys.noProductsFound.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
