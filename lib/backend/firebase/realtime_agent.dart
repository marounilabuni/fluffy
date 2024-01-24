import 'package:food_menu/backend/product/product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class RealTimeAgent {
  static var ref = FirebaseDatabase.instance.ref('products');

  static Future<void> init() async {
    initStream();
  }
  static Future<void> initStream() async {
    ref.onChildChanged.listen((event) {
      
      if(event.snapshot.exists == false)
      {
        return;
      }
      Product.products.clear();
      for(var child in event.snapshot.children){
        String cat = (child.key??"").toString();
        if(cat.isEmpty){
          continue;
        }
        Product product = Product.fromMap(
          Map.fromIterable(child.children),
        );
        Product.products.add(product);
      }
    });
  }
  static Future<bool> saveAll() async {
    bool res = false;
    Map<String, List> data = {};
    Product.products.map((e) => e.category).toSet().forEach((cat) {
      if (data[cat] == null) {
        data[cat] = [];
      }
      Product.products.where((p) => p.category == cat).forEach((p) {
        data[cat]?.add(p.toMap());
      });
    });
    await ref.set(data).then((value) => res = false);
    return res;
  }
}
