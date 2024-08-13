
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FadingInPicture extends StatelessWidget {
  FadingInPicture({
    super.key,
    this.radius,
    this.applyBottomRadius = false,
    required this.url,
  });

  final String url;
  double? radius;
  bool applyBottomRadius;


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius ?? 0),
        topRight: Radius.circular(radius ?? 0),
        bottomLeft: applyBottomRadius ? Radius.circular(radius ?? 0) : Radius.zero,
        bottomRight: applyBottomRadius ? Radius.circular(radius ?? 0) : Radius.zero,
      ),
      child: ShaderMask(
        shaderCallback: (rect) {
          return const LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.darken,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          placeholder: (context, url) => Lottie.asset(
            'assets/picture_loading.json',
            fit: BoxFit.fill,
          ),
          imageUrl: url,
        ),
      ),
    );
  }
}
