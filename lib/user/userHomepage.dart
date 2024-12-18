import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({Key? key}) : super(key: key);

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  late String uid;
  late Future<DocumentSnapshot> userDocFuture;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    userDocFuture = FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Widget getTitles(double value, TitleMeta meta, List<DateTime> dates) {
    final style = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (value < 0 || value >= dates.length) return Container();

    final date = dates[value.toInt()];
    final weekday = _getWeekdayAbbreviation(date.weekday);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(weekday, style: style),
    );
  }

  String _getWeekdayAbbreviation(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot>(
        future: userDocFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there's an error or no data, show a message
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data available'));
          }

          final doc = snapshot.data!;
          final data = doc.data() as Map<String, dynamic>?;

          // Check if 'hours' field exists and is a map
          if (data == null || !data.containsKey('hours') || data['hours'] == null) {
            return const Center(child: Text('No data available'));
          }

          final hoursRaw = data['hours'];
          if (hoursRaw is! Map<String, dynamic>) {
            return const Center(child: Text('No data available'));
          }

          final hoursMap = hoursRaw;

          if (hoursMap.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          // Convert the hours map into a list of (DateTime, double) pairs
          List<MapEntry<DateTime, double>> entries = hoursMap.entries
              .map((e) {
            final key = e.key.trim();
            if (key.isEmpty) return null;
            final date = DateTime.tryParse(key);
            final value = e.value is num ? (e.value as num).toDouble() : 0.0;
            if (date != null) {
              return MapEntry(date, value);
            }
            return null;
          })
              .where((element) => element != null)
              .cast<MapEntry<DateTime, double>>()
              .toList();

          // If no valid entries after parsing
          if (entries.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          // Sort by date
          entries.sort((a, b) => a.key.compareTo(b.key));

          // Take the last 7 days or so to display
          const daysToShow = 7;
          if (entries.length > daysToShow) {
            entries = entries.sublist(entries.length - daysToShow);
          }

          // Check if all values are zero
          if (entries.every((element) => element.value == 0)) {
            return const Center(child: Text('No data available'));
          }

          // Prepare data for chart
          final barData = <BarChartGroupData>[];
          final dates = <DateTime>[];
          double maxY = 0;
          for (int i = 0; i < entries.length; i++) {
            final e = entries[i];
            dates.add(e.key);
            final yValue = e.value;
            if (yValue > maxY) maxY = yValue;
            barData.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: yValue,
                    width: 20,
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ],
              ),
            );
          }

          // Calculate total hours
          final totalHours = entries.fold<double>(0, (sum, e) => sum + e.value);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Hours:",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${totalHours.toStringAsFixed(1)}h",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Activity This Week",
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (maxY < 1) ? 1 : maxY,
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) =>
                                    getTitles(value, meta, dates),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  if (value % 1 == 0) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        '${value.toInt()}h',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey[300]!,
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          barGroups: barData,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
