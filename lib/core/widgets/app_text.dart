import 'package:flutter/widgets.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextOverflow? textOverflow;
  final double maxRealFontSize;
  final double minFontSize;

  const AppText(
    this.text, {
    required this.style,
    super.key,
    this.textOverflow,
    this.maxRealFontSize = 35,
    this.minFontSize = 12, // Set a minimum font size to avoid too small text
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    // final screenHeight = mediaQuery.size.height;

    // Calculate the responsive font size based on screen width or height
    double baseFontSize = style.fontSize ?? 14; // Default font size
    double responsiveFontSize =
        baseFontSize * (screenWidth / 375); // 375 is the base screen width

    // Ensure the responsive font size is within the desired range
    responsiveFontSize = responsiveFontSize.clamp(minFontSize, maxRealFontSize);

    return Text(
      text,
      style: style.copyWith(
        fontSize: responsiveFontSize,
      ),
      overflow: textOverflow ?? TextOverflow.visible,
    );
  }
}
