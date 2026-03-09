import 'package:flutter/material.dart';

/// A pro-level centralised text widget with pre-built typographic styles,
/// flexible property overrides, and interactive features.
class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextScaler? textScaler;
  final TextDirection? textDirection;
  final Locale? locale;
  final String? semanticsLabel;

  // Individual Style Overrides
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;

  // Interactivity
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TextWidget(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textScaler,
    this.textDirection,
    this.locale,
    this.semanticsLabel,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.fontFamily,
    this.fontFamilyFallback,
    this.onTap,
    this.onLongPress,
  });

  // ── Helpers for Factories ──────────────────────────────────────────────────

  static TextWidget _create(
    String text, {
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    Color? defaultColor,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    TextDecoration? decoration,
    VoidCallback? onTap,
    FontWeight? overrideFontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) => TextWidget(
    text,
    fontSize: fontSize,
    fontWeight: overrideFontWeight ?? fontWeight,
    color: color ?? defaultColor,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    decoration: decoration,
    onTap: onTap,
    fontStyle: fontStyle,
    letterSpacing: letterSpacing,
  );

  // ── Pro Typography Scale ───────────────────────────────────────────────────

  /// 22 sp · w900 — Hero / Display Titles
  factory TextWidget.displayBold(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.white,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 18 sp · w900 — Main Section Headlines
  factory TextWidget.headlineLarge(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 18,
    fontWeight: FontWeight.w900,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.black87,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 16 sp · w900 — Mid-sized Headlines
  factory TextWidget.headlineMedium(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 16,
    fontWeight: FontWeight.w900,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.black87,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 15 sp · w900 — Small Headlines
  factory TextWidget.headlineSmall(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 15,
    fontWeight: FontWeight.w900,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.black87,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 14 sp · bold — Sub-headings / Large Tab Labels
  factory TextWidget.titleLarge(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.black87,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 13 sp · bold — Prices, Strong Emphasis, Buttons
  factory TextWidget.titleMedium(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 13,
    fontWeight: FontWeight.bold,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.black87,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 12 sp · bold — Compact Information Labels
  factory TextWidget.titleSmall(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.black87,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 14 sp · normal — Primary Body Text
  factory TextWidget.body(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    FontWeight? fontWeight,
    VoidCallback? onTap,
  }) => _create(
    text,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.black87,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 11 sp · normal — Secondary / Supporting Copy
  factory TextWidget.bodySmall(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    FontWeight? fontWeight,
    VoidCallback? onTap,
  }) => _create(
    text,
    fontSize: 11,
    fontWeight: FontWeight.normal,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.black87,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    onTap: onTap,
  );

  /// 10 sp · normal — Captions, Ratings, Metadata
  factory TextWidget.caption(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    int? maxLines,
    TextOverflow? overflow,
    TextDecoration? decoration,
    FontWeight? fontWeight,
    VoidCallback? onTap,
  }) => _create(
    text,
    fontSize: 10,
    fontWeight: FontWeight.normal,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.grey,
    textAlign: textAlign,
    height: height,
    maxLines: maxLines,
    overflow: overflow,
    decoration: decoration,
    onTap: onTap,
  );

  /// 9 sp · bold — Micro Labels / Internal Badges
  factory TextWidget.badge(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 9,
    fontWeight: FontWeight.bold,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.white,
    textAlign: textAlign,
    height: height,
    onTap: onTap,
  );

  /// 8 sp · bold — Extra-Small Tags (Free Shipping, Coins)
  factory TextWidget.badgeXS(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? height,
    VoidCallback? onTap,
    FontWeight? fontWeight,
  }) => _create(
    text,
    fontSize: 8,
    fontWeight: FontWeight.bold,
    overrideFontWeight: fontWeight,
    color: color,
    defaultColor: Colors.white,
    textAlign: textAlign,
    height: height,
    onTap: onTap,
  );

  @override
  Widget build(BuildContext context) {
    final TextStyle effectiveStyle = (style ?? const TextStyle()).copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
    );

    Widget textWidget = Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaler: textScaler,
      textDirection: textDirection,
      locale: locale,
      semanticsLabel: semanticsLabel,
    );

    if (onTap != null || onLongPress != null) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: textWidget,
      );
    }

    return textWidget;
  }
}
