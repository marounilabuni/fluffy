import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_menu/backend/firebase/firestore_agent.dart';
import 'package:food_menu/backend/product/options/product_option.dart';
import 'package:food_menu/backend/product/product.dart';
import 'package:food_menu/constants.dart';
import 'package:food_menu/fancy_card/custom%20copy%202.dart';
import 'package:food_menu/fluffy/admin/dialog.dart';
import 'package:http/http.dart' as http;
//
import 'package:dio/dio.dart';

final dio = Dio();

Future<Uint8List?> fetchImageAsUint8List(String imageUrl) async {
  try {
    // Define the cache control headers
    var cacheControlHeaders = {
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache', // HTTP/1.0 backward compatibility
      'Expires': '0', // Proxies
    };

    // Set the options for the request
    var options = Options(
      responseType: ResponseType.bytes,
      headers: cacheControlHeaders,
    );
    final response = await dio.get(
      imageUrl,
      options: options,
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the Uint8List
      return response.data;
      //return response.bodyBytes;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      return null;
    }
  } catch (_) {
    print('err $_');
    return null;
  }
}

Future<Uint8List?> _fetchImageAsUint8List(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    // If the server returns an OK response, parse the Uint8List
    return response.bodyBytes;
  } else {
    // If the server did not return a 200 OK response,
    // throw an exception.
    return null;
  }
}
