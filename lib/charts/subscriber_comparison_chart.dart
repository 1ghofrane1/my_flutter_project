import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_flutter_project/services/firestore_service.dart';

class SubscriberComparisonChart extends StatelessWidget {
  const SubscriberComparisonChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: FirestoreService().calculateNewSubscribersByMonth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available.');
        } else {
          return AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                barGroups: _buildBarGroups(snapshot.data!),
                titlesData: const FlTitlesData(
                  show: true,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups(
      Map<String, int> newSubscribersByMonth) {
    List<double> percentages = [];

    // Calculate percentage difference between consecutive months
    var sortedMonths = newSubscribersByMonth.keys.toList()..sort();
    for (int i = 1; i < sortedMonths.length; i++) {
      int previousCount = newSubscribersByMonth[sortedMonths[i - 1]] ?? 0;
      int currentCount = newSubscribersByMonth[sortedMonths[i]] ?? 0;
      double differencePercentage =
          ((currentCount - previousCount) / previousCount) * 100;
      percentages.add(differencePercentage);
    }

    // Create data for the chart
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < percentages.length; i++) {
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            fromY: 0, // Add the 'fromY' parameter as required
            toY: percentages[i], // Add the 'toY' parameter
            color: Colors.blue, // Add the 'color' parameter
          ),
        ],
      ));
    }

    return barGroups;
  }
}
