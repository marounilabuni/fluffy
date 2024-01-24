// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_menu/constants.dart';

class ProductOption {
  String title;
  bool required;
  List<ProductOptionItem> options = [];

  bool multichoice;
  ProductOption({
    required this.title,
    required this.options,
    required this.multichoice,
    this.required = false,
  });

  ProductOption copyWith({
    String? title,
    List<ProductOptionItem>? options,
    bool? multichoice,
  }) {
    return ProductOption(
      title: title ?? this.title,
      options: options ?? this.options,
      multichoice: multichoice ?? this.multichoice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'options': options.map((x) => x.toMap()).toList(),
      'multichoice': multichoice,
    };
  }

  factory ProductOption.fromMap(Map<String, dynamic> map) {
    return ProductOption(
      title: map['title'],
      options: List<ProductOptionItem>.from(
          (map['options'] ?? [])?.map((x) => ProductOptionItem.fromMap(x))),
      multichoice: map['multichoice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOption.fromJson(String source) =>
      ProductOption.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProductOption(title: $title, options: $options, multichoice: $multichoice)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductOption &&
        other.title == title &&
        listEquals(other.options, options) &&
        other.multichoice == multichoice;
  }

  @override
  int get hashCode => title.hashCode ^ options.hashCode ^ multichoice.hashCode;

  //
  List<num> get prices => options.map((e) => e.price).toList();

  //
}

class ProductOptionItem {
  String name;
  num price;

  ProductOptionItem({
    this.name = '',
    this.price = 0,
  });

  ProductOptionItem copyWith({
    String? name,
    num? price,
  }) {
    return ProductOptionItem(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  factory ProductOptionItem.fromMap(Map<String, dynamic> map) {
    return ProductOptionItem(
      name: map['name'],
      price: map['price'],
    );
  }
  String toJson() => json.encode(toMap() );
  factory ProductOptionItem.fromJson(String source) =>
      ProductOptionItem.fromMap(json.decode(source));
  @override
  String toString() => '$name : $price $ils';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductOptionItem &&
        other.name == name &&
        other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}
