import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

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

    double threshold = 360;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: MediaQuery.of(context).size.height * 0.1 + 20 + 0 +0 + 10,
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
                child: Row(
                  children: [
                    if (screenWidth > 340)
                      Expanded(
                        flex: 30,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: image,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      flex: screenWidth < threshold ? 30 + 12 : 50 + 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 12, left: 8),
                            child: Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 16 - 0.5,
                                  fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8 / 2 , left: 8),
                            child: Text(
                              subtitle ?? "",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w400),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (false)
                            Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, top: 8),
                                  child: locationIcon,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 3, top: 8),
                                  child: Text(
                                    locationText ?? "",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, top: 8),
                                  child: rateIcon,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 3, top: 8),
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
                      flex: screenWidth < threshold ? 14 : 16,
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
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: trailingIcon ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
