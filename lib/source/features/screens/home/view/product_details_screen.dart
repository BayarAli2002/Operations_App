import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:crud_app/source/core/extension/extentions.dart';
import 'package:crud_app/source/core/transations/local_keys.g.dart';
import 'package:crud_app/source/features/common_widgets/chached_network_image.dart';
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
      loadData(); // Safe to use context here
    });
  }

  //Recommended to use WidgetsBinding to ensure context is ready
  Future<void> loadData() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    if (productProvider.selectedProduct?.id != widget.productId) {
      await productProvider.fetchProductById(widget.productId ?? '');
    }
  }

  Future<void> _toggleFavorite(
    productDetailModel,
    FavoriteProvider favoriteProvider,
  ) async {
    final isFav = favoriteProvider.isFavorite(productDetailModel.id ?? '');
    if (isFav) {
      await favoriteProvider.removeFavorite(productDetailModel.id ?? '');

      if (!mounted) return;
      context.showFlushbar(LocaleKeys.favorite_removed.tr());
    } else {
      await favoriteProvider.addFavorite(productDetailModel);

      if (!mounted) return;
      context.showFlushbar(LocaleKeys.favorite_added.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.product_details_page.tr()),
        centerTitle: true,
        backgroundColor: Colors.teal.shade300,
        elevation: 0,
      ),
      body: Consumer2<ProductProvider, FavoriteProvider>(
        builder: (context, productProvider, favoriteProvider, _) {
          return ConditionalBuilder(
            condition: !productProvider.isLoading &&
                productProvider.errorMessage == null &&
                productProvider.selectedProduct != null,
            builder: (context) {
              final productDetailModel = productProvider.selectedProduct!;
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                children: [
                  // Image with buttons container
                  SizedBox(
                    height: 280.h,
                    child: Stack(
                      children: [
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ChachedNetworkImage(
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
                              onTap: () => _toggleFavorite(
                                productDetailModel,
                                favoriteProvider,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  favoriteProvider.isFavorite(
                                          productDetailModel.id ?? '')
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: favoriteProvider.isFavorite(
                                          productDetailModel.id ?? '')
                                      ? Colors.red
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
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade600,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          productDetailModel.price?.withCurrency(context) ?? '',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Divider(color: Colors.grey.shade300, thickness: 2),

                  SizedBox(height: 12.h),

                  Text(
                    productDetailModel.id ?? '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    'description'.tr(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    productDetailModel.description ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 80.h),
                ],
              );
            },
            fallback: (context) {
              if (productProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              } else {
                return Center(
                  child: Text(
                    productProvider.errorMessage ?? 'Something went wrong',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
