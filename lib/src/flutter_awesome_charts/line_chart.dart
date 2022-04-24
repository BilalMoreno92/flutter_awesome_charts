import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';

/// A simple line chart
class SimpleLineChart extends StatefulWidget {
  final List<SeriesData> series;

  const SimpleLineChart({Key? key, required this.series}) : super(key: key);

  @override
  State<SimpleLineChart> createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart> {
  late double topLimit;
  late double bottomLimit;
  late int leftLimit;
  late int rightLimit;
  late double verticalDistance;
  late double horizontalDistance;

  @override
  void initState() {
    topLimit = double.negativeInfinity;
    bottomLimit = double.infinity;
    leftLimit = widget.series.first.minTimestamp;
    rightLimit = widget.series.first.maxTimestamp;
    for (var element in widget.series) {
      if (element.max > topLimit) {
        topLimit = element.max + 1 - element.max % 1;
      }
      if (element.min < bottomLimit) {
        bottomLimit = element.min > 0 ? 0 : element.min - 1 + element.min % 1;
      }
      if (element.minTimestamp < leftLimit) {
        leftLimit = element.minTimestamp;
      }
      if (element.maxTimestamp > rightLimit) {
        rightLimit = element.maxTimestamp;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TweenAnimationBuilder(
        duration: const Duration(seconds: 2),
        tween: Tween<double>(begin: 0, end: 100),
        builder: (BuildContext context, double value, Widget? child) =>
            CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          foregroundPainter: SimpleLineChartPainter(
              series: widget.series,
              bottomLimit: bottomLimit,
              topLimit: topLimit,
              rightLimit: rightLimit,
              leftLimit: leftLimit,
              percentage: value),
          painter: SimpleLineChartGridPainter(
              series: widget.series,
              bottomLimit: bottomLimit,
              topLimit: topLimit,
              leftLimit: leftLimit,
              rightLimit: rightLimit),
        ),
      ),
    );
  }
}

///Paints a line inside the available space based on [series]
class SimpleLineChartPainter extends CustomPainter {
  final List<SeriesData> series;
  final double topLimit;
  final double bottomLimit;
  final int leftLimit;
  final int rightLimit;
  final double percentage;

  //margin
  late double marginLeft;
  late double marginTop = 8;
  late double marginBottom;
  late double marginRight = 8;
  static double emptySpace = 8;

  // axis
  static double axisWidth = 2;
  static double axisTextScale = 1;

  // two main lines
  Paint axis = Paint()
    ..strokeWidth = axisWidth
    ..color = Colors.grey;

  SimpleLineChartPainter({
    required this.series,
    required this.topLimit,
    required this.bottomLimit,
    required this.leftLimit,
    required this.rightLimit,
    this.percentage = 100,
  }) {
    //margen izquierdo basado en el límite superior del eje
    marginLeft = _createText(topLimit.toString(), 1).width + emptySpace;
    marginBottom = _createText("1", axisTextScale).height * 2 + emptySpace;
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawLines(size, canvas);
  }

  @override
  bool shouldRepaint(covariant SimpleLineChartPainter oldDelegate) =>
      oldDelegate.percentage != percentage;

  void drawLines(Size size, Canvas canvas) {
    for (var element in series) {
      var points = element.data;
      for (int i = 0; i < (points.length - 1); i++) {
        var percentageOfLine = (points.length - 1) *
            min<double>(percentage - i * 100 / (points.length - 1),
                100 / (points.length - 1));
        if (percentageOfLine > 0) {
          var firstPoint = _getPointPosition(points[i], size);
          var goalPoint = _getPointPosition(points[i + 1], size);
          var nextPoint = Offset(
              percentageOfLine / 100 * (goalPoint.dx - firstPoint.dx) +
                  firstPoint.dx,
              percentageOfLine / 100 * (goalPoint.dy - firstPoint.dy) +
                  firstPoint.dy);
          canvas.drawLine(_getPointPosition(points[i], size), nextPoint,
              _getLinePaint(element));
          canvas.drawCircle(firstPoint, 3, _getLineDataColorPaint(element));
        }
      }
      if (percentage >= 99.9) {
        canvas.drawCircle(_getPointPosition(points[points.length - 1], size), 3,
            _getLineDataColorPaint(element));
      }
    }
  }

