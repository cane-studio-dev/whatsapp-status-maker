import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ويدجت يضيف إطار "Ring Light" متحرك يلف حول أي محتوى (child)
/// الفكرة: نرسم إطار مستطيل بحواف دائرية باستخدام CustomPainter،
/// ونلوّنه بتدرج دائري (SweepGradient) يدور باستمرار عبر AnimationController.
class RingLightBorder extends StatefulWidget {
  final Widget child;
  final double borderWidth;
  final double borderRadius;
  final List<Color> colors;
  final Duration duration;

  const RingLightBorder({
    super.key,
    required this.child,
    this.borderWidth = 6,
    this.borderRadius = 28,
    this.colors = const [
      Color(0xFF25D366), // أخضر واتساب
      Color(0xFF00C6FF),
      Color(0xFFFF6EC7),
      Color(0xFFFFD93D),
      Color(0xFF25D366),
    ],
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<RingLightBorder> createState() => _RingLightBorderState();
}

class _RingLightBorderState extends State<RingLightBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(); // دوران لا نهائي
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
      builder: (context, child) {
        return CustomPaint(
          painter: _RingLightPainter(
            progress: _controller.value,
            colors: widget.colors,
            strokeWidth: widget.borderWidth,
            radius: widget.borderRadius,
          ),
          child: Padding(
            // مسافة داخلية حتى لا يغطي الإطار المحتوى
            padding: EdgeInsets.all(widget.borderWidth + 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius - widget.borderWidth),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class _RingLightPainter extends CustomPainter {
  final double progress; // من 0.0 إلى 1.0 يتكرر باستمرار
  final List<Color> colors;
  final double strokeWidth;
  final double radius;

  _RingLightPainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // تدرج دائري (SweepGradient) يدور مع الوقت عن طريق تدوير زاوية البداية
    final angle = 2 * math.pi * progress;

    final gradient = SweepGradient(
      colors: colors,
      transform: GradientRotation(angle),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(rrect, paint);

    // طبقة توهج إضافية (Glow) خلف الإطار لإحساس "الإضاءة" الملموس
    final glowPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..color = Colors.white.withOpacity(0.35);

    canvas.drawRRect(rrect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _RingLightPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
