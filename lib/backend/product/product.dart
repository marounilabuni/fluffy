// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:food_menu/constants.dart';

import '../../backend/product/image/product_image.dart';
import '../../backend/product/options/product_option.dart';

import 'category.dart';

class Product {
  static List<Product> get products {
    List<Product> list = [];
    categories.forEach((c) {
      list.addAll(c.products);
    });
    return list;
  }

  static List<Category> categories = [];

  static Category addCategory(String cat) {
    var c = Category(name: cat, index: categories.length);
    categories.add(
      c,
    );
    sortCategories();
    return c;
  }

  static void sortCategories() {
    categories.sort((a, b) {
      return a.index > b.index ? 1 : -1;
    });
    for (int i = 0; i < categories.length; i++) {
      categories[i].index = i;
    }
  }

  static Map<String, Product> get productsMap {
    Map<String, Product> res = {};

    for (var p in products) {
      res[p.id] = p;
    }
    return res;
  }

  String id;
  String title;
  String category;
  String description;
  num price;
  double rating;
  int ratingCounter;
  List<ProductOption> options;
  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.ratingCounter,
    required this.options,
    required this.image,
    this.description = '',
  });
  ProductImage image;

  ///
  ///

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'price': price,
      'rating': rating,
      'ratingCounter': ratingCounter,
      'options': options.map((x) => x.toMap()).toList(),
      'image': image.toMap(),
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    if (map['price'].toString().contains(ils)) {
      map['price'] = map['price'].toString().replaceAll(' ', '');
      map['price'] = map['price'].toString().replaceAll(ils, '');
      map['price'] = num.tryParse(map['price']) ?? 0;
    }

    return Product(
      description: map['description'] ?? "",
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      category: map['category'] ?? "",
      price: (map['price'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      ratingCounter: (map['ratingCounter'] ?? 0) as int,
      options: List<ProductOption>.from(
        ((map['options'] ?? []))
            .map<ProductOption>(
              (x) => ProductOption.fromMap(x as Map<String, dynamic>),
            )
            .toList(),
      ),
      image: ProductImage.fromMap(map['image'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, title: $title, category: $category, price: $price, rating: $rating, ratingCounter: $ratingCounter, options: $options)';
  }

  ////
  ///
  String get imageTag => "imgTag: ${id}, name: ${title}";

  ///\
  ///

  String get smallImageUrlGetter {
    return 'https://firebasestorage.googleapis.com/v0/b/fluffy-8f098.appspot.com/o/images%2Fs${id}.png?alt=media';
  }

  String get largeImageUrlGetter {
    return 'https://firebasestorage.googleapis.com/v0/b/fluffy-8f098.appspot.com/o/images%2Fl${id}.png?alt=media';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
