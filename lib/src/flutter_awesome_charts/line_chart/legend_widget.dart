import 'package:flutter/material.dart';
import 'package:flutter_awesome_charts/src/flutter_awesome_charts/line_chart/line_chart.dart';

import '../../../flutter_awesome_charts_model.dart';

class LegendWidget extends StatelessWidget {
  final Legend legend;
  final double percentage;
  final bool showSelection;
  final ValueChanged<bool> onVisibilityChanged;
  final List<SeriesData> series;

  const LegendWidget({
    Key? key,
    required this.series,
    required this.legend,
    this.percentage = 100,
    required this.onVisibilityChanged,
    required this.showSelection,
  }) : super(key: key);

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
        children: [
          for (var i = 0; i < series.length; i++)
            GestureDetector(
              onTap: () {
                series[i].visible = !series[i].visible;
                onVisibilityChanged(series[i].visible);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(4),
                    color: series[i].color.withOpacity(
                        percentage / 100 / (series[i].visible ? 1 : 2)),
                    height: legend == Legend.table ? 12 : 8,
                    width: legend == Legend.table ? 12 : 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      series[i].label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.withOpacity(
                              percentage / 100 / (series[i].visible ? 1 : 2))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      width: 64,
                      child: Text(
                        showSelection
                            ? series[i].selection?.value.toString() ?? "-"
                            : "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.withOpacity(percentage /
                                100 /
                                (series[i].visible ? 1 : 2))),
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
