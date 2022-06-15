import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/line_chart_painter.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';
import 'package:intl/intl.dart';

class SimpleLineChartGridPainter extends SimpleLineChartPainter {
  final bool drawGrid;
  final bool drawAxis;

  SimpleLineChartGridPainter(
      {required List<SeriesData> series,
      required double topLimit,
      required double bottomLimit,
      required int leftLimit,
      required int rightLimit,
      required double percentage,
      required Brightness brightness,
      required Offset? mousePosition,
      this.drawGrid = false,
      this.drawAxis = true})
      : super(
            data: series,
            topLimit: topLimit,
            bottomLimit: bottomLimit,
            leftLimit: leftLimit,
            rightLimit: rightLimit,
            percentage: percentage,
            brightness: brightness,
            mousePosition: mousePosition);

  @override
  void paint(Canvas canvas, Size size) {
    updateDateFormat(size);
    updateMargin(size);
    _drawHorizontalLines(canvas, size);
    _drawMouseHover(canvas, size);
    if (drawAxis) _drawHorizontalAxisMarks(canvas, size);
    if (drawAxis) _drawVerticalAxis(canvas, size);
  }

  Paint _getGridPaint() => Paint()
    ..strokeWidth = 1
    ..color = Colors.grey.withOpacity(0.5);

  Paint _getMouseHoverPaint() => Paint()
    ..strokeWidth = 1
    ..color = brightness == Brightness.light ? Colors.black54 : Colors.white60;

  void _drawVerticalAxis(Canvas canvas, Size size) {
    // Punto más bajo del eje vertical
    Offset bottom =
        pointToOffset(Offset(leftLimit.toDouble(), bottomLimit), size);
    // Punto más alto del eje vertical, basado en porcentaje
    Offset top = pointToOffset(
        Offset(leftLimit.toDouble(),
            bottomLimit + ((topLimit - bottomLimit) * percentage / 100)),
        size);
    //Dibujar eje vertical
    canvas.drawLine(bottom, top, _getGridPaint());
  }

  void _drawHorizontalAxisMarks(Canvas canvas, Size size) {
    // Calcular distancia entre divisiones del eje horizontal
    Duration interval = updateDateFormat(size);

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
              pointToOffset(Offset(width.toDouble(), bottomLimit), size);
          Offset bottom = top + const Offset(0, 4);
          TextPainter horizontalAxisText = createText(
              DateFormat(dateFormat)
                      .format(DateTime.fromMillisecondsSinceEpoch(width)) +
                  (width % 1000 > 0 ? ".${(width % 1000).toString()}" : ""),
              textScale,
              alpha: 255 * percentage ~/ 100);
          horizontalAxisText.paint(canvas,
              bottom + Offset(-horizontalAxisText.width / 2, emptySpace));
          canvas.drawLine(top + Offset(0, _getGridPaint().strokeWidth), bottom,
              _getGridPaint());
        }
      }
    }
  }

  void _drawHorizontalLines(Canvas canvas, Size size) {
    // Calcular el numero de líneas horizontales
    linesNumber = chartHeight(size) ~/ pxBetweenLines;
    // Por cada línea horizontal se calcula su alutura
    for (double height = bottomLimit;
        drawAxis && height <= topLimit;
        height = height + ((topLimit - bottomLimit) / linesNumber)) {
      // Crear texto de la línea vertical
      TextPainter verticalAxisText = createText(formatNumber(height), textScale,
          alpha: 255 * percentage ~/ 100);
      // Punto más a la izquierda de la línea (4 píxeles a la izquierda del eje vertical)
      Offset left = pointToOffset(Offset(leftLimit.toDouble(), height), size) -
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
      Offset right = pointToOffset(
              Offset(
                  drawGrid || (drawAxis && height == bottomLimit)
                      ? x
                      : leftLimit.toDouble(),
                  height),
              size) +
          Offset(_getGridPaint().strokeWidth, 0);
      // Dibujar texto justo a la izquierda del punto más a la izquierda de la línea
      // ajustando la posición de este para que esté centrado en la línea y separado de esta
      verticalAxisText.paint(canvas,
          left - Offset(verticalAxisText.width + emptySpace, 8 * textScale));
      // Dibujar línea
      canvas.drawLine(left, right, _getGridPaint());
    }
  }

  void _drawMouseHover(Canvas canvas, Size size) {
    if (percentage == 100 &&
        mousePosition != null &&
        mousePosition!.dx <= size.width - margin.right &&
        mousePosition!.dx >= margin.left &&
        mousePosition!.dy <= size.height - margin.bottom &&
        mousePosition!.dy >= margin.top) {
      const int dashWidth = 8;
      const int dashSpace = 4;
      double x = margin.left;
      double y = margin.top;
      while (x < size.width - margin.right || y < size.height - margin.bottom) {
        if (x < size.width - margin.right) {
          canvas.drawLine(
              Offset(x, mousePosition!.dy),
              Offset(min(x + dashWidth, size.width - margin.right),
                  mousePosition!.dy),
              _getMouseHoverPaint());
        }
        if (y < size.height - margin.bottom) {
          canvas.drawLine(
              Offset(mousePosition!.dx, y),
              Offset(mousePosition!.dx,
                  min(y + dashWidth, size.height - margin.bottom)),
              _getMouseHoverPaint());
        }
        x += dashWidth + dashSpace;
        y += dashWidth + dashSpace;
      }
      // canvas.drawCircle(mousePosition!, 4, getGridPaint());
    }
  }
}
