import 'package:flutter/material.dart';

import '../constants/assets.dart';

class EasyText extends StatelessWidget {
  const EasyText({
    super.key,
    required this.text,
    this.fontColor = Colors.black,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w400,
    this.fontFamily,
    this.overflow,
    this.textAlign = TextAlign.left,
    this.textDecoration = TextDecoration.none,
    this.maxLine,
  });

  final String text;
  final double fontSize;
  final Color fontColor;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;
  final String? fontFamily;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLine;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
        decoration: textDecoration,
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? poppin,
      ),
    );
  }
}
