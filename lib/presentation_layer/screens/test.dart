import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularProgressCircle extends StatelessWidget {
  final double percentage;

  CircularProgressCircle({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200), // Size of the circle
      painter: CirclePainter(percentage: percentage),
      child: Center(
        child: Text(
          '${percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double percentage;

  CirclePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    // Circle background
    Paint circleBackgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, circleBackgroundPaint);

    // Circle progress
    Paint circleProgressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    double angle = (percentage / 100) * 2 * 3.141592653589793; // Calculate the angle

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -3.141592653589793 / 2, // Start angle (top)
      angle, // Sweep angle
      false, // Use center
      circleProgressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Repaint when percentage changes
  }
}