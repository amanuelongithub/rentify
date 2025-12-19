import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassContainer extends StatefulWidget {
  final double width;
  final double height;
  final Widget? child;

  const LiquidGlassContainer({
    super.key,
    required this.width,
    required this.height,
    this.child,
  });

  @override
  _LiquidGlassContainerState createState() => _LiquidGlassContainerState();
}

class _LiquidGlassContainerState extends State<LiquidGlassContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _LiquidBorderPainter(progress: _controller.value),
          child: Container(
            width: widget.width,
            height: widget.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LiquidBorderPainter extends CustomPainter {
  final double progress;

  _LiquidBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    final waveHeight = 10.0;
    final waveLength = 40.0;

    // Top edge
    path.moveTo(0, 0);
    for (double x = 0; x <= size.width; x++) {
      double y = waveHeight * sin((2 * pi / waveLength) * x + progress * 2 * pi);
      path.lineTo(x, y);
    }

    // Right edge
    for (double y = 0; y <= size.height; y++) {
      double x = size.width + waveHeight * sin((2 * pi / waveLength) * y + progress * 2 * pi);
      path.lineTo(x, y);
    }

    // Bottom edge
    for (double x = size.width; x >= 0; x--) {
      double y = size.height + waveHeight * sin((2 * pi / waveLength) * x + progress * 2 * pi);
      path.lineTo(x, y);
    }

    // Left edge
    for (double y = size.height; y >= 0; y--) {
      double x = waveHeight * sin((2 * pi / waveLength) * y + progress * 2 * pi);
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidBorderPainter oldDelegate) => true;
}
