// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductImage {
  String smallImageUrl;
  String largeImageUrl;
  List<String> images;

  String imageUrl(bool useLarge) {
    return useLarge ? largeImageUrl : smallImageUrl;
  }

  ProductImage({
    this.images = const [],
    required this.smallImageUrl,
    required this.largeImageUrl,
  });

  ProductImage copyWith({
    String? smallImageUrl,
    String? largeImageUrl,
  }) {
    return ProductImage(
      smallImageUrl: smallImageUrl ?? this.smallImageUrl,
      largeImageUrl: largeImageUrl ?? this.largeImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'images': images,
      'smallImageUrl': smallImageUrl,
      'largeImageUrl': largeImageUrl,
    };
  }

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      images: ((map['images'] ?? []) as List).map<String>((e) => e.toString()).toList(),
      smallImageUrl: map['smallImageUrl'] ?? "",
      largeImageUrl: map['largeImageUrl'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductImage.fromJson(String source) =>
      ProductImage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProductImage(smallImageUrl: $smallImageUrl, largeImageUrl: $largeImageUrl)';

  @override
  bool operator ==(covariant ProductImage other) {
    if (identical(this, other)) return true;

    return other.smallImageUrl == smallImageUrl &&
        other.largeImageUrl == largeImageUrl;
  }

  @override
  int get hashCode => smallImageUrl.hashCode ^ largeImageUrl.hashCode;
}
