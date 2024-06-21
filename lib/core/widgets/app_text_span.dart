import 'package:flutter/widgets.dart';

class AppTextSpan extends StatelessWidget {
  final InlineSpan textSpan;
  final TextOverflow? textOverflow;
  final double maxRealFontSize;

  const AppTextSpan({
    required this.textSpan,
    super.key,
    this.textOverflow,
    this.maxRealFontSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    // Get the text scale factor
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    // Function to adjust the font size within a TextSpan
    InlineSpan adjustFontSize(InlineSpan span) {
      if (span is TextSpan) {
        final adjustedStyle = span.style?.copyWith(
          fontSize: (span.style?.fontSize ?? 14) * textScale > maxRealFontSize
              ? maxRealFontSize / textScale
              : span.style?.fontSize,
        );
        return TextSpan(
          text: span.text,
          style: adjustedStyle,
          children: span.children?.map(adjustFontSize).toList(),
        );
      }
      return span;
    }

    final adjustedTextSpan = adjustFontSize(textSpan);

    return Text.rich(
      adjustedTextSpan,
      overflow: textOverflow ?? TextOverflow.visible,
    );
  }
}
