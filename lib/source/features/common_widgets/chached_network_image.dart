import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_app/source/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ChachedNetworkImage extends StatelessWidget {
  final String? imageUrl;

  const ChachedNetworkImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: double.infinity,
            height: 200.h,
            color: Colors.grey,
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          AppImages.palceHolder,
          width: double.infinity,
          height: 200.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
