import 'package:flutter/material.dart';

class SeriesData {
  final List<DataPoint> data;
  final String label;
  final MaterialColor color;
  late double max;
  late double min;
  late int maxTimestamp;
  late int minTimestamp;

  SeriesData({
    required this.label,
    required this.data,
    this.color = Colors.blue,
  }) {
    max = data.first.value;
    min = data.first.value;
    maxTimestamp = data.first.time.millisecondsSinceEpoch;
    minTimestamp = data.first.time.millisecondsSinceEpoch;
    _sort();
    for (var element in data) {
      _updateBounds(element);
    }
  }

  void _sort() {
    data.sort((a, b) =>
        a.time.millisecondsSinceEpoch - b.time.millisecondsSinceEpoch);
  }

  void add(DataPoint dataPoint) {
    data.add(dataPoint);
    _sort();
    _updateBounds(dataPoint);
  }

  void _updateBounds(DataPoint dataPoint) {
    if (dataPoint.value > max) {
      max = dataPoint.value;
    } else if (dataPoint.value < min) {
      min = dataPoint.value;
    }
    if (dataPoint.time.millisecondsSinceEpoch > maxTimestamp) {
      maxTimestamp = dataPoint.time.millisecondsSinceEpoch;
    } else if (dataPoint.time.millisecondsSinceEpoch < minTimestamp) {
      minTimestamp = dataPoint.time.millisecondsSinceEpoch;
    }
  }
}

class DataPoint {
  final DateTime time;
  final double value;

  DataPoint(this.time, this.value);

  Offset toOffset() => Offset(time.millisecondsSinceEpoch.toDouble(), value);
}
