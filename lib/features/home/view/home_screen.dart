import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_app/features/common_widgets/drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../favorite/provider/favorite_provider.dart';
import '../provider/product_database_operations.dart';
import '../../../core/static_texts/static_app_texts.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    Provider.of<FavoriteProvider>(context, listen: false).fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: EdgeInsets.all(12.w),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final productModel = provider.products[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
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
                    // Image with favorite and delete icons overlay
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
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
                              child: const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                        // Delete button top-left
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
                                    'confirm_delete_title'.tr(),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.shade700,
                                    ),
                                  ),
                                  content: Text(
                                    'confirm_delete_message'.tr(),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      child: Text(
                                        'no'.tr(),
                                        style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      child: Text(
                                        'yes'.tr(),
                                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                final provider = Provider.of<ProductProvider>(context, listen: false);
                                await provider.deleteProduct(productModel.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(StaticAppTexts.productDeleted)),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
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

                        // Favorite icon top-right
                        // Favorite button top-right with restored design
                        Positioned(
                          top: 12.h,
                          right: 12.w,
                          child: Consumer<FavoriteProvider>(
                            builder: (context, favoriteProvider, _) {
                              final isFav = favoriteProvider.isFavorite(productModel.id ?? '');

                              return GestureDetector(
                                onTap: () async {
                                  if (isFav) {
                                    await favoriteProvider.removeFavorite(productModel.id ?? '');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("favorite_removed".tr())),
                                    );
                                  } else {
                                    await favoriteProvider.addFavorite(productModel);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("favorite_added".tr())),
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
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

                    // Text details below image
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                        ],
                      ),
                    ),
                  ],
                ),
              );



            },
          );
        },
      ),

    );
  }
}
