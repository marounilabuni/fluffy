// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food_menu/constants.dart';

class CustomFancyCard extends StatelessWidget {
  const CustomFancyCard({
    Key? key,
    required this.title,
    required this.image,
    this.subtitle,
    this.locationIcon,
    this.rateIcon,
    this.trailingIcon,
    this.trailing,
    this.ratingText,
    this.locationText,
    this.onTap,
    this.bgColor,
  }) : super(key: key);
  final Color? bgColor;
  final String title;
  final String? subtitle;
  final Widget? locationIcon;
  final Widget? rateIcon;
  final String? ratingText;
  final String? locationText;
  final Widget? trailingIcon;
  final Widget? trailing;
  final Widget image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    // get screenWidth
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: screenWidth > 400 ? 12 : 4),
      height: MediaQuery.of(context).size.height * 0.1 + 20,
      decoration: BoxDecoration(
          color: bgColor ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Material(
              color: bgColor ?? Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (screenWidth > 4 * 330)
                          Expanded(
                            flex: screenWidth > 380 ? 18 : 22,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.all(8)
                                      .copyWith(right: 2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth < 340 ? 1000 : 12.0),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: image,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          flex: screenWidth < 330 ? 30 + 12 : 50 - 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12, left: 8),
                                child: Text(
                                  title,
                                  locale: Locale('he'),
                                  style: TextStyle(
                                      locale: Locale('he'),
                                      fontSize: 16 - 0.5,
                                      fontWeight: FontWeight.bold,
                                      color: primary,
                                      shadows: [
                                        BoxShadow(
                                            color: Colors.amber,
                                            blurRadius: 2,
                                            spreadRadius: 20)
                                      ]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 8 / 2 / 2 / 2, left: 8),
                                child: Text(
                                  subtitle ?? "",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w300),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (false)
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, top: 8),
                                      child: locationIcon,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 3, top: 8),
                                      child: Text(
                                        locationText ?? "",
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 8, top: 8),
                                      child: rateIcon,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 3, top: 8),
                                      child: Text(
                                        ratingText ?? "",
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: trailingIcon ?? const SizedBox(),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 10,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
