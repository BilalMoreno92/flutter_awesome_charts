import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/flutter_awesome_charts.dart'
    show SimpleLineChart;
import 'package:flutter_awesome_charts/flutter_awesome_charts_model.dart'
    show SeriesData, DataPoint;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
            color: Colors.blue[50],
            height: 500,
            child: SimpleLineChart(
              padding: const EdgeInsets.all(64),
              series: [
                seriesData, /*seriesData2, seriesData3, seriesData4*/
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

final SeriesData seriesData = SeriesData(
    label: "Temperatura",
    data: [
      {"time": "2022-04-07T12:36:00.000Z", "mean": 0},
      {"time": "2022-04-07T12:36:05.000Z", "mean": 0.6},
      {"time": "2022-04-07T12:36:10.000Z", "mean": 0.9},
      {"time": "2022-04-07T12:36:15.000Z", "mean": 1.3},
      {"time": "2022-04-07T12:36:20.000Z", "mean": 2.2},
      {"time": "2022-04-07T12:36:25.000Z", "mean": 0.5},
      {"time": "2022-04-07T12:36:30.000Z", "mean": 1.2},
      {"time": "2022-04-07T12:36:35.000Z", "mean": 0},
      {"time": "2022-04-07T12:36:40.000Z", "mean": 1.5},
      {"time": "2022-04-07T12:36:45.000Z", "mean": 2.4},
      {"time": "2022-04-07T12:36:50.000Z", "mean": 4.6},
      {"time": "2022-04-07T12:36:55.000Z", "mean": 3.9},
      {"time": "2022-04-07T12:37:00.000Z", "mean": 2},
      {"time": "2022-04-07T12:37:05.000Z", "mean": -1.1},
      {"time": "2022-04-07T12:37:10.000Z", "mean": -2},
      {"time": "2022-04-07T12:37:15.000Z", "mean": 0},
      {"time": "2022-04-07T12:37:20.000Z", "mean": 4.7},
      {"time": "2022-04-07T12:37:25.000Z", "mean": 6.5},
      {"time": "2022-04-07T12:37:30.000Z", "mean": 4.9},
      {"time": "2022-04-07T12:37:35.000Z", "mean": 2.6},
      {"time": "2022-04-07T12:37:40.000Z", "mean": 2},
      {"time": "2022-04-07T12:37:45.000Z", "mean": 1.6},
      // {"time": "2022-04-07T12:37:50.000Z", "mean": 3},
      // {"time": "2022-04-07T12:37:55.000Z", "mean": 1},
      // {"time": "2022-04-07T12:38:00.000Z", "mean": 0},
      // {"time": "2022-04-07T12:38:05.000Z", "mean": 1},
      // {"time": "2022-04-07T12:38:10.000Z", "mean": 0},
      // {"time": "2022-04-07T12:38:15.000Z", "mean": 1},
      // {"time": "2022-04-07T12:38:20.000Z", "mean": 2},
      // {"time": "2022-04-07T12:38:25.000Z", "mean": 0},
      // {"time": "2022-04-07T12:38:30.000Z", "mean": 1},
      // {"time": "2022-04-07T12:38:35.000Z", "mean": 0},
      // {"time": "2022-04-07T12:38:40.000Z", "mean": 1},
      // {"time": "2022-04-07T12:38:45.000Z", "mean": 2},
      // {"time": "2022-04-07T12:38:50.000Z", "mean": 4},
      // {"time": "2022-04-07T12:38:55.000Z", "mean": 3},
      {"time": "2022-04-07T12:39:00.000Z", "mean": 2},
      {"time": "2022-04-07T12:39:05.000Z", "mean": -1},
      {"time": "2022-04-07T12:39:10.000Z", "mean": -2},
      {"time": "2022-04-07T12:39:15.000Z", "mean": 0},
      {"time": "2022-04-07T12:39:20.000Z", "mean": 5},
      {"time": "2022-04-07T12:39:25.000Z", "mean": 7.5},
      {"time": "2022-04-07T12:39:30.000Z", "mean": 5},
      {"time": "2022-04-07T12:39:35.000Z", "mean": 1},
      {"time": "2022-04-07T12:39:40.000Z", "mean": 0},
      {"time": "2022-04-07T12:39:45.000Z", "mean": 2},
      {"time": "2022-04-07T12:39:50.000Z", "mean": 3},
      {"time": "2022-04-07T12:39:55.000Z", "mean": 1},
    ]
        .map((e) => DataPoint(
            DateFormat("yyyy-MM-ddTHH:mm:ssZ")
                .parseUTC(e["time"].toString())
                .toLocal(),
            e["mean"] as double))
        .toList());

final Random random = Random();

final SeriesData seriesData2 = SeriesData(
    label: "Temperatura",
    color: Colors.amber,
    data: seriesData.data
        .map((e) => DataPoint(e.time, ((random.nextInt(600)) / 100)))
        .toList());

final SeriesData seriesData3 = SeriesData(
    label: "Temperatura",
    color: Colors.blue,
    data: seriesData.data
        .map((e) => DataPoint(e.time, ((random.nextInt(600)) / 100)))
        .toList());

final SeriesData seriesData4 = SeriesData(
    label: "Temperatura",
    color: Colors.deepOrange,
    data: seriesData.data
        .map((e) => DataPoint(e.time, ((random.nextInt(600)) / 100)))
        .toList());
