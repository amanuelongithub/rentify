import 'package:flutter/material.dart';

class TextMinimizer extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? textStyle;
  final Color? buttonColor;
  final String showMoreText;
  final String showLessText;
  final double textSpacing;

  const TextMinimizer({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.textStyle,
    this.buttonColor,
    this.showMoreText = 'Show more',
    this.showLessText = 'Show less',
    this.textSpacing = 8.0,
  });

  @override
  State<TextMinimizer> createState() => _TextMinimizerState();
}

class _TextMinimizerState extends State<TextMinimizer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = widget.textStyle ?? theme.textTheme.bodyMedium;
    final buttonColor = widget.buttonColor ?? theme.primaryColor;

    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text, style: textStyle);

        final textPainter = TextPainter(text: span, maxLines: widget.maxLines, textDirection: TextDirection.ltr);

        textPainter.layout(maxWidth: size.maxWidth);
        final isTextLong = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Text(
                widget.text,
                style: textStyle,
                textAlign: TextAlign.justify,
                maxLines: _isExpanded ? null : widget.maxLines,
                overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
            if (isTextLong) SizedBox(height: widget.textSpacing),
            if (isTextLong)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? widget.showLessText : widget.showMoreText,
                      style: TextStyle(color: buttonColor, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: buttonColor, size: 16),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
