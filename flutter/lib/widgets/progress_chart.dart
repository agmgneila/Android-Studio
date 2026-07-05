import 'package:flutter/material.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key, required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Gráfico de progreso semanal',
      child: SizedBox(
        height: 190,
        width: double.infinity,
        child: CustomPaint(
          painter: _ProgressPainter(
            values,
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  _ProgressPainter(this.values, this.color, this.fillColor);

  final List<double> values;
  final Color color;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final step = size.width / (values.length - 1);
    final line = Path();
    final fill = Path()..moveTo(0, size.height);
    for (var i = 0; i < values.length; i++) {
      final point = Offset(i * step, size.height * (1 - values[i]));
      i == 0 ? line.moveTo(point.dx, point.dy) : line.lineTo(point.dx, point.dy);
      i == 0 ? fill.lineTo(point.dx, point.dy) : fill.lineTo(point.dx, point.dy);
      canvas.drawCircle(point, 5, Paint()..color = color);
    }
    fill
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = fillColor.withValues(alpha: .55));
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.color != color ||
      oldDelegate.fillColor != fillColor;
}

