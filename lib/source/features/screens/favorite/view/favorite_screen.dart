import 'package:crud_app/source/core/extension/extentions.dart';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/features/common_widgets/chached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'widgets/favorite_button_widget.dart';
import '../../home/view/product_details_screen.dart';
import '../provider/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isEmpty = favoriteProvider.favoriteProducts.isEmpty;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ConditionalBuilder(
      condition: favoriteProvider.isLoading,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      fallback: (context) {
        return ConditionalBuilder(
          condition: !isEmpty,
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
                        builder: (_) =>
                            ProductDetailsScreen(productId: favoriteModel.id!),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.onSurface.withAlpha((0.1 * 255).round()),
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
                          child:
                              ChachedNetworkImage(imageUrl: favoriteModel.image ?? ''),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favoriteModel.title ?? '',
                                style: theme.textTheme.bodyLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                favoriteModel.description ?? '',
                                style: theme.textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                favoriteModel.price?.withCurrency(context) ?? '',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        FavoriteButton(
                          productModel: favoriteModel,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          fallback: (context) {
            return Center(
              child: Text(
                LocaleKeys.favoriteEmpty.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
