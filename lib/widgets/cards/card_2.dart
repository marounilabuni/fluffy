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

class Card2 extends StatefulWidget {
  Product product;
  bool isAdmin;

  Card2(this.product, {this.isAdmin = false, super.key});

  @override
  State<Card2> createState() => _Card2State();
}

class _Card2State extends State<Card2> {
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
        clipBehavior: Clip.hardEdge,

        elevation: 1,

        surfaceTintColor: Colors.transparent,
        //color: Colors.transparent,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.product.largeImageUrlGetter),
                fit: BoxFit.cover),
            gradient: const LinearGradient(
              begin: FractionalOffset(0, 0.005),
              end: FractionalOffset(0.81, 0.995),
              colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(243, 241, 241, 1),
                Color.fromRGBO(222, 201, 233, 1),
              ],
            ),
          ),
          child: CustomFancyCard(
            bgColor: Colors.transparent,
            title: item['title'].toString(),
            image: 1 == 1
                ? SizedBox()
                : (1 == 12
                    ? Image.network(
                        "${product.smallImageUrlGetter}&i=${cache_num}",
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
                              child:
                                  Image.asset('assets/images/logo_t.png'),
                            ),
                          );
                        },
                        //'assets/images/items/${item['index'].toString()}.jpg',
                      )
                    : FutureBuilder(
                        future: getImageUrl(
                          's${product.id}.png',
                        ),
                        builder: (context, snapshot) => (snapshot
                                        .connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData &&
                                snapshot.data.toString().isNotEmpty)
                            ? DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Image.network(
                                  '${product.smallImageUrlGetter}&i=${Random().nextInt(100)}',
                                  fit: BoxFit.cover,
                                  color: Colors.transparent,

                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            primary.withAlpha(160),
                                            BlendMode
                                                .srcIn // This blend mode replaces white with `newColor`
                                            ),
                                        child: Image.asset(
                                            'assets/images/logo_t.png'),
                                      ),
                                    );
                                  },
                                  //'assets/images/items/${item['index'].toString()}.jpg',
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      primary.withAlpha(160),
                                      BlendMode
                                          .srcIn // This blend mode replaces white with `newColor`
                                      ),
                                  child: Image.asset(
                                      'assets/images/logo_t.png'),
                                ),
                              )

                        //

                        )),

            //

            trailing: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$ils ${formatQuantity(item['price'])}',
                    style: TextStyle(
                      fontSize: screenWidth > 370 ? 14 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.arrow_back_ios,
                    size: screenWidth > 370 ? 23 : 22,
                  )
                ],
              ),
            ),

            subtitle: product.description,

            ///
          ),
        ),
      ),
    );
  }
}
