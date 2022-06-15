import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';
import 'package:intl/intl.dart' show DateFormat;

///Paints a line inside the available space based on [data]
class SimpleLineChartPainter extends CustomPainter {
  final List<SeriesData> data;
  final double topLimit;
  final double bottomLimit;
  final int leftLimit;
  final int rightLimit;
  final double percentage;

  final Brightness brightness;

  final bool drawLine;
  final bool drawPoints;

  //margin
  EdgeInsets margin;

  double emptySpace = 4;
  double textScale = 0.8;

  //grid
  int linesNumber = 9;
  int pxBetweenLines = 40;
  int pxBetweenVerticalLines = 150;
  String dateFormat = "dd/MM/yyyy HH:mm:ss";
  final Offset? mousePosition;

  double get x => ((rightLimit - leftLimit) * percentage / 100) + leftLimit;

  SimpleLineChartPainter({
    required this.data,
    required this.topLimit,
    required this.bottomLimit,
    required this.leftLimit,
    required this.rightLimit,
    this.percentage = 100,
    this.margin = EdgeInsets.zero,
    required this.brightness,
    this.drawLine = true,
    this.drawPoints = false,
    this.mousePosition,
  }) {
    //margen izquierdo basado en el límite superior del eje
    margin = margin.copyWith(
        bottom: createText("1", textScale).height * 2 + emptySpace,
        top: createText("1", textScale).height);
  }

  @override
  bool shouldRepaint(covariant SimpleLineChartPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    updateDateFormat(size);
    updateMargin(size);
    _drawLines(size, canvas);
  }

  Paint _getLinePaint(SeriesData lineData) => Paint()
    ..strokeWidth = 1
    ..color = brightness == Brightness.light
        ? lineData.color[600]!.withOpacity(0.8)
        : lineData.color[500]!.withOpacity(0.8);

  Paint _getPointPaint(SeriesData lineData) => Paint()
    ..strokeWidth = 1
    ..color = lineData.color;

  void _drawLines(Size size, Canvas canvas) {
    for (var series in data) {
      if (series.visible) {
        List<DataPoint> points = series.points;
        for (int i = 0; i < points.length - 1; i++) {
          if (x >= points[i].time.millisecondsSinceEpoch) {
            Offset firstPoint = pointToOffset(points[i].toOffset(), size);
            Offset secondPoint = pointToOffset(points[i + 1].toOffset(), size);
            Offset nextPoint = pointToOffset(
                _getPointBetween(points[i].toOffset(), points[i + 1].toOffset(),
                    series.maxTimestamp, series.minTimestamp, x),
                size);
            if (drawLine) {
              canvas.drawLine(firstPoint, nextPoint, _getLinePaint(series));
            }
            if (percentage == 100 &&
                mousePosition != null &&
                mousePosition!.dx >= firstPoint.dx &&
                mousePosition!.dx <= secondPoint.dx) {
              double firstDifference =
                  (mousePosition!.dx - firstPoint.dx).abs();
              double secondDifference =
                  (mousePosition!.dx - secondPoint.dx).abs();
              if (firstDifference <= secondDifference) {
                //Resaltar primer punto
                canvas.drawCircle(firstPoint, 4, _getPointPaint(series));
                series.selection = points[i];
                if (drawPoints) {
                  canvas.drawCircle(secondPoint, 2.5, _getPointPaint(series));
                }
              } else {
                //Resaltar segundo punto
                canvas.drawCircle(secondPoint, 4, _getPointPaint(series));
                series.selection = points[i + 1];
                if (drawPoints) {
                  canvas.drawCircle(firstPoint, 2.5, _getPointPaint(series));
                }
              }
            } else {
              if (mousePosition == null) {
                series.selection = null;
              }
              if (drawPoints) {
                canvas.drawCircle(firstPoint, 2.5, _getPointPaint(series));
              }
            }
            if (secondPoint != nextPoint && drawPoints && drawLine) {
              canvas.drawCircle(nextPoint, 3, _getPointPaint(series));
            }
          }
        }
        if (percentage == 100 && drawPoints) {
          canvas.drawCircle(pointToOffset(points.last.toOffset(), size), 2.5,
              _getPointPaint(series));
        }
      }
    }
  }


  Offset pointToOffset(Offset dataPoint, Size size) =>
      Offset(pointWidth(size, dataPoint.dx), pointHeight(size, dataPoint.dy));

  double chartHeight(Size size) => size.height - margin.top - margin.bottom;

  double chartWidth(Size size) => size.width - margin.right - margin.left;

  double pointHeight(Size size, double value) =>
      size.height - margin.bottom - verticalRatio(size) * (value - bottomLimit);

  double verticalRatio(Size size) =>
      chartHeight(size) / (topLimit - bottomLimit);

  double pointWidth(Size size, double value) =>
      margin.left + horizontalRatio(size) * (value - leftLimit);

  double horizontalRatio(Size size) =>
      chartWidth(size) / (rightLimit - leftLimit);

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

  void updateMargin(Size size) {
    linesNumber = chartHeight(size) ~/ pxBetweenLines;
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
              .format(DateTime.fromMillisecondsSinceEpoch(width)),
          textScale,
          alpha: 255 * percentage ~/ 100);
      if (tp.width / 2 + 8 > margin.left) {
        margin = margin.copyWith(left: tp.width / 2 + 8);
      }
      if (tp.width / 2 + 8 > margin.right) {
        margin = margin.copyWith(right: tp.width / 2 + 8);
      }
    }
  }

  Duration updateDateFormat(Size size) {
    Duration total = DateTime.fromMillisecondsSinceEpoch(rightLimit)
        .difference(DateTime.fromMillisecondsSinceEpoch(leftLimit));
    Duration interval =
        total ~/ max((chartWidth(size) ~/ pxBetweenVerticalLines), 2);
    if (total.inDays > 30) {
      interval = const Duration(days: 1);
    } else if (total.inDays > 5) {
      interval = const Duration(days: 1);
    } else if (total.inDays > 1) {
      interval = const Duration(days: 1);
    } else if (total.inHours > 12) {
      interval = const Duration(hours: 1);
    } else if (total.inHours > 1) {
      interval = const Duration(hours: 1);
    } else if (total.inMinutes > 1) {
      interval = const Duration(seconds: 30);
    } else if (total.inSeconds > 1) {
      interval = const Duration(milliseconds: 500);
    } else {
      interval = const Duration(milliseconds: 200);
    }
    double distance = horizontalRatio(size) * interval.inMilliseconds;
    TextPainter tp = createText(
        "00/00 00:00" + (interval.inSeconds < 1 ? ".000" : ""), textScale);
    while (distance < tp.width + 32) {
      interval *= 2;
      distance = horizontalRatio(size) * interval.inMilliseconds;
      tp = createText(
          "00/00 00:00" + (interval.inSeconds < 1 ? ".000" : ""), textScale);
    }
    while (distance > tp.width * 2 + 32) {
      interval ~/= 2;
      distance = horizontalRatio(size) * interval.inMilliseconds;
      tp = createText(
          "00/00 00:00" + (interval.inSeconds < 1 ? ".000" : ""), textScale);
    }

    if (interval.inDays >= 30) {
      dateFormat = "MM/yyyy";
    } else if (interval.inDays >= 1) {
      dateFormat = "dd/MM/yyyy";
    } else if (interval.inHours >= 1) {
      dateFormat = "dd/MM HH:mm";
    } else {
      dateFormat = "HH:mm:ss";
    }
    return interval;
  }
}
