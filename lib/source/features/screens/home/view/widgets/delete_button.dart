import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/features/screens/favorite/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../provider/product_provider.dart';

class DeleteButton extends StatefulWidget {
  final String productId;

  const DeleteButton({super.key, required this.productId});

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  Future<void> _confirmAndDelete() async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          LocaleKeys.confirm_delete_title.tr(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary, // from your theme
          ),
        ),
        content: Text(
          LocaleKeys.confirm_delete_message.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 16.sp,
            color: theme.colorScheme.onSurface, // from your theme
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.surface.withAlpha(
                (0.7 * 255).round(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              LocaleKeys.no.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: Colors
                  .redAccent, // destructive action (no error color in theme)
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              LocaleKeys.yes.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false,);
      await productProvider.deleteProduct(widget.productId);
      await favoriteProvider.removeFavorite(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _confirmAndDelete,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withAlpha((0.7 * 255).round()),
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
          color: theme.colorScheme.onSurface,
          size: 28.sp,
        ),
      ),
    );
  }
}
