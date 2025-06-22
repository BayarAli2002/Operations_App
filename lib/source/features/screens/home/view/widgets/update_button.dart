import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/product_model.dart';
import '../../../root/view/widgets/add_update_screen.dart';

class UpdateButton extends StatelessWidget {
  final ProductModel productModel;

  const UpdateButton({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => AddUpdateProductScreen(product: productModel),
            ),
          );
        },
        icon: Icon(
          Icons.edit,
          color: theme.colorScheme.onPrimary, // icon color from theme
          size: 20.sp,
        ),
        style: IconButton.styleFrom(
          backgroundColor: theme.colorScheme.primary, // button bg from theme
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}
