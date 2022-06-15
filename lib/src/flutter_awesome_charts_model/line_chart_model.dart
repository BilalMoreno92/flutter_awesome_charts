import 'package:flutter/material.dart';

class SeriesData {
  final List<DataPoint> points;
  final String label;
  final MaterialColor color;
  bool visible = true;
  late double max;
  late double min;
  late int maxTimestamp;
  late int minTimestamp;
  DataPoint? selection;

  SeriesData({
    required this.label,
    required this.points,
    this.color = Colors.blue,
  }) {
    max = points.first.value;
    min = points.first.value;
    maxTimestamp = points.first.time.millisecondsSinceEpoch;
    minTimestamp = points.first.time.millisecondsSinceEpoch;
    _sort();
    for (var element in points) {
      _updateBounds(element);
    }
  }

  void _sort() {
    points.sort((a, b) =>
        a.time.millisecondsSinceEpoch - b.time.millisecondsSinceEpoch);
  }

  void add(DataPoint dataPoint) {
    points.add(dataPoint);
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeriesData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          color == other.color;

  @override
  int get hashCode => label.hashCode ^ color.hashCode;
}

class DataPoint {
  final DateTime time;
  final double value;

  DataPoint(this.time, this.value);

  Offset toOffset() => Offset(time.millisecondsSinceEpoch.toDouble(), value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPoint &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          value == other.value;

  @override
  int get hashCode => time.hashCode ^ value.hashCode;
}
