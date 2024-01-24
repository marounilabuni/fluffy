// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'dart:math';
import 'package:food_menu/utils/http/http.dart';
import 'package:food_menu/widgets/loading/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_menu/backend/firebase/firestore_agent.dart';
import 'package:food_menu/backend/firebase/realtime_agent.dart';
import 'package:food_menu/backend/firebase/storage_agent.dart';
import 'package:food_menu/backend/product/options/product_option.dart';
import 'package:food_menu/backend/product/product.dart';
import 'package:food_menu/backend/product/category.dart';
import 'package:food_menu/constants.dart';
import 'package:food_menu/image_card/custom_image_card.dart';
import 'package:food_menu/widgets/image_picker/image_picker_icon.dart';
import 'package:image_card/image_card.dart';

String formatQuantity(num v) {
  return v.toStringAsFixed(2);
}

class ItemDialog extends StatefulWidget {
  Product product;
  bool editMode;
  ItemDialog(
    this.product, {
    this.editMode = false,
    super.key,
  });

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  bool get editMode => widget.editMode;
  String price = '';
  late ImagePickerIcon imagePickerIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    price = widget.product.price.toString();
    imagePickerIcon = ImagePickerIcon(
      url: widget.product.largeImageUrlGetter,
      refresh: () {
        if (mounted) setState(() {});
      },
    );
    (1 == 12
            ? StorageAgent.getImageData(
                's${widget.product.id}.png',
              )
            : fetchImageAsUint8List(widget.product.smallImageUrlGetter))
        .then((value) {
      smallImageData = value;
    });
  }

  Uint8List? smallImageData;

  @override
  Widget build(BuildContext context) {
    // get screen Width
    final double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        // This line is responsible for the border radius
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      clipBehavior: Clip.hardEdge,
      scrollable: screenWidth > 400,
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Stack(
          children: [
            CustomFillImageCard(
                color: Colors.transparent,
                heightImage: 280, //max(280, screenWidth / 2.5),
                width: 1000,
                // AssetImage('assets/images/logo_t.png')
                imageWidget: imagePickerIcon.data != null
                    ? null
                    : FutureBuilder<Uint8List?>(
                        future: 1 == 1
                            ? StorageAgent.getImageData(
                                'l${widget.product.id}.png',
                              )
                            : fetchImageAsUint8List(
                                widget.product.largeImageUrlGetter,
                              ),
                        builder: (context, snapshot) {
                          final Uint8List? img = snapshot.data;
                          if (img == null) {
                            if (smallImageData != null) {
                              return Container(
                                width: screenWidth,
                                height: 280,
                                child: Image.memory(
                                  smallImageData!,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        primary.withAlpha(160),
                                        BlendMode
                                            .srcIn // This blend mode replaces white with `newColor`
                                        ),
                                    child: Image.asset(
                                      'assets/images/logo_t.png',
                                      height: 280,
                                    ),
                                  ),
                                ),

                                //
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  Positioned.fill(
                                    child: Center(
                                        child: 1 == 12
                                            ? LoadingAnimationWidget
                                                .prograssiveDots(
                                                color: primary, // Colors.red,
                                                size: 120,
                                              )
                                            : LoadingAnimationWidget.inkDrop(
                                                color: primary, // Colors.red,
                                                size: 120,
                                              )),
                                  )
                              ],
                            );
                          }

                          ///
                          //
                          return Container(
                            width: screenWidth,
                            height: 280,
                            child: Image.memory(
                              img,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                imageProvider: imagePickerIcon.changed == false
                    ? Image.network(
                        widget.product.largeImageUrlGetter,
                      ).image
                    : (imagePickerIcon.data != null
                        ? Image.memory(
                            imagePickerIcon.data!,
                          ).image
                        : AssetImage('assets/images/logo_t.png')),
                title: editMode
                    ? TextFormField(
                        initialValue: widget.product.title,
                        onChanged: (v) => widget.product.title = v.trim(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        widget.product.title,
                        locale: Locale('he'),
                        style: const TextStyle(
                          locale: Locale('he'),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                description: editMode
                    ? TextFormField(
                        initialValue: widget.product.description,
                        onChanged: (v) => widget.product.description = v.trim(),
                        minLines: 2,
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w400),
                      )
                    : IgnorePointer(
                        child: TextFormField(
                          //enabled: false,
                          initialValue: widget.product.description,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            border: InputBorder.none,
                          ),

                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[1000],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 5,
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ),
                footer: Align(
                  alignment: Alignment.centerLeft,
                  child: editMode
                      ? TextFormField(
                          //keyboardType: TextInputType.number,

                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          initialValue: widget.product.price.toString(),
                          textDirection: TextDirection.ltr,
                          onChanged: (v) {
                            price = v.trim();
                            widget.product.price =
                                num.tryParse(v.trim()) ?? widget.product.price;
                          },
                        )
                      : Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            '  $ils ${formatQuantity(widget.product.price)}',
                            locale: Locale('he'),
                            style: TextStyle(
                              locale: Locale('he'),
                              // fontSize: screenWidth > 370 ? 14 : 13,
                              // fontWeight: FontWeight.w500,
                              fontSize: screenWidth > 370 ? 14 : 13,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                )

                //
                ),
            if (editMode)
              Positioned(
                top: 20,
                left: 20,
                child: imagePickerIcon,
              ),
            if (editMode)
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100000),
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.delete,
                      size: 28,
                      color: Colors.red,
                    ),
                  ),
                  onLongPress: () {
                    Future<void> fun() async {
                      await StorageAgent.removeImages(widget.product)
                          .then((value) {
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    }

                    showLoadingDialog(context: context, f1: fun);
                  },
                ),
              ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: editMode
          ? [
              TextButton(
                onPressed: () async {
                  if (widget.product.id.isNotEmpty) {
                    Product.categories.forEach((category) {
                      if (category.name == widget.product.category) {
                        category.products.removeWhere(
                          (element) => element.id == widget.product.id,
                        );
                      }
                    });

                    Future<void> fun() async {
                      await FireStoreAgent.saveAll();

                      StorageAgent.removeImages(widget.product);
                    }

                    await showLoadingDialog(
                      context: context,
                      f1: fun,
                    );

                    ///
                  }
                  Navigator.pop(context);
                  //
                },
                child: Text(
                  widget.product.id.isNotEmpty ? "מחק" : "ביטול",
                  locale: Locale('he'),
                  style: TextStyle(
                    color: Colors.red,
                    locale: Locale('he'),
                  ),
                ),
              ),

              /////

              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromRGBO(120, 78, 196, 1)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () async {
                  // validate

                  num price_num = num.tryParse(price) ?? -1;

                  if (widget.product.price != price_num) {
                    return;
                  }

                  String catName = widget.product.category;
                  Category category = Product.categories
                      .firstWhere((c) => c.name == catName, orElse: () {
                    var c = Product.addCategory(catName);

                    return c;
                  });

                  // save
                  int index = -1;
                  for (int i = 0; i < category.products.length; i++) {
                    if (widget.product.id == category.products[i].id) {
                      index = i;
                      break;
                    }
                  }
                  if (index == -1) {
                    category.products.add(widget.product);
                  } else {
                    try {
                      //Product.products[index] = widget.product;

                      Product p = category.products[index];
                      p.title = widget.product.title;
                      p.description = widget.product.description;
                      p.price = widget.product.price;
                    } catch (_) {
                      return;
                    }
                  }

                  if (imagePickerIcon.changed) {
                    Future<void> fun() async {
                      print('sssss');
                      await Future.delayed(Duration(milliseconds: 10));

                      await FireStoreAgent.saveAll();
                      await Future.delayed(Duration(milliseconds: 10));
                      await StorageAgent.saveImage(
                        widget.product,
                        imagePickerIcon.data,
                      );
                      print('eeeee');
                    }

                    await showLoadingDialog(
                      context: context,
                      f1: fun,
                    );
                  } else {
                    await showLoadingDialog(
                      context: context,
                      f1: FireStoreAgent.saveAll,
                    );
                  }

                  //await FireStoreAgent.saveAll();

                  Navigator.pop(context, widget.product);
                },
                child: Text("שמור"),
              ),
            ]
          : null,
    );
  }
}
