import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whispr_app/core/theme/color/app_pallete.dart';

// ignore: must_be_immutable
class CommonText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Color decorationColor;
  final TextDecoration textDecoration;
  final int maxLine;
  final String fonts;
  List<TextSpan>? children;
  CommonText({
    super.key,
    required this.text,
    this.color = AppPallete.whiteColor,
    this.fontSize = 14,
    this.maxLine = 10,
    this.decorationColor = AppPallete.whiteColor,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.w400,
    this.fonts = "Montserrat",
    this.children,
    this.textDecoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: GoogleFonts.montserrat(
          wordSpacing: 1,
          letterSpacing: 0.5,
          decoration: textDecoration,
          fontSize: fontSize + 0.00.sh,
          color: color,
          fontWeight: fontWeight,
          decorationColor: decorationColor,
        ),
        children: children,
      ),
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
    );
  }
}
