import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LiquidGlassLensShader extends BaseShader {
  LiquidGlassLensShader._(String path) : super(shaderAssetPath: path);

  factory LiquidGlassLensShader.circle() {
    return LiquidGlassLensShader._('shaders/liquid_glass_lens_circle.frag');
  }

  factory LiquidGlassLensShader.rectangle() {
    return LiquidGlassLensShader._('shaders/liquid_glass_lens_rectangle.frag');
  }

  @override
  void updateShaderUniforms({required double width, required double height, required ui.Image? backgroundImage}) {
    if (!isLoaded) return;

    // Set resolution (indices 0-1)
    shader.setFloat(0, width);
    shader.setFloat(1, height);

    // Set mouse position (indices 2-3)
    shader.setFloat(2, width / 2);
    shader.setFloat(3, height / 2);

    // Set effect size (index 4)
    shader.setFloat(4, 5.0);

    // Set blur intensity (index 5)
    shader.setFloat(5, 0);

    // Set dispersion strength (index 6)
    shader.setFloat(6, 0.4);

    // Set background texture (sampler index 0)
    if (backgroundImage != null && backgroundImage.width > 0 && backgroundImage.height > 0) {
      try {
        shader.setImageSampler(0, backgroundImage);
      } catch (e) {
        debugPrint('Error setting background texture: $e');
      }
    }
  }
}

class BaseShader {
  BaseShader({required this.shaderAssetPath});

  final String shaderAssetPath;

  late ui.FragmentProgram _program;
  late ui.FragmentShader _shader;

  bool _isLoaded = false;

  ui.FragmentShader get shader => _shader;
  bool get isLoaded => _isLoaded;

  Future<void> initialize() async {
    await _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      _program = await ui.FragmentProgram.fromAsset(shaderAssetPath);
      _shader = _program.fragmentShader();
      _isLoaded = true;
    } catch (e) {
      log('Error loading shader: $e');
    }
  }

  void updateShaderUniforms({required double width, required double height, required ui.Image? backgroundImage}) {
    throw UnimplementedError();
  }
}

/// Custom painter that renders the liquid glass effect on the captured background
class ShaderPainter extends CustomPainter {
  ShaderPainter(this.shader);

  final ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    try {
      if (size.width <= 0 || size.height <= 0) {
        return;
      }

      final paint = Paint()..shader = shader;
      canvas.drawRect(Offset.zero & size, paint);
    } catch (e) {
      final paint = Paint()..color = Colors.transparent;
      canvas.drawRect(Offset.zero & size, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
