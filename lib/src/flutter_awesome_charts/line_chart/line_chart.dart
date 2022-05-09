import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/grid_painter.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/legend_widget.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/line_chart_painter.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';

/// A simple line chart
class LineChart extends StatefulWidget {
  final List<SeriesData> series;
  final EdgeInsets padding;
  final Legend legend;
  final LegendPosition legendPosition;
  final bool animate;
  final bool drawLine;
  final bool drawPoints;
  final bool drawAxis;
  final bool drawGrid;

  const LineChart({
    Key? key,
    required this.series,
    this.padding = EdgeInsets.zero,
    this.legend = Legend.none,
    this.legendPosition = LegendPosition.bottom,
    this.animate = false,
    this.drawLine = true,
    this.drawPoints = false,
    this.drawAxis = true,
    this.drawGrid = false,
  }) : super(key: key);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart>
    with AutomaticKeepAliveClientMixin {
  late double topLimit;
  late double bottomLimit;
  late int leftLimit;
  late int rightLimit;
  late double verticalDistance;
  late double horizontalDistance;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    updateLimits();
    return Container(
      padding: widget.padding,
      child: TweenAnimationBuilder(
          duration: Duration(seconds: widget.animate ? 2 : 0),
          tween: Tween<double>(begin: 0, end: 100),
          builder: (BuildContext context, double percentage, Widget? child) =>
              Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: widget.legendPosition == LegendPosition.bottom
                    ? Axis.vertical
                    : Axis.horizontal,
                children: [
                  if (widget.legendPosition == LegendPosition.left &&
                      widget.legend != Legend.none)
                    LegendWidget(
                      series: widget.series,
                      percentage: percentage,
                      legend: widget.legend,
                    ),
                  Expanded(
                    flex: 5,
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: ScrollController(),
                        child: CustomPaint(
                          size: Size(max(constraints.maxWidth, 150),
                              max(constraints.maxHeight, 100)),
                          foregroundPainter: SimpleLineChartPainter(
                            series: widget.series,
                            bottomLimit: bottomLimit,
                            topLimit: topLimit,
                            rightLimit: rightLimit,
                            leftLimit: leftLimit,
                            percentage: percentage,
                            drawPoints: widget.drawPoints,
                            drawLine: widget.drawLine,
                          ),
                          painter: SimpleLineChartGridPainter(
                            series: widget.series,
                            bottomLimit: bottomLimit,
                            topLimit: topLimit,
                            leftLimit: leftLimit,
                            rightLimit: rightLimit,
                            percentage: percentage,
                            drawAxis: widget.drawAxis,
                            drawGrid: widget.drawGrid,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if ((widget.legendPosition == LegendPosition.right ||
                          widget.legendPosition == LegendPosition.bottom) &&
                      widget.legend != Legend.none)
                    LegendWidget(
                      series: widget.series,
                      percentage: percentage,
                      legend: widget.legend,
                    ),
                ],
              )),
    );
  }

  void updateLimits() {
    topLimit = widget.series.first.max;
    bottomLimit = widget.series.first.min;
    leftLimit = widget.series.first.minTimestamp;
    rightLimit = widget.series.first.maxTimestamp;
    for (var element in widget.series) {
      if (element.max > topLimit) {
        topLimit = element.max <= 0
            ? 0
            : element.max /*+ ((element.max-element.min)/100)*/;
      }
      if (element.min < bottomLimit) {
        bottomLimit = element.min >= 0
            ? 0
            : element.min /*- ((element.max-element.min)/100)*/;
      }
      if (element.minTimestamp < leftLimit) {
        leftLimit = element.minTimestamp;
      }
      if (element.maxTimestamp > rightLimit) {
        rightLimit = element.maxTimestamp;
      }
    }
    if (topLimit == bottomLimit) {
      topLimit += 0.1;
      bottomLimit -= 0.1;
    }
    if (leftLimit == rightLimit) {
      rightLimit += 1000;
      leftLimit -= 1000;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

enum Legend {
  table,
  list,
  none,
}

enum LegendPosition {
  left,
  bottom,
  right,
}
