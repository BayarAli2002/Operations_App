import 'package:another_flushbar/flushbar.dart';
import 'package:crud_app/Source/core/extension/extentions.dart';
import 'package:crud_app/source/core/transations/local_keys.g.dart';
import 'package:crud_app/source/features/common_widgets/chached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import '../../../common_widgets/custom_favorite_button.dart';
import '../../home/view/product_details_screen.dart';
import '../provider/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isEmpty = favoriteProvider.favoriteProducts.isEmpty;
    return ConditionalBuilder(
      condition: !favoriteProvider.isLoading && favoriteProvider.errorMessage == null && !isEmpty,
      builder: (context) {
        final favorites = favoriteProvider.favoriteProducts;
        return ListView.builder(
          padding: EdgeInsets.all(12.w),
          itemCount: favorites.length,
          itemBuilder: (ctx, index) {
            final favoriteModel = favorites[index];

            return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(productId: favoriteModel.id!),
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
                    SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: ChachedNetworkImage(imageUrl: favoriteModel.image ?? ''),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            favoriteModel.title ?? '',
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            favoriteModel.description ?? '',
                            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            favoriteModel.price?.withCurrency(context) ?? '',
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.green[700]),
                          ),
                        ],
                      ),
                    ),
                    FavoriteButton(
                      productModel: favoriteModel,
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
      },
      fallback: (context) {
        if (favoriteProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } 
        else if(isEmpty) {
          return Center(
            child: Text(
              LocaleKeys.favoriteEmpty.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        }
        else {
          return Center(
            child: Text(
              favoriteProvider.errorMessage ?? "Something went wrong.",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
      },
    );
  }
}
