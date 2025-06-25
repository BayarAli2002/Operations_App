import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/features/common_widgets/loading_widget.dart';
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
    Future.delayed(Duration.zero, () {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
      productProvider.fetchProducts();
      favoriteProvider.loadFavorites();
    });
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
          builder: (context) => const Center(
            child: LoadingWidget(),
          ),
          fallback: (context) {
            if (provider.errorMessage != null) {
              // Show error message + retry button
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        provider.errorMessage!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => provider.fetchProducts(),
                        child: Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (isEmpty) {
              return Center(
                child: Text(
                  LocaleKeys.noProductsFound.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final productModel = provider.products[index];
                return ProductWidgetetails(productModel: productModel);
              },
            );
          },
        );
      },
    );
  }
}
