import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/line_chart.dart';

import '../../../flutter_awesome_charts_model.dart';

class LegendWidget extends StatelessWidget {
  final Legend legend;
  final double percentage;

  const LegendWidget({
    Key? key,
    required this.series,
    required this.legend,
    this.percentage = 100,
  }) : super(key: key);

  final List<SeriesData> series;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.withOpacity(0.5 * percentage / 100))),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: legend == Legend.table ? Axis.vertical : Axis.horizontal,
        children: series
            .map((e) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      color: e.color.withOpacity(percentage / 100),
                      height: legend == Legend.table ? 12 : 8,
                      width: legend == Legend.table ? 12 : 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        e.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.withOpacity(percentage / 100)),
                      ),
                    )
                  ],
                ))
            .toList(),
      ),
    );
  }
}
