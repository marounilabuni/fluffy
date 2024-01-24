import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

abstract class ImageResizer {
  static Uint8List resize(
    Uint8List imageData, {
    int width = 350,
  }) {
    img.Image image = img.decodeImage(imageData)!;
    double ratio = image.width / image.height;
    if (ratio > 1.25) {
      width = width * 1.6 ~/ 1;
    }
    
    if (image.width < width) {
      return imageData;
    }

    int height = width ~/ ratio + 1;

    img.Image resizedImage =
        img.copyResize(image, width: width, height: height);
    return Uint8List.fromList(img.encodePng(resizedImage));
  }

  static Future<Uint8List> futureResize(
    Uint8List imageData, {
    int width = 350,
  }) async{
    
    img.Image image = img.decodeImage(imageData)!;
    double ratio = image.width / image.height;
    if (ratio > 1.25) {
      width = width * 1.6 ~/ 1;
    }
    
    if (image.width < width) {
      return imageData;
    }

    int height = width ~/ ratio + 1;

    img.Image resizedImage =
        img.copyResize(image, width: width, height: height);
    return Uint8List.fromList(img.encodePng(resizedImage));
  }


}
