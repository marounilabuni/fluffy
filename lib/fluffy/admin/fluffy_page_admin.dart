// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/gestures.dart';
import 'package:food_menu/widgets/animation_widget.dart';
import 'package:food_menu/widgets/cards/card_2.dart';
import 'package:food_menu/widgets/cards/card_3.dart';
import 'package:widget_loading/widget_loading.dart';

import 'package:food_menu/backend/product/category.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:food_menu/backend/product/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fancy_card/fancy_card.dart';
import 'package:food_menu/backend/firebase/firestore_agent.dart';
import 'package:food_menu/constants.dart';
import 'package:food_menu/fancy_card/custom.dart';
import 'package:food_menu/fluffy/admin/dialog.dart';
import 'package:food_menu/utils/custom_stream.dart';
import 'package:food_menu/utils/page_routes/page_route.dart';
import 'package:food_menu/widgets/cards/card_1.dart';
import 'package:food_menu/widgets/loading/loading_dialog.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart'
    as flutter_reorderable_list;

class FluffyPageAdmin extends StatefulWidget {
  bool isAdmin;
  FluffyPageAdmin({this.isAdmin = false, super.key});

  @override
  State<FluffyPageAdmin> createState() => _FluffyPageAdminState();
}

class _FluffyPageAdminState extends State<FluffyPageAdmin>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  //
  late Animation<double> _fadeAnimation;
  bool get isAdmin => widget.isAdmin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(controller);

    Future.delayed(Duration(seconds: 2), () {
      controller.addStatusListener((status) {
        //Future.delayed(Duration(milliseconds: 620), () {
        if (status == AnimationStatus.completed) {
          showLogo = false;
          CustomStream.instance.trigger();
        }
      });

      controller.forward();
    });
    //
  }

  bool showLogo = true;
  double screenWidth = 1000;

  @override
  Widget build(BuildContext context) {
    // get screen width
    screenWidth = MediaQuery.of(context).size.width;

    Widget createBody() {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/frenchcrepe.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: FractionalOffset(1 - 0.1, 0),
            end: FractionalOffset(0.1, 1),
            //stops:  [-1, 0.351, 0.3, 0.7, 1],
            colors: [
              Color.fromRGBO(235, 206, 214, 1),
              primary,
              Color.fromRGBO(210, 107, 194, 1),
            ],
          ),
        ),
        child: FadeInWidget(
          Center(
            child: Container(
              //padding: EdgeInsets.symmetric(vertical: 30),
              width: min(screenWidth, 510),
              //height: MediaQuery.of(context).size.height - kToolbarHeight,
              child: Container(
                child: isAdmin
                    ? ReorderableListView.builder(
                        header: Center(
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: screenWidth > 400 ? 16 : 0,
                              ),
                              child: Image.asset(
                                'assets/images/logo_t.png',
                                height: kToolbarHeight,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                        onReorder: (oldIndex, newIndex) {
                          //newIndex = min(newIndex, Product.categories.length - 1);

                          Category c1 = Product.categories[oldIndex];
                          c1.index = newIndex + 0.5;

                          Product.sortCategories();

                          //Product.categories.forEach()
                          showLoadingDialog(
                            context: context,
                            f1: FireStoreAgent.saveAll,
                          ).then((value) {});
                        },
                        shrinkWrap: true,
                        itemCount: Product.categories.length,
                        itemBuilder: (context, index) {
                          return categoryItemBuilder(
                            context,
                            index,
                            admin: screenWidth > 500,
                          );
                        },
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          Product.categories.length + 1,
                          (index) {
                            if (index == 0) {
                              return Center(
                                child: Container(
                                  child: Hero(
                                    tag: "logoHero",
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.0,
                                        horizontal: screenWidth > 400 ? 16 : 0,
                                      ),
                                      child: Image.asset(
                                        'assets/images/logo_t.png',
                                        height: kToolbarHeight,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return categoryItemBuilder(context, index - 1);
                          },
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: isAdmin
          ? StreamBuilder(
              stream: CustomStream.instance.stream,
              builder: (context, _) {
                if (isAdmin && controller.value == controller.upperBound) {
                  return FloatingActionButton(
                    onPressed: () {
                      addCategory(context).then((value) {
                        setState(() {});
                      });
                    },
                    child: Icon(
                      Icons.add,
                      //size: 30,
                    ),
                  );
                }

                return SizedBox();
              })
          : null,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: DefaultTextStyle(
              style: TextStyle(
                locale: Locale('he'),
              ),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (_, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.prograssiveDots(
                          color: primary,
                          size: 120,
                        ),
                      );
                    }
                    var snapshot = asyncSnapshot.data;
                    if (snapshot == null) {
                      return createBody();
                    }

                    Product.categories.clear();
                    snapshot.docs.forEach((doc) {
                      var value = doc.data();
                      Category category = Category.fromMap(
                        value,
                      );
                      if (category.products.isNotEmpty) {
                        Product.categories.add(category);
                      }
                    });

                    //
                    Product.categories.sort((a, b) {
                      return a.index > b.index ? 1 : -1;
                    });

                    Product.sortCategories();
                    return createBody();
                  }),
            ),
          ),

          ///

          StreamBuilder(
            stream: CustomStream.instance.stream,
            builder: (context, _) {
              if (controller.status != AnimationStatus.completed && showLogo) {
                return Positioned.fill(
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        color: primary,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: screenWidth > 400 ? 16 : 0,
                            ),
                            child: Image.asset(
                              'assets/images/logo_t.png',
                              height: kToolbarHeight,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                width: 0,
                height: 0,
              );
            },
          ),
          //
          //
        ],
      ),
    );
  }

  Future<void> addProductInCategory(String cat) async {
    if (Product.categories.map((e) => e.name).contains(cat) == false) {
      return;
    }

    Product? p = await showDialog(
      context: context,
      builder: (_) {
        return ItemDialog(
          Product.fromMap({})..category = cat,
          editMode: true,
        );
      },
    );
    if (p == null) {
      await FireStoreAgent.saveAll();

      setState(() {});
      return;
    }
    // loading

    setState(() {});
  }

  Future<void> addCategory(BuildContext context) async {
    String cat = '';
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'הכנס שם הקטיגוריה:',
            locale: Locale('he'),
          ),
          content: TextField(
            autofocus: true,
            onChanged: (v) {
              cat = v.trim();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (cat.length < 1) {
                  return;
                }
                if (Product.categories.map((e) => e.name).contains(cat)) {
                  return;
                }
                Product.addCategory(
                  cat,
                );

                Navigator.of(context).pop();

                addProductInCategory(cat);
              },
              child: Text('שמור'),
            )
          ],
        );
      },
    );
  }

  /////
  ///
  ///

  Widget createTitle(String title, {bool admin = true}) {
    String new_title = title;
    return Padding(
      padding: const EdgeInsets.all(20.0).copyWith(top: 10, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: isAdmin && admin
                ? SizedBox(
                    child: TextField(
                      controller: TextEditingController(text: title),
                      onChanged: (v) {
                        new_title = v.trim();
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        color: secondary,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: 1 == 1
                            ? InkResponse(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onLongPress: () async {
                                  for (var c in Product.categories) {
                                    if (c.name == title) {
                                      await FireStoreAgent.removeCategory(c);
                                      break;
                                    }
                                  }
                                },
                                onDoubleTap: () async {
                                  for (var c in Product.categories) {
                                    if (c.name == title) {
                                      await FireStoreAgent.removeCategory(c);
                                      break;
                                    }
                                  }
                                },
                              )
                            : SizedBox(
                                width: 2,
                              ),
                        suffix: IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {
                            if (new_title.isEmpty) {
                              return;
                            }
                            if (new_title == title) {
                              return;
                            }

                            for (var c in Product.categories) {
                              if (c.name == title) {
                                c.name = new_title;

                                for (var p in c.products) {
                                  p.category = new_title;
                                }
                                break;
                              }
                            }

                            showLoadingDialog(
                              context: context,
                              f1: FireStoreAgent.saveAll,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Text(
                    title,
                    locale: Locale('he'),
                    style: TextStyle(
                      fontSize: 26,
                      color: secondary,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ThinEdgeDivider(
              color: secondary,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }

  ///

  Widget categoryItemBuilder(
    BuildContext context,
    int index, {
    bool admin = true,
    bool useKey = true,
  }) {
    Category category = Product.categories[index];

    return ListTile(
      tileColor: Colors.transparent,
      trailing: isAdmin && false
          ? Container(
              child: SizedBox(width: 4),
            )
          : null,
      key: useKey
          ? Key(
              '${category.name} - ${category.index}category ${Random().nextInt(1000)}',
            )
          : null,
      title: Card(
        margin: EdgeInsets.symmetric(horizontal: screenWidth > 400 ? 12.0 : 4)
            .copyWith(
          bottom: index == Product.categories.length - 1 ? 30 : 0,
        ),
        clipBehavior: Clip.hardEdge,
        surfaceTintColor: Colors.transparent,
        color: white,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.5, 0),
              end: FractionalOffset(0.5, 1),
              stops: [0.023152, 0.46, 1],
              colors: [
                Color.fromRGBO(238, 221, 239, 1),

                ///
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(243, 241, 241, 1),
              ],
            ),
          ),
          child: 1 == 1
              ? Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        createTitle(
                          category.name,
                          admin: admin,
                        ),
                        Center(
                          child: isAdmin
                              ? ReorderableListView.builder(
                                  shrinkWrap: true,
                                  header: Container(),
                                  footer: isAdmin
                                      ? Center(
                                          child: InkResponse(
                                            onTap: () async {
                                              Product? p =
                                                  await showDialog<Product>(
                                                context: context,
                                                builder: (_) {
                                                  return ItemDialog(
                                                    Product.fromMap({})
                                                      ..category =
                                                          category.name,
                                                    editMode: true,
                                                  );
                                                },
                                              ).then((value) {
                                                setState(() {});
                                                return value;
                                              });

                                              if (p == null) {
                                                await FireStoreAgent.saveAll();

                                                setState(() {});
                                                return;
                                              }

                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.add,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      : null,
                                  dragStartBehavior: DragStartBehavior.down,
                                  buildDefaultDragHandles: true,
                                  itemBuilder: (context, index) {
                                    return productItemBuilder(
                                        context,
                                        index % category.products.length,
                                        category);
                                  },
                                  itemCount: category.products.length,
                                  onReorder: (oldIndex, newIndex) {
                                    newIndex = min(
                                        newIndex, category.products.length - 1);

                                    Product p1 = category.products[oldIndex];
                                    category.products.removeAt(oldIndex);
                                    category.products.insert(newIndex, p1);

                                    showLoadingDialog(
                                      context: context,
                                      f1: FireStoreAgent.saveAll,
                                    );
                                  },
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  //buildDefaultDragHandles: false,
                                  itemBuilder: (context, index) {
                                    return productItemBuilder(
                                        context,
                                        index % category.products.length,
                                        category);
                                  },
                                  itemCount: category.products.length * 1,
                                ),
                        ),
                      ],
                    ),

                    ///
                    if (isAdmin)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  insetPadding: EdgeInsets.zero,
                                  contentPadding: EdgeInsets.zero,
                                  title: createTitle(
                                    category.name,
                                  ),
                                  content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: ReorderableListView.builder(
                                      shrinkWrap: true,
                                      header: Container(),
                                      dragStartBehavior: DragStartBehavior.down,
                                      buildDefaultDragHandles: true,
                                      itemBuilder: (context, index) {
                                        return productItemBuilder(
                                            context,
                                            index % category.products.length,
                                            category);
                                      },
                                      itemCount: category.products.length,
                                      onReorder: (oldIndex, newIndex) {
                                        newIndex = min(newIndex,
                                            category.products.length - 1);

                                        Product p1 =
                                            category.products[oldIndex];
                                        category.products.removeAt(oldIndex);
                                        category.products.insert(newIndex, p1);

                                        showLoadingDialog(
                                          context: context,
                                          f1: FireStoreAgent.saveAll,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    createTitle(
                      category.name, // + " - " + category.index.toString(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(screenWidth > 400 ? 8.0 : 2),
                      child: isAdmin
                          ? ReorderableListView.builder(
                              shrinkWrap: true,
                              header: Container(),
                              buildDefaultDragHandles: true,
                              itemBuilder: (context, index) {
                                return productItemBuilder(context,
                                    index % category.products.length, category);
                              },
                              itemCount: category.products.length,
                              onReorder: (oldIndex, newIndex) {
                                newIndex =
                                    min(newIndex, category.products.length - 1);

                                Product p1 = category.products[oldIndex];
                                category.products.removeAt(oldIndex);
                                category.products.insert(newIndex, p1);

                                showLoadingDialog(
                                  context: context,
                                  f1: FireStoreAgent.saveAll,
                                );
                              },
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                category.products.length,
                                (index) => productItemBuilder(
                                  context,
                                  index % category.products.length,
                                  category,
                                ),
                              ),
                            ),
                    ),
                    //
                    if (isAdmin)
                      Center(
                        child: InkResponse(
                          onTap: () async {
                            Product? p = await showDialog<Product>(
                              context: context,
                              builder: (_) {
                                return ItemDialog(
                                  Product.fromMap({})..category = category.name,
                                  editMode: true,
                                );
                              },
                            ).then((value) {
                              setState(() {});
                              return value;
                            });

                            if (p == null) {
                              await FireStoreAgent.saveAll();

                              setState(() {});
                              return;
                            }

                            setState(() {});
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                      ),

                    //

                    //
                    SizedBox(
                      height: 12,
                    )
                    //
                  ],
                ),
        ),
      ),
    );
  }

  Widget productItemBuilder(
      BuildContext context, int index, Category category) {
    var item = category.products[index].toMap();

    return ListTile(
      key: Key(
        '$index-${category.products[index].id} - ${category} - ${Random().nextInt(100000)}',
      ),
      contentPadding:
          EdgeInsets.symmetric(horizontal: screenWidth < 350 ? 6 : 16),
      tileColor: Colors.transparent,
      splashColor: Colors.transparent,
      selectedTileColor: const Color.fromARGB(0, 92, 64, 64),
      title: Center(
        child: Card3(
          Product.fromMap(
            Map.from(item),
          ),
          isAdmin: isAdmin,
        ),
      ),
      //

      trailing: isAdmin && false
          ? SizedBox(
              width: 4,
            )
          : null,
    );
  }
}

class ThinEdgeDivider extends StatelessWidget {
  final Color color;
  final double height;

  ThinEdgeDivider({required this.color, this.height = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0), color, color.withOpacity(0)],
          stops: [0, 0.5, 1],
        ),
      ),
    );
  }
}
