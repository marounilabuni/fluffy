import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_menu/backend/image_resizer.dart';
import 'package:food_menu/backend/product/product.dart';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_menu/backend/firebase/firestore_agent.dart';
import 'package:food_menu/backend/firebase/storage_agent.dart';
import 'package:food_menu/backend/product/options/product_option.dart';
import 'package:food_menu/backend/product/product.dart';
import 'package:food_menu/constants.dart';
import 'package:food_menu/fancy_card/custom%20copy%202.dart';
import 'package:food_menu/fluffy/admin/dialog.dart';
import 'package:http/http.dart' as http;

import 'package:food_menu/utils/http/http.dart';

class Card3 extends StatefulWidget {
  Product product;
  bool isAdmin;

  Card3(this.product, {this.isAdmin = false, super.key});

  @override
  State<Card3> createState() => _Card3State();
}

class _Card3State extends State<Card3> {
  bool get isAdmin => widget.isAdmin;

  Product get product => widget.product;
  Map<String, dynamic> get item => widget.product.toMap();

  void showAdminDialog() {
    showDialog<Product>(
      context: context,
      builder: (_) {
        return ItemDialog(
          Product.fromMap(Map.from(item)),
          editMode: true,
        );
      },
    ).then((value) {
      if (value != null) {
        cache_num = Random().nextInt(1000);
      }
      if (mounted) setState(() {});
    });
  }

  void showClientDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return ItemDialog(
          Product.fromMap(Map.from(item)),
        );
      },
    ).then((value) {
      if (mounted) setState(() {});
    });
  }

  Future<String> getImageUrl(String imagePath) async {
    //await Future.delayed(Duration(seconds: 2));
    final storageRef = FirebaseStorage.instance.ref();
    try {
      final imageRef = storageRef.child('images').child(imagePath);
      // Try to get the download URL
      final imageUrl = await imageRef.getDownloadURL();
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      return '';
    }
  }

  int cache_num = Random().nextInt(1000);
  @override
  Widget build(BuildContext context) {
    // get screenWidth
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: () {
        showClientDialog();
      },
      onTap: isAdmin ? showAdminDialog : showClientDialog,
      child: Card(
        elevation: 10,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            //border: Border.all(),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            color: Colors.red,
            child: Row(
              children: [
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.orangeAccent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          //margin: const EdgeInsets.only(top: 12, left: 8),
                          child: Text(
                            item['title'].toString(),
                            locale: Locale('he'),
                            style: TextStyle(
                              locale: Locale('he'),
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          //margin: const EdgeInsets.only(top: 8 / 2 / 2 / 2, left: 8),
                          child: Text(
                            product.description,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w300),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        ////

                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            '$ils ${formatQuantity(item['price'])}',
                            style: TextStyle(
                              fontSize: screenWidth > 370 ? 14 : 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///
                Expanded(
                  flex: 1,
                  child: Image.network(
                    product.smallImageUrlGetter,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              primary.withAlpha(160),
                              BlendMode
                                  .srcIn // This blend mode replaces white with `newColor`
                              ),
                          child: Image.asset('assets/images/logo_t.png'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
