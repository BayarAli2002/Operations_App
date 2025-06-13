import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_app/features/home/view/product_details_screen.dart';
import 'package:crud_app/transations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../common_widgets/add_update_product.dart';
import '../../favorite/provider/favorite_provider.dart';
import '../provider/product_provider.dart';
import '../../../core/static_texts/static_app_texts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    Provider.of<FavoriteProvider>(context, listen: false).fetchFavorites();
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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailsScreen(productId: productModel.id!)));
              },
              child: Container(
                margin:
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.r)),
                          child: CachedNetworkImage(
                            imageUrl: productModel.image ?? '',
                            width: double.infinity,
                            height: 180.h,
                            fit: BoxFit.cover,
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: double.infinity,
                                height: 180.h,
                                color: Colors.grey,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: double.infinity,
                              height: 180.h,
                              color: Colors.grey.shade300,
                              child:
                              const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12.h,
                          left: 12.w,
                          child: GestureDetector(
                            onTap: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  title: Text(
                                    LocaleKeys.confirm_delete_title.tr(),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.shade700,
                                    ),
                                  ),
                                  content: Text(
                                    LocaleKeys.confirm_delete_message.tr(),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  actionsPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 10.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      child: Text(
                                        LocaleKeys.no.tr(),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.black87),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 10.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      child: Text(
                                        LocaleKeys.yes.tr(),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                final provider = Provider.of<ProductProvider>(
                                    context,
                                    listen: false);
                                await provider.deleteProduct(productModel.id!);
                                showFlushbar(
                                    context, StaticAppTexts.productDeleted);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha((0.7*255).round()),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.r,
                                    offset: Offset(0, 2.h),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(8.w),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.black26,
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12.h,
                          right: 12.w,
                          child: Consumer<FavoriteProvider>(
                            builder: (context, favoriteProvider, _) {
                              final isFav =
                              favoriteProvider.isFavorite(productModel.id ?? '');
                              return GestureDetector(
                                onTap: () async {
                                  if (isFav) {
                                    await favoriteProvider
                                        .removeFavorite(productModel.id ?? '');
                                    showFlushbar(context, LocaleKeys.favorite_removed.tr());
                                  } else {
                                    await favoriteProvider.addFavorite(productModel);
                                    showFlushbar(context, LocaleKeys.favorite_added.tr());
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.white.withAlpha((0.7*255).round()),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4.r,
                                        offset: Offset(0, 2.h),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(8.w),
                                  child: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.black26,
                                    size: 28.sp,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productModel.title ?? '',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "ID: ${productModel.id ?? ''}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            productModel.description ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${productModel.price} USD',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 12.h),

                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddUpdateProductScreen(product: productModel),
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              icon: Icon(Icons.edit, color: Colors.white, size: 20.sp),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
