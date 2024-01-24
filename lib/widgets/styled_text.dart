// done

import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  String title;
  double fontSize;
  FontWeight fontWeight;
  Color color;
  TextOverflow? overflow;
  int? maxLines;
  TextDecoration? decoration;
  TextAlign textAlign;
  double? height;
  StyledText(
    this.title, {
    this.decoration,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.color = Colors.black,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.right,
    this.maxLines = 10,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      // GoogleFonts.lemonada(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    ).copyWith(overflow: overflow);

    return DefaultTextStyle(
      style: style,
      child: Text(
        title,
        locale: Locale('he'),
        softWrap: false,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}