  Paint _getLinePaint(SeriesData lineData) {
    return Paint()
      ..strokeWidth = 3
      ..color = lineData.color.withOpacity(0.5);
  }

  Paint _getLineDataColorPaint(SeriesData lineData) {
    return Paint()
      ..strokeWidth = 1
      ..color = lineData.color;
  }

  Offset _getPointPosition(DataPoint dataPoint, Size size) => Offset(
      _getHorizontalPosition(
          size, dataPoint.time.millisecondsSinceEpoch as double),
      _getVerticalPosition(size, dataPoint.value));

  double chartHeight(Size size) => size.height - marginTop - marginBottom;

  double chartWidth(Size size) => size.width - marginRight - marginLeft;

  double _getVerticalPosition(Size size, double value) {
    return size.height -
        marginBottom -
        _getVerticalDistance(size) * (value - bottomLimit);
  }

  double _getVerticalDistance(Size size) {
    return chartHeight(size) / (topLimit - bottomLimit);
  }

  double _getHorizontalDistance(Size size) {
    return chartWidth(size) / (rightLimit - leftLimit);
  }

  double _getHorizontalPosition(Size size, double value) {
    return marginLeft + _getHorizontalDistance(size) * (value - leftLimit);
  }

  TextPainter _createText(String key, double scale) {
    TextSpan span =
        TextSpan(style: TextStyle(color: Colors.grey[600]), text: key);
    TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.start,
        textScaleFactor: scale,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter;
  }
}

class SimpleLineChartGridPainter extends SimpleLineChartPainter {
  // grid
  Paint axisLight = Paint()
    ..strokeWidth = SimpleLineChartPainter.axisWidth
    ..color = Colors.grey.withOpacity(0.5);

  SimpleLineChartGridPainter(
      {required List<SeriesData> series,
      required double topLimit,
      required double bottomLimit,
      required int leftLimit,
      required int rightLimit})
      : super(
            series: series,
            topLimit: topLimit,
            bottomLimit: bottomLimit,
            leftLimit: leftLimit,
            rightLimit: rightLimit);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final path = Path();
    path.moveTo(0, _getVerticalPosition(size, -3));
    path.lineTo(size.width, _getVerticalPosition(size, -3));
    path.moveTo(0, _getVerticalPosition(size, -2));
    path.lineTo(size.width, _getVerticalPosition(size, -2));
    path.moveTo(0, _getVerticalPosition(size, -1));
    path.lineTo(size.width, _getVerticalPosition(size, -1));
    path.moveTo(0, _getVerticalPosition(size, 0));
    path.lineTo(size.width, _getVerticalPosition(size, 0));
    path.moveTo(0, _getVerticalPosition(size, 1));
    path.lineTo(size.width, _getVerticalPosition(size, 1));
    path.moveTo(0, _getVerticalPosition(size, 2));
    path.lineTo(size.width, _getVerticalPosition(size, 2));
    path.moveTo(0, _getVerticalPosition(size, 3));
    path.lineTo(size.width, _getVerticalPosition(size, 3));
    path.moveTo(0, _getVerticalPosition(size, 4));
    path.lineTo(size.width, _getVerticalPosition(size, 4));
    path.moveTo(0, _getVerticalPosition(size, 5));
    path.lineTo(size.width, _getVerticalPosition(size, 5));
    path.moveTo(0, _getVerticalPosition(size, 6));
    path.lineTo(size.width, _getVerticalPosition(size, 6));
    path.moveTo(0, _getVerticalPosition(size, 7));
    path.lineTo(size.width, _getVerticalPosition(size, 7));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
