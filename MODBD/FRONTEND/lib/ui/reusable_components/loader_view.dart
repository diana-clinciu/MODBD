import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:mvvm_flutter/internal_models/app_colors.dart';

class LoaderView extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Gradient gradient;
  final Duration duration;

  const LoaderView({
    Key? key,
    this.size = 24.0,
    this.strokeWidth = 3.0,
    Gradient? gradient,
    this.duration = const Duration(milliseconds: 1200),
  })  : gradient = gradient ??
            const LinearGradient(colors: [
              AppColors.reddishBrownColor,
              AppColors.lightCaramelColor,
              AppColors.creamColor,
            ]),
        super(key: key);

  @override
  State<LoaderView> createState() => _GradientLoaderState();
}

class _GradientLoaderState extends State<LoaderView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: GradientLoaderPainter(
                strokeWidth: widget.strokeWidth,
                colors: widget.gradient.colors,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GradientLoaderPainter extends CustomPainter {
  final double strokeWidth;
  final List<Color> colors;

  GradientLoaderPainter({
    required this.strokeWidth,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Create gradient shader
    final gradient = SweepGradient(
      colors: colors,
      stops: const [0.0, 0.7, 1.0],
      startAngle: 0,
      endAngle: 2 * math.pi,
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);

    // Draw the arc (partial circle)
    canvas.drawArc(
      rect,
      -math.pi / 2, // Start from top
      1.5 * math.pi, // Draw 3/4 of the circle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
