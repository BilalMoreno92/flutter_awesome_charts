import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/line_chart_painter.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';
import 'package:intl/intl.dart';

class SimpleLineChartGridPainter extends SimpleLineChartPainter {
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
    updateMargin();
    drawHorizontalLines(canvas, size);
    drawHorizontalAxisMarks(size, canvas);
    drawVerticalAxis(size, canvas);
  }

  void drawVerticalAxis(Size size, Canvas canvas) {
    // Punto más bajo del eje vertical
    Offset bottom =
        getPointPosition(Offset(leftLimit.toDouble(), bottomLimit), size);
    // Punto más alto del eje vertical, basado en porcentaje
    Offset top = getPointPosition(
        Offset(leftLimit.toDouble(),
            bottomLimit + ((topLimit - bottomLimit) * percentage / 100)),
        size);
    //Dibujar eje vertical
    canvas.drawLine(bottom, top, getGridPaint());
  }

  void drawHorizontalAxisMarks(Size size, Canvas canvas) {
    // Calcular distancia entre divisiones del eje horizontal
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
    double distance = getHorizontalDistance(size) * interval.inMilliseconds;
    TextPainter tp = createText(
        "00/00 00:00" +
            (interval.inSeconds < 1 ? ".000" : ""),
        textScale);
    while (distance < tp.width + 32) {
      interval *= 2;
      distance = getHorizontalDistance(size) * interval.inMilliseconds;
      tp = createText(
          "00/00 00:00" +
              (interval.inSeconds < 1 ? ".000" : ""),
          textScale);
    }
    while (distance > tp.width * 2 + 32) {
      interval ~/= 2;
      distance = getHorizontalDistance(size) * interval.inMilliseconds;
      tp = createText(
          "00/00 00:00" +
              (interval.inSeconds < 1 ? ".000" : ""),
          textScale);
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

    // Dibujar cada línea y texto bajo el eje horizontal
    for (int width = leftLimit - leftLimit % interval.inMilliseconds;
        width <= rightLimit;
        width += interval.inMilliseconds) {
      if (width >= leftLimit) {
        double x = ((rightLimit - leftLimit) *
                (percentage + percentage) /
                (100 + percentage)) +
            leftLimit;
        if (x >= width) {
        Offset top =
            getPointPosition(Offset(width.toDouble(), bottomLimit), size);
        Offset bottom = top + const Offset(0, 4);
        TextPainter horizontalAxisText = createText(
            DateFormat(dateFormat)
                    .format(DateTime.fromMillisecondsSinceEpoch(width)) +
                (width % 1000 > 0
                    ? ".${(width % 1000).toString()}"
                    : ""),
            textScale,
            alpha: 255 * percentage ~/ 100);
        horizontalAxisText.paint(
            canvas, bottom + Offset(-horizontalAxisText.width / 2, emptySpace));
          canvas.drawLine(top + Offset(0, getGridPaint().strokeWidth), bottom,
              getGridPaint());
        }
      }
    }
  }

  void drawHorizontalLines(Canvas canvas, Size size) {
    // Calcular el numero de líneas horizontales
    linesNumber = chartHeight(size) ~/ pxBetweenLines;
    // Por cada línea horizontal se calcula su alutura
    for (double height = bottomLimit;
        height <= topLimit;
        height = height + ((topLimit - bottomLimit) / linesNumber)) {
      // Crear texto de la línea vertical
      TextPainter verticalAxisText = createText(formatNumber(height), textScale,
          alpha: 255 * percentage ~/ 100);
      // Punto más a la izquierda de la línea (4 píxeles a la izquierda del eje vertical)
      Offset left =
          getPointPosition(Offset(leftLimit.toDouble(), height), size) -
              const Offset(4, 0);
      // Calcular "x" basado en porcetaje de la animación y altura de la línea,
      // para que la línea más alta se dibuje más rápido que la más baja
      double x = ((rightLimit - leftLimit) *
              (percentage +
                  percentage *
                      ((topLimit) - height) /
                      (topLimit - bottomLimit)) /
              (100 +
                  percentage *
                      (topLimit - height) /
                      (topLimit - bottomLimit))) +
          leftLimit;
      // Punto más a la derecha de la línea, basado en "x"
      Offset right = getPointPosition(Offset(x, height), size)+Offset(getGridPaint().strokeWidth, 0);
      // Dibujar texto justo a la izquierda del punto más a la izquierda de la línea
      // ajustando la posición de este para que esté centrado en la línea y separado de esta
      verticalAxisText.paint(canvas,
          left - Offset(verticalAxisText.width + emptySpace, 8 * textScale));
      // Dibujar línea
      canvas.drawLine(left, right, getGridPaint());
    }
  }
}
