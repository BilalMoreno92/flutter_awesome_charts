
import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';
import 'package:intl/intl.dart' show DateFormat;

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

  double emptySpace = 4;
  double textScale = 0.8;

  //grid
  int linesNumber = 9;
  int pxBetweenLines = 40;
  int pxBetweenVerticalLines = 150;
  String dateFormat = "dd/MM/yyyy HH:mm:ss";

  double get x => ((rightLimit - leftLimit) * percentage / 100) + leftLimit;

  SimpleLineChartPainter({
    required this.series,
    required this.topLimit,
    required this.bottomLimit,
    required this.leftLimit,
    required this.rightLimit,
    this.percentage = 100,
    this.margin = const EdgeInsets.all(8),
  }) {
    //margen izquierdo basado en el límite superior del eje
    margin = margin.copyWith(
        bottom: createText("1", textScale).height * 2 + emptySpace,
        top: createText("1", textScale).height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    updateMargin();
    linesNumber = chartHeight(size) ~/ pxBetweenLines;
    drawLines(size, canvas);
  }

  @override
  bool shouldRepaint(covariant SimpleLineChartPainter oldDelegate) =>
      oldDelegate.percentage != percentage;

  void drawLines(Size size, Canvas canvas) {
    for (var element in series) {
      List<DataPoint> points = element.data;
      for (int i = 0; i < points.length - 1; i++) {
        if (x >= points[i].time.millisecondsSinceEpoch) {
          Offset firstPoint = getPointPosition(points[i].toOffset(), size);
          Offset secondPoint = getPointPosition(points[i + 1].toOffset(), size);
          Offset nextPoint = getPointPosition(
              _getPointBetween(points[i].toOffset(), points[i + 1].toOffset(),
                  element.maxTimestamp, element.minTimestamp, x),
              size);
          canvas.drawLine(firstPoint, nextPoint, getLinePaint(element));
          canvas.drawCircle(firstPoint, 2.5, getPointPaint(element));
          if (secondPoint != nextPoint) {
            canvas.drawCircle(nextPoint, 3, getPointPaint(element));
          }
        }
      }
      if (percentage == 100) {
        canvas.drawCircle(getPointPosition(points.last.toOffset(), size), 2.5,
            getPointPaint(element));
      }
    }
  }

  Paint getLinePaint(SeriesData lineData) => Paint()
    ..strokeWidth = 2
    ..color = lineData.color.withOpacity(0.5);

  Paint getGridPaint() => Paint()
    ..strokeWidth = 1
    ..color = Colors.grey.withOpacity(0.5);

  Paint getPointPaint(SeriesData lineData) => Paint()
    ..strokeWidth = 1
    ..color = lineData.color;

  Offset getPointPosition(Offset dataPoint, Size size) => Offset(
      getHorizontalPosition(size, dataPoint.dx),
      getVerticalPosition(size, dataPoint.dy));

  double chartHeight(Size size) => size.height - margin.top - margin.bottom;

  double chartWidth(Size size) => size.width - margin.right - margin.left;

  double getVerticalPosition(Size size, double value) =>
      size.height -
      margin.bottom -
      _getVerticalDistance(size) * (value - bottomLimit);

  double _getVerticalDistance(Size size) =>
      chartHeight(size) / (topLimit - bottomLimit);

  double getHorizontalDistance(Size size) =>
      chartWidth(size) / (rightLimit - leftLimit);

  double getHorizontalPosition(Size size, double value) =>
      margin.left + getHorizontalDistance(size) * (value - leftLimit);

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

  TextPainter createText(String text, double scale, {int alpha = 255}) {
    TextSpan span = TextSpan(
        style: TextStyle(color: Colors.grey[600]?.withAlpha(alpha)),
        text: text);
    TextPainter textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.start,
        textScaleFactor: scale,
        textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter;
  }

  String formatNumber(double value) {
    int precision = 0;
    if (value.toString().contains('.')) {
      if ((topLimit - bottomLimit).abs() < 0.1) {
        precision = 4;
      } else if ((topLimit - bottomLimit).abs() < 1) {
        precision = 3;
      } else if ((topLimit - bottomLimit).abs() < 10) {
        precision = 2;
      } else if ((topLimit - bottomLimit).abs() < 100) {
        precision = 1;
      }
    }
    return value.toStringAsFixed(precision);
  }

  void updateMargin() {
    for (double height = bottomLimit;
        height <= topLimit;
        height = height + ((topLimit - bottomLimit) / linesNumber)) {
      TextPainter tp = createText(formatNumber(height), textScale);
      if (tp.width + emptySpace + 8 > margin.left) {
        margin = margin.copyWith(left: tp.width + emptySpace + 8);
      }
    }
    for (int width = leftLimit;
        width <= rightLimit;
        width += (rightLimit - leftLimit) ~/ 4) {
      TextPainter tp = createText(
          DateFormat(dateFormat)
              .format(DateTime.fromMillisecondsSinceEpoch(width)), textScale,
          alpha: 255 * percentage ~/ 100);
      if (tp.width / 2 + 8 > margin.left) {
        margin = margin.copyWith(left: tp.width / 2 + 8);
      }
      if (tp.width / 2 + 8 > margin.right) {
        margin = margin.copyWith(right: tp.width / 2 + 8);
      }
    }
  }
}
