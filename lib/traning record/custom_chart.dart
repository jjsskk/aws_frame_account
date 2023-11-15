import 'package:flutter/material.dart';
import 'dart:math';


class SpiderChartExample extends StatefulWidget {
  @override
  _SpiderChartExampleState createState() => _SpiderChartExampleState();
}

class _SpiderChartExampleState extends State<SpiderChartExample> with TickerProviderStateMixin {
  List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
  ];

  List<double> data = [3, 4, 2, 5, 4];
  List<double> newData = [4, 3, 5, 2, 3]; // Updated data for animation

  late AnimationController _animationController;
  late Animation<List<double>> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = ListDoubleTween(begin: data, end: newData).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpiderChart(
          categories: categories,
          data: _animation.value, // Use the animated value here
          maxValue: 5,
          chartRadius: 100,
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _startAnimation();
          },
          child: Text('Animate Chart'),
        ),
      ],
    );
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class SpiderChart extends StatelessWidget {
  final List<String> categories;
  final List<double> data;
  final double maxValue;
  final double chartRadius;
  final Color fillColor;
  final Color strokeColor;

  SpiderChart({
    required this.categories,
    required this.data,
    required this.maxValue,
    required this.chartRadius,
    required this.fillColor,
    required this.strokeColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SpiderChartPainter(
        categories: categories,
        data: data,
        maxValue: maxValue,
        chartRadius: chartRadius,
        fillColor: fillColor,
        strokeColor: strokeColor,
      ),
    );
  }
}

class SpiderChartPainter extends CustomPainter {
  final List<String> categories;
  final List<double> data;
  final double maxValue;
  final double chartRadius;
  final Color fillColor;
  final Color strokeColor;

  SpiderChartPainter({
    required this.categories,
    required this.data,
    required this.maxValue,
    required this.chartRadius,
    required this.fillColor,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final totalCategories = categories.length;
    final angle = 2 * pi / totalCategories;

    Paint paintFill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    Paint paintStroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();

    for (int i = 0; i < totalCategories; i++) {
      double percent = data[i] / maxValue;
      double radius = percent * chartRadius;
      double x = centerX + radius * cos(angle * i);
      double y = centerY + radius * sin(angle * i);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 5.0, paintFill);
    }

    path.close();

    canvas.drawCircle(Offset(centerX, centerY), chartRadius, paintStroke);
    canvas.drawPath(path, paintFill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ListDoubleTween extends Tween<List<double>> {
  ListDoubleTween({List<double>? begin, List<double>? end}) : super(begin: begin, end: end);

  @override
  List<double> lerp(double t) {
    if (begin == null || end == null || begin!.length != end!.length) {
      throw ArgumentError('Invalid arguments for lerp');
    }

    List<double> result = [];
    for (int i = 0; i < begin!.length; i++) {
      result.add(begin![i] + (end![i] - begin![i]) * t);
    }
    return result;
  }
}
