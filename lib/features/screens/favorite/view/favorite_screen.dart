import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_app/core/extension/extentions.dart';
import 'package:crud_app/translations/local_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../common_widgets/favorite_button.dart';
import '../../home/view/product_details_screen.dart';
import '../provider/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoriteProducts = favoriteProvider.favoriteProducts;

    return favoriteProducts.isEmpty
        ? Center(
            child: Text(
              LocaleKeys.favoriteEmpty.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(12.w),
            itemCount: favoriteProducts.length,
            itemBuilder: (ctx, index) {
              final product = favoriteProducts[index];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context,rootNavigator: true,).push(

                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailsScreen(productId: product.id!),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.r,
                        offset: Offset(0, 3.h),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Product image using CachedNetworkImage
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          imageUrl: product.image ?? '',
                          width: 90.w,
                          height: 90.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 90.w,
                            height: 90.h,
                            color: Colors.grey.shade300,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/placeholder.jpg",
                            width: 90.w,
                            height: 90.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Product details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title ?? '',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              product.description ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              product.price?.withCurrency(context) ?? '',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Favorite button
                      FavoriteButton(
                        productModel: product,
                        showFlushBar: (message) {
                          Flushbar(
                            message: message,
                            duration: const Duration(seconds: 3),
                            flushbarPosition: FlushbarPosition.TOP,
                            backgroundColor: Colors.black87,
                            margin: const EdgeInsets.all(8),
                            borderRadius: BorderRadius.circular(8),
                          ).show(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
