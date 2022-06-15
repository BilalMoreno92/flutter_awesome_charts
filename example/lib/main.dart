import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/flutter_awesome_charts.dart'
    show Legend, LegendPosition, LineChart;
import 'package:flutter_awesome_charts/flutter_awesome_charts_model.dart'
    show SeriesData, DataPoint;

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  Brightness _brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: _brightness,
        ),
        home: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () => setState(() {
                      if (_brightness == Brightness.light) {
                        _brightness = Brightness.dark;
                      } else {
                        _brightness = Brightness.light;
                      }
                    }),
                  icon: const Icon(Icons.brightness_6))
            ],
            title: const Text("Flutter Awesome Charts"),
          ),
          body: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, mainAxisExtent: 500),
            children: [
              LineChart(
                padding: const EdgeInsets.all(0),
                series: [
                  seriesData,
                  seriesData3,
                  seriesData4,
                ],
                legend: Legend.table,
                legendPosition: LegendPosition.left,
                animate: true,
              ),
              LineChart(
                padding: const EdgeInsets.all(0),
                series: [
                  seriesData2,
                  seriesData3, /*seriesData2, seriesData3, seriesData4*/
                ],
                animate: true,
                drawPoints: true,
                drawAxis: false,
                legend: Legend.list,
              ),
              LineChart(
                padding: const EdgeInsets.all(0),
                series: [seriesData3, seriesData4],
                legend: Legend.table,
                legendPosition: LegendPosition.right,
                drawPoints: true,
                drawGrid: true,
              ),
              LineChart(
                padding: const EdgeInsets.all(0),
                series: [
                  seriesData4, /*seriesData2, seriesData3, seriesData4*/
                ],
                animate: true,
                drawPoints: true,
                drawLine: false,
                drawGrid: true,
              ),
            ],
          ),
        ));
  }
}

final SeriesData seriesData = SeriesData(
    color: Colors.pink,
    label: "Temperatura",
    points: [
      {"time": "2022-04-07T12:36:00.000Z", "mean": 0},
      {"time": "2022-04-07T12:36:05.000Z", "mean": 0.1},
      {"time": "2022-04-07T12:36:10.000Z", "mean": 0.2},
      {"time": "2022-04-07T12:36:15.000Z", "mean": 1},
      {"time": "2022-04-07T12:36:20.000Z", "mean": 0.2},
      {"time": "2022-04-07T12:36:25.000Z", "mean": 0.5},
      {"time": "2022-04-07T12:36:30.000Z", "mean": 0.2},
      {"time": "2022-04-07T12:36:35.000Z", "mean": 0},
      {"time": "2022-04-07T12:36:40.000Z", "mean": 1.5},
      {"time": "2022-04-07T12:36:45.000Z", "mean": 2.4},
      {"time": "2022-04-07T12:36:50.000Z", "mean": 4.6},
      {"time": "2022-04-07T12:36:55.000Z", "mean": 3.9},
      {"time": "2022-04-07T12:37:00.000Z", "mean": 2},
      {"time": "2022-04-07T12:37:05.000Z", "mean": 1.1},
      {"time": "2022-04-07T12:37:10.000Z", "mean": 2},
      {"time": "2022-04-07T12:37:15.000Z", "mean": 0},
      {"time": "2022-04-07T12:37:20.000Z", "mean": 4.7},
      {"time": "2022-04-07T12:37:25.000Z", "mean": 10},
      {"time": "2022-04-07T12:37:30.000Z", "mean": 4.9},
      {"time": "2022-04-07T12:37:35.000Z", "mean": 2.6},
      {"time": "2022-04-07T12:37:40.000Z", "mean": 2},
      {"time": "2022-04-07T12:37:45.000Z", "mean": 1.6},
      {"time": "2022-04-07T12:37:50.000Z", "mean": 1},
      {"time": "2022-04-07T12:37:55.000Z", "mean": 2},
      {"time": "2022-04-07T12:38:00.000Z", "mean": 5},
      {"time": "2022-04-07T12:38:05.000Z", "mean": 1},
      {"time": "2022-04-07T12:38:10.000Z", "mean": 0.15},
      {"time": "2022-04-07T12:38:15.000Z", "mean": 1},
      {"time": "2022-04-07T12:38:20.000Z", "mean": 0.2},
      {"time": "2022-04-07T12:38:25.000Z", "mean": 0},
      {"time": "2022-04-07T12:38:30.000Z", "mean": 1},
      {"time": "2022-04-07T12:38:35.000Z", "mean": 0},
      {"time": "2022-04-07T12:38:40.000Z", "mean": 1},
      {"time": "2022-04-07T12:38:45.000Z", "mean": 2},
      {"time": "2022-04-07T12:38:50.000Z", "mean": 1.99},
      {"time": "2022-04-07T12:38:55.000Z", "mean": 5},
      {"time": "2022-04-07T12:39:00.000Z", "mean": 2},
      {"time": "2022-04-07T12:39:05.000Z", "mean": 0},
      {"time": "2022-04-07T12:39:10.000Z", "mean": 0.5},
      {"time": "2022-04-07T12:39:15.000Z", "mean": 2},
      {"time": "2022-04-07T12:39:20.000Z", "mean": 5},
      {"time": "2022-04-07T12:39:25.000Z", "mean": 3.5},
      {"time": "2022-04-07T12:39:30.000Z", "mean": 5},
      {"time": "2022-04-07T12:39:35.000Z", "mean": 1},
      {"time": "2022-04-07T12:39:40.000Z", "mean": 0},
      {"time": "2022-04-07T12:39:45.000Z", "mean": 2},
      {"time": "2022-04-07T12:39:50.000Z", "mean": 3},
      {"time": "2022-04-07T12:39:55.000Z", "mean": 1},
    ]
        .map((e) => DataPoint(DateTime.parse(e["time"].toString()).toLocal(),
            (e["mean"] as num).toDouble()))
        .toList());

final Random random = Random();

final SeriesData seriesData2 = SeriesData(
    label: "Vibración",
    color: Colors.amber,
    points: seriesData.points
        .map((e) => DataPoint(e.time, ((random.nextInt(600)) / 10000)))
        .toList());

final SeriesData seriesData3 = SeriesData(
    label: "Caudal",
    color: Colors.orange,
    points: seriesData.points
        .map((e) => DataPoint(e.time, ((random.nextInt(600)) / 100)))
        .toList());

final SeriesData seriesData4 = SeriesData(
    label: "Humedad",
    color: Colors.cyan,
    points: seriesData.points
        .map((e) => DataPoint(e.time, ((random.nextInt(600)) / 100)))
        .toList());
