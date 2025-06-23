import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_app/source/core/manager/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
 
  final BoxFit fit;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      fit: fit,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          color: Colors.grey,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        AppImages.palceHolder,
        fit: fit,
      ),
    );
  }
}
