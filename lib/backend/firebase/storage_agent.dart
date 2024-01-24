import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_menu/backend/image_resizer.dart';
import 'package:food_menu/backend/product/product.dart';

abstract class StorageAgent {
  static var ref = FirebaseStorage.instance.ref('images');

  static Future<bool> removeImages(Product product) async {
    try {
      ref
          .child('s${product.id}.png')
          .delete()
          .onError((error, stackTrace) => null);
    } catch (_) {}
    try {
      ref
          .child('l${product.id}.png')
          .delete()
          .onError((error, stackTrace) => null);
    } catch (_) {}
    return true;
  }

  static Future<Uint8List?> getImageData(String childName) async {
    try {
      var child = ref.child(childName);

      return await child.getData();
    } catch (_) {
      return null;
    }
  }

  ////
  ///
  ///
  ///
  ///
  ///

  static Future<bool> saveImage(Product product, Uint8List? imageData) async {
    if (imageData == null) {
      return false;
    }
    if (product.id.isEmpty) {
      return false;
    }
    bool res = false;
    imageData = await ImageResizer.futureResize(
      imageData,
      width: 1200,
    );
    try {
      await ref.child('s${product.id}.png').putData(
            await ImageResizer.futureResize(
              imageData,
              width: 120,
            ),
          );

      ///
      try {
        ref.child('l${product.id}.png').putData(
              imageData,
            );
      } catch (_) {}

      ///
    } catch (_) {}

    return res;
  }

  static Future<bool> _saveImage(Product product, Uint8List? imageData) async {
    if (imageData == null) {
      return false;
    }
    if (product.id.isEmpty) {
      return false;
    }
    bool res = false;
    Future.delayed(Duration(seconds: 20));
    imageData = ImageResizer.resize(
      imageData,
      width: 1200,
    );
    try {
      await ref.child('s${product.id}.png').putData(
            ImageResizer.resize(
              imageData,
              width: 120,
            ),
          );

      ///
      try {
        ref.child('l${product.id}.png').putData(
              imageData,
            );
      } catch (_) {}

      ///
    } catch (_) {}

    return res;
  }
}
