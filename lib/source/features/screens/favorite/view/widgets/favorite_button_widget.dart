import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/favorite_provider.dart';
import '../../../home/data/model/product_model.dart';
class FavoriteButton extends StatefulWidget {
  final ProductModel productModel;

  const FavoriteButton({
    super.key,
    required this.productModel,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, _) {
        final isFav = favoriteProvider.isFavorite(widget.productModel.id ?? '');
        return GestureDetector(
          onTap: () async {
             await favoriteProvider.toggleFavorite(widget.productModel);
          },
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
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav
                  ? theme.colorScheme.primary // Use secondary color for favorited
                  : theme.colorScheme.onSurface.withAlpha((0.5 * 255).round()), // dimmed non-favorited
              size: 28.sp,
            ),
          ),
        );
      },
    );
  }
}
