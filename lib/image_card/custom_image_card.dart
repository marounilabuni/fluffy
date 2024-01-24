import 'package:flutter/material.dart';
import 'package:food_menu/constants.dart';
import 'package:image_card/src/image_card_content.dart';

class CustomFillImageCard extends StatelessWidget {
  const CustomFillImageCard({
    Key? key,
    this.width,
    this.height,
    this.heightImage,
    this.borderRadius = 6,
    this.contentPadding,
    required this.imageProvider,
    this.imageWidget,
    this.tags,
    this.title,
    this.description,
    this.footer,
    this.color = Colors.white,
    this.tagSpacing,
    this.tagRunSpacing,
  }) : super(key: key);

  /// card width
  final double? width;

  /// card height
  final double? height;

  /// image height
  final double? heightImage;

  /// border radius value
  final double borderRadius;

  /// spacing between tag
  final double? tagSpacing;

  /// run spacing between line tag
  final double? tagRunSpacing;

  /// content padding
  final EdgeInsetsGeometry? contentPadding;

  /// image provider
  final ImageProvider imageProvider;

  /// image provider
  final Widget? imageWidget;

  /// list of widgets
  final List<Widget>? tags;

  /// card color
  final Color color;

  /// widget title of card
  final Widget? title;

  /// widget description of card
  final Widget? description;

  /// widget footer of card
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              child: imageWidget ??
                  Image(
                    image: imageProvider,
                    errorBuilder: (context, error, stackTrace) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            primary.withOpacity(0.17),
                            BlendMode
                                .srcIn // This blend mode replaces white with `newColor`
                            ),
                        child: Image.asset(
                          'assets/images/logo_t.png',
                        ),
                      ),
                    ),
                    width: width,
                    height: heightImage,
                    fit: BoxFit.cover,
                  ),
            ),
          ),
          ImageCardContent(
            contentPadding: contentPadding,
            tags: tags,
            title: title,
            footer: footer,
            description: description,
            tagSpacing: tagSpacing,
            tagRunSpacing: tagRunSpacing,
          ),
        ],
      ),
    );
  }
}
