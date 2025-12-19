import 'package:flutter/material.dart';

class DotIndicator extends Decoration {
  final Color color;
  final double radius;

  const DotIndicator({required this.color, this.radius = 4});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(color: color, radius: radius);
  }
}

class _DotPainter extends BoxPainter {
  final Color color;
  final double radius;

  _DotPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final Paint paint = Paint()..color = color;

    final double x = offset.dx + config.size!.width / 2;
    final double y = offset.dy + config.size!.height - radius - 4;

    canvas.drawCircle(Offset(x, y), radius, paint);
  }
}
