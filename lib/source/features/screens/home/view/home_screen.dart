import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/features/common_widgets/loading_widget.dart';
import 'package:crud_app/source/features/screens/home/view/widgets/product_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return ConditionalBuilder(
          condition: provider.isLoading,
          builder: (context) => const Center(child: LoadingWidget()),

          fallback: (context) => ConditionalBuilder(
            condition: provider.errorMessage != null,
            builder: (context) => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.errorMessage!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: provider.fetchProducts,
                      child: Text(
                        "Retry",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            fallback: (context) => ConditionalBuilder(
              condition: provider.products.isNotEmpty,
              builder: (context) => ListView.builder(
                padding: EdgeInsets.all(12.w),
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final productModel = provider.products[index];
                  return ProductWidgetDetails(productModel: productModel);
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
            ),
          ),
        );
      },
    );
  }
}
