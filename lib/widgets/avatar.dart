import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool isNetworkImage;

  const Avatar({
    Key? key,
    required this.path,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.isNetworkImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(width / 2),
      child: isNetworkImage
          ? CachedNetworkImage(
              width: width,
              height: height,
              imageUrl: path,
              placeholder: (context, url) => placeholder ??
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              errorWidget: (context, url, error) =>
                  errorWidget ?? const Icon(Icons.error),
              fit: fit,
            )
          : Image.asset(
              path,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) =>
                  errorWidget ?? const Icon(Icons.error),
            ),
    );
  }
}
