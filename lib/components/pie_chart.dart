import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final List<Map<String, Object?>> categoryCount;
  final Map<String, String> categoryTitles;
  final int touchedIndex = 0;

  const PieChartWidget({
    super.key,
    required this.categoryCount,
    required this.categoryTitles,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.75,
      child: PieChart(
        PieChartData(
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: showingSections(context),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(BuildContext context) {
    final totalCategories = categoryCount.length;
    if (totalCategories == 0) {
      return List.generate(1, (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 20.0 : 16.0;
        final radius = isTouched ? 110.0 : 100.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

        return PieChartSectionData(
          color: Theme.of(context).primaryColor,
          value: 100,
          title: 'No data',
          radius: radius,
          titlePositionPercentageOffset: 0,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
        );
      });
    }

    var totalItems = 0;

    for (var i = 0; i < totalCategories; i++) {
      totalItems += categoryCount[i]['count'] as int;
    }

    return List.generate(totalCategories, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 110.0 : 100.0;
      final category = categoryCount[i];
      final value = category['count'] as int;
      final title =
          "${categoryTitles[category['category_id']]}\n${(value.toDouble() / totalItems * 100).toStringAsFixed(1)}%";

      Color getRandomColor() {
        Random random = Random();
        return Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        );
      }

      return PieChartSectionData(
        value: value.toDouble() / totalItems * 100,
        title: title,
        radius: radius,
        titlePositionPercentageOffset: totalItems == 1 ? 0 : 0.5,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
        color: getRandomColor(),
      );
    });
  }
}
