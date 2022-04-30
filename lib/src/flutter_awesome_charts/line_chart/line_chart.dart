import 'dart:developer' as d;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/grid_painter.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/line_chart_painter.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts_model/line_chart_model.dart';

/// A simple line chart
class SimpleLineChart extends StatefulWidget {
  final List<SeriesData> series;
  final EdgeInsets padding;

  const SimpleLineChart(
      {Key? key, required this.series, this.padding = EdgeInsets.zero})
      : super(key: key);

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
    return Padding(
      padding: widget.padding,
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => TweenAnimationBuilder(
                duration: const Duration(seconds: 10),
                tween: Tween<double>(begin: 0, end: 100),
                builder:
                    (BuildContext context, double percentage, Widget? child) =>
                        CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  foregroundPainter: SimpleLineChartPainter(
                      series: widget.series,
                      bottomLimit: bottomLimit,
                      topLimit: topLimit,
                      rightLimit: rightLimit,
                      leftLimit: leftLimit,
                      percentage: percentage),
                  painter: SimpleLineChartGridPainter(
                      series: widget.series,
                      bottomLimit: bottomLimit,
                      topLimit: topLimit,
                      leftLimit: leftLimit,
                      rightLimit: rightLimit,
                      percentage: percentage),
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //     onPressed: () => setState(() {leftLimit+=1000;}), child: const Text("Update"))
        ],
      ),
    );
  }
}



