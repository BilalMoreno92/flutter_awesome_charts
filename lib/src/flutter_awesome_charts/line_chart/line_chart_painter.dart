import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';

///Paints a line inside the available space based on [series]
class SimpleLineChartPainter extends CustomPainter {
  final List<SeriesData> series;
  final double topLimit;
  final double bottomLimit;
  final int leftLimit;
  final int rightLimit;
  final double percentage;

  //margin
  EdgeInsets margin;

  static double emptySpace = 4;
  static double textScale = 0.8;

  //grid
  int linesNumber = 10;

  // axis
  static double axisWidth = 2;
  static double axisTextScale = 1;

  double get x => ((rightLimit - leftLimit) * percentage / 100) + leftLimit;

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
    this.margin = EdgeInsets.zero,
  }) {
    //margen izquierdo basado en el límite superior del eje
    margin = margin.copyWith(
        bottom: createText("1", axisTextScale).height * 2 + emptySpace);
    for (double height = bottomLimit;
        height <= topLimit;
        height = height + ((topLimit - bottomLimit) / linesNumber)) {
      TextPainter tp = createText(height.roundToDouble().toString(), textScale);
      if (tp.width + emptySpace > margin.left) {
        margin = margin.copyWith(left: tp.width + emptySpace + 8);
      }
    }
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
      List<DataPoint> points = element.data;
      for (int i = 0; i < (points.length - 1); i++) {
        if (x > points[i].time.millisecondsSinceEpoch) {
          Offset firstPoint = getPointPosition(points[i].toOffset(), size);
          Offset nextPoint = getPointPosition(
              _getPointBetween(points[i].toOffset(), points[i + 1].toOffset(),
                  element.maxTimestamp, element.minTimestamp, x),
              size);
          canvas.drawLine(firstPoint, nextPoint, getLinePaint(element));
          canvas.drawCircle(firstPoint, 3, getPointPaint(element));
        }
        if (percentage == 100) {
          canvas.drawCircle(getPointPosition(points.last.toOffset(), size), 3,
              getPointPaint(element));
        }
      }
    }
  }

  Paint getLinePaint(SeriesData lineData) => Paint()
    ..strokeWidth = 3
    ..color = lineData.color.withOpacity(0.5);

  Paint getGridPaint() => Paint()
    ..strokeWidth = 1
    ..color = Colors.grey.withOpacity(0.5);

  Paint getPointPaint(SeriesData lineData) => Paint()
    ..strokeWidth = 1
    ..color = lineData.color;

  Offset getPointPosition(Offset dataPoint, Size size) => Offset(
      _getHorizontalPosition(size, dataPoint.dx),
      getVerticalPosition(size, dataPoint.dy));

  double chartHeight(Size size) => size.height - margin.top - margin.bottom;

  double chartWidth(Size size) => size.width - margin.right - margin.left;

  double getVerticalPosition(Size size, double value) =>
      size.height -
      margin.bottom -
      _getVerticalDistance(size) * (value - bottomLimit);

  double _getVerticalDistance(Size size) =>
      chartHeight(size) / (topLimit - bottomLimit);

  double _getHorizontalDistance(Size size) =>
      chartWidth(size) / (rightLimit - leftLimit);

  double _getHorizontalPosition(Size size, double value) =>
      margin.left + _getHorizontalDistance(size) * (value - leftLimit);

  Offset _getPointBetween(Offset first, Offset second, int maxTimestamp,
      int minTimestamp, double x) {
    double slope = (second.dy - first.dy) / (second.dx - first.dx);
    double y = slope * (x - first.dx) + first.dy;
    return Offset(
        x > second.dx ? second.dx : x,
        slope > 0 && y > second.dy || slope < 0 && y < second.dy
            ? second.dy
            : y);
  }

  TextPainter createText(String key, double scale, {int alpha = 255}) {
    TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.grey[600]?.withAlpha(alpha)),
        text: key);
    TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.start,
        textScaleFactor: scale,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter;
  }
}
