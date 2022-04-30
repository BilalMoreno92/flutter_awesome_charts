import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/line_chart_painter.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';

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
      required int rightLimit,
      required double percentage})
      : super(
            series: series,
            topLimit: topLimit,
            bottomLimit: bottomLimit,
            leftLimit: leftLimit,
            rightLimit: rightLimit,
            percentage: percentage);

  @override
  void paint(Canvas canvas, Size size) {
    for (double height = bottomLimit;
        height <= topLimit;
        height = (height + ((topLimit - bottomLimit) / linesNumber))
            .roundToDouble()) {
      double x = ((rightLimit - leftLimit) *
              (percentage + percentage * (topLimit -height) / (topLimit - bottomLimit)) /
              (100 + percentage * (topLimit-height) / (topLimit - bottomLimit))) +
          leftLimit;
      Offset left =
          getPointPosition(Offset(leftLimit.toDouble(), height), size) -
              const Offset(4, 0);
      Offset right = getPointPosition(Offset(x, height), size);
      canvas.drawLine(left, right, getGridPaint());
      TextPainter tp = createText(
          height.toString(), SimpleLineChartPainter.textScale,
          alpha: 255 *
              (percentage + percentage * (topLimit-height) / (topLimit - bottomLimit)) ~/
              (100 + percentage * (topLimit - height) / (topLimit - bottomLimit)));
      tp.paint(
          canvas,
          left -
              Offset(tp.width + SimpleLineChartPainter.emptySpace,
                  8 * SimpleLineChartPainter.textScale));
    }
    Offset bottom =
        getPointPosition(Offset(leftLimit.toDouble(), bottomLimit), size);
    Offset top = getPointPosition(
        Offset(leftLimit.toDouble(),
            bottomLimit + ((topLimit - bottomLimit) * percentage / 100)),
        size);
    canvas.drawLine(bottom, top, getGridPaint());
  }
}
