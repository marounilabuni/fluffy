import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'product.dart';

class Category {
  String id;
  String name;
  num index;
  List<Product> products = [];
  Category({
    this.id = '',
    this.name = '',
    this.index = 0,
    List<Product> products = const [],
  }) {
    this.products.addAll(products);
  }
  Category copyWith({
    String? name,
    int? index,
    List<Product>? products,
  }) {
    return Category(
      name: name ?? this.name,
      index: index ?? this.index,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'index': index,
      'products': List.generate(
        products.length,
        (index) => products[index].toMap(),
      ),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? "",
      name: map['name'],
      index: map['index'],
      products:
          List<Product>.from(map['products']?.map((x) => Product.fromMap(x))),
    );
  }
  String toJson() => json.encode(toMap());
  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
  @override
  String toString() =>
      'Category(name: $name, index: $index, products: $products)';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.name == name &&
        other.index == index &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode => name.hashCode ^ index.hashCode ^ products.hashCode;
}
