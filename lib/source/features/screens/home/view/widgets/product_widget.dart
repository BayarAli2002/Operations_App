import 'package:crud_app/source/core/extensions/price_extension.dart';
import 'package:crud_app/source/features/common_widgets/chached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../favorite/view/widgets/favorite_button_widget.dart';
import '../../data/model/product_model.dart';
import '../product_details_screen.dart';
import 'delete_button.dart';
import 'update_button.dart';

class ProductWidgetDetails extends StatelessWidget {
  final ProductModel productModel;

  const ProductWidgetDetails({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          color: theme.colorScheme.surface,
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
                SizedBox(
                  height: 220.h,
                  width: double.infinity,
                  child: CustomCachedNetworkImage(imageUrl: productModel.image ?? ''),
                ),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: DeleteButton(productId: productModel.id!),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: FavoriteButton(productModel: productModel),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productModel.title ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "ID: ${productModel.id ?? ''}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyMedium?.color?.withAlpha((0.6*255).round()),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    productModel.description ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14.sp,
                      color: theme.textTheme.bodySmall?.color?.withAlpha((0.7*255).round()),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    productModel.price?.withCurrency(context) ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
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
