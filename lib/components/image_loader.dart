import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CachedNetworkImage buildCachedNImage(
    {@required String image,
    @required double iconSize,
    @required Color iconColor}) {
  return CachedNetworkImage(
    fadeInCurve: Curves.slowMiddle,
    fadeInDuration: Duration(milliseconds: 1500),
    imageUrl: image,
    errorWidget: (context, url, error) => Icon(
      Icons.error,
      color: iconColor,
      size: iconSize,
    ),
    fit: BoxFit.cover,
  );
}
