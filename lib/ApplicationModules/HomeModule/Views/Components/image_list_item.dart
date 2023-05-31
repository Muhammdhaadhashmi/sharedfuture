import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../../../../Utils/app_colors.dart';
import '../../../../Utils/dimensions.dart';
import '../../../../Utils/token.dart';

class ImageListItem extends StatelessWidget {
  final image;
  final double radius;

  const ImageListItem({
    super.key,
    required this.image,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: OptimizedCacheImage(
        imageUrl: "${Token.ImageDir}${image}",
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
            color: AppColors.mainColor,
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          color: AppColors.red,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
