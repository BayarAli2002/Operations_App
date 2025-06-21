import 'package:crud_app/Source/core/extension/extentions.dart';
import 'package:crud_app/source/features/common_widgets/chached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/favorite_button.dart';
import '../../data/model/product_model.dart';
import '../product_details_screen.dart';
import 'delete_button.dart';
import 'update_button.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel productModel;
  final Function(String message) showFlushbar;

  const ProductDetails({
    super.key,
    required this.productModel,
    required this.showFlushbar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(productId: productModel.id!),
          ),
        );
      },
      child: Container(
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
            Stack(
              children: [
                ChachedNetworkImage(imageUrl: productModel.image ?? ''),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: DeleteButton(
                    productId: productModel.id!,
                    showFlushbar: showFlushbar,
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: FavoriteButton(
                    productModel: productModel,
                    showFlushBar: showFlushbar,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    productModel.price?.withCurrency(context) ?? '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  UpdateButton(productModel: productModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
