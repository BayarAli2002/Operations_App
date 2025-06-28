import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/model/product_model.dart';
import '../../../root/view/add_update_screen.dart';

class UpdateButton extends StatelessWidget {
  final ProductModel productModel;

  const UpdateButton({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton.icon(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => AddUpdateProductScreen(product: productModel),
            ),
          );
        },
        icon: Icon(
          Icons.edit,
          color: theme.colorScheme.onPrimary,
          size: 20.sp,
        ),
        label: Text(
          'Edit',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
