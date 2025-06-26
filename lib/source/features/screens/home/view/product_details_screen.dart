import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:crud_app/source/core/extensions/price_extension.dart';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/features/common_widgets/chached_network_image.dart';
import 'package:crud_app/source/features/common_widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../favorite/provider/favorite_provider.dart';
import '../provider/product_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String? productId;

  const ProductDetailsScreen({super.key, this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    if (productProvider.selectedProduct?.id != widget.productId) {
      await productProvider.fetchProductById(widget.productId ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.product_details_page.tr()),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: Consumer2<ProductProvider, FavoriteProvider>(
        builder: (context, productProvider, favoriteProvider, _) {
          return ConditionalBuilder(
            condition: productProvider.isLoading,
            builder: (context) =>
                const Center(child: LoadingWidget()),
            fallback: (context) {
              return ConditionalBuilder(
                condition: productProvider.selectedProduct != null,
                builder: (context) {
                  final productDetailModel = productProvider.selectedProduct!;
                  return ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    children: [
                      SizedBox(
                        height: 280.h,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: CustomCachedNetworkImage(

                                imageUrl: productDetailModel.image ?? '',
                              ),
                            ),
                            Positioned(
                              top: 12.h,
                              right: 12.w,
                              child: Material(
                                color: Colors.black45,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => favoriteProvider.toggleFavorite(productDetailModel),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Icon(
                                      favoriteProvider.isFavorite(
                                            productDetailModel.id ?? '',
                                          )
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          favoriteProvider.isFavorite(
                                            productDetailModel.id ?? '',
                                          )
                                          ?theme.colorScheme.primary
                                          : Colors.white,
                                      size: 28.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              productDetailModel.title ?? '',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              productDetailModel.price?.withCurrency(context) ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 18.sp,
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Divider(color: theme.dividerColor, thickness: 2),
                      SizedBox(height: 12.h),
                      Text(
                        productDetailModel.id ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 18.sp,
                          color: theme.colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        LocaleKeys.description.tr(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        productDetailModel.description ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 16.sp,
                          color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 80.h),
                    ],
                  );
                },
                fallback: (context) => Center(
                  child: Text(
                    LocaleKeys.noProductsFound.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 18.sp,
                      color: theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()),

                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
