import 'package:food_menu/backend/product/product.dart';
import 'package:food_menu/backend/product/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

String generateRandomString(int length) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}

abstract class FireStoreAgent {
  static var ref = FirebaseFirestore.instance.collection('categories');
  static DocumentReference<Map<String, dynamic>> ref_2 =
      FirebaseFirestore.instance.collection('products_2').doc('data');

  static Future<void> init() async {
    //initStream();
  }

  static Future<void> initStream() async {
    await FirebaseFirestore.instance
        .collection('products_2')
        .doc('data')
        .get()
        .then((snapshot) {
      Product.categories.clear();

      (snapshot.data() ?? {}).forEach((key, value) {
        String cat = key;
        if (cat.isEmpty) {
          return;
        }
        Category category = Category.fromMap(
          value,
        );
        Product.categories.add(category);
      });
      //
      Product.sortCategories();
      //
    });
  }

  static Future<bool> save(Product product) async {
    return true;
  }

  static Future<bool> removeCategory(Category category) async {
    if (category.id.isEmpty) {
      return true;
    }
    bool res = false;
    try {
      await ref.doc(category.id).delete().then((value) {
        res = true;
      });
    } catch (_) {}
    return res;
  }

  static Future<bool> saveAll() async {
    // await Future.delayed(Duration(seconds: 1));

    bool res = false;
    Map<String, dynamic> data = {};
    for (Category cate in Product.categories) {
      for (var p in cate.products) {
        if (p.id.isEmpty) {
          Set<String> ids = Product.products.map((e) => e.id).toSet();

          int i = 0;
          while (p.id.isEmpty || ids.contains(p.id)) {
            p.id = generateRandomString(20 + i ~/ 4);
            i += 1;
          }
        }
      }
    }
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (Category category in Product.categories) {
      // Get a reference to the document with the ID as category's name
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(category.id.isEmpty ? null : category.id);
      category.id = docRef.id;

      // Write the category data to the batch
      batch.set(docRef, category.toMap());
    }
    batch.commit();

    for (var category in Product.categories) {
      break;
      data[category.name] = category.toMap();
      if (category.name.isEmpty) {
        continue;
      }
      await ref
          .doc(category.name)
          .set(category.toMap())
          .then((value) => res = true)
          .onError((error, stackTrace) {
        print('fb - err: $error');
        return false;
      });
      continue;
    }
    return res;
  }

  //////
  ///
  ///
  ///
  ///

  static Future<bool> saveAll__() async {
    //await Future.delayed(Duration(seconds: 1));

    bool res = false;
    Map<String, dynamic> data = {};
    for (Category cate in Product.categories) {
      for (var p in cate.products) {
        if (p.id.isEmpty) {
          Set<String> ids = Product.products.map((e) => e.id).toSet();

          int i = 0;
          while (p.id.isEmpty || ids.contains(p.id)) {
            p.id = generateRandomString(20 + i ~/ 4);
            i += 1;
          }
        }
      }
    }

    for (var category in Product.categories) {
      data[category.name] = category.toMap();
    }

    await ref_2
        .set(data)
        .then((value) => res = true)
        .onError((error, stackTrace) {
      print('fb - err: $error');
      return false;
    });
    return res;
  }

  static Future<bool> _saveAll() async {
    await Future.delayed(Duration(seconds: 1));
    bool res = false;
    Map<String, List> data = {};
    Product.products.map((e) => e.category).toSet().forEach((cat) {
      if (data[cat] == null) {
        data[cat] = [];
      }
      Product.products.where((p) => p.category == cat).forEach((p) {
        if (p.id.isEmpty) {
          Set<String> ids = Product.products.map((e) => e.id).toSet();

          ///
          // check

          int i = 0;
          while (p.id.isEmpty || ids.contains(p.id)) {
            p.id = generateRandomString(20 + i ~/ 4);
            i += 1;
          }
        }

        data[cat]?.add(p.toMap());
      });
    });
    await ref_2
        .set(data)
        .then((value) => res = true)
        .onError((error, stackTrace) {
      print('fb - err: $error');
      return false;
    });
    return res;
  }
}
