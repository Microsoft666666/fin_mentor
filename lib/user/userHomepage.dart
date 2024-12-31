import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserHomepage extends StatefulWidget {
  const UserHomepage({Key? key}) : super(key: key);

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  late String uid;
  late Future<DocumentSnapshot> userDocFuture;

  /// Our filter options (could be "Weekly", "Monthly", "All", etc.)
  final List<String> _rangeOptions = ["Weekly", "Monthly", "All"];
  /// The currently selected filter
  String _selectedRange = "Weekly";

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    userDocFuture = FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  /// Convert the `participation_log` map from Firestore
  /// (key = date string, value = hours) into a List of MapEntry<DateTime, double>.
  List<MapEntry<DateTime, double>> _parseParticipationLog(DocumentSnapshot doc) {
    if (!doc.exists) return [];

    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return [];

    if (!data.containsKey('participation_log')) return [];
    final logRaw = data['participation_log'];
    if (logRaw is! Map<String, dynamic>) return [];

    final entries = <MapEntry<DateTime, double>>[];
    logRaw.forEach((key, value) {
      if (key is String && key.trim().isNotEmpty) {
        final date = DateTime.tryParse(key);
        final hours = (value is num) ? value.toDouble() : 0.0;
        if (date != null) {
          entries.add(MapEntry(date, hours));
        }
      }
    });

    // Sort ascending by date
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  /// Filter entries for the last [days] days.
  List<MapEntry<DateTime, double>> _filterByDays(
      List<MapEntry<DateTime, double>> allEntries,
      int days,
      ) {
    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days));
    return allEntries.where((e) => e.key.isAfter(cutoff)).toList();
  }

  /// Returns the widget with the bar chart and total hours, given the (date, hours) entries.
  Widget _buildChartWidget(List<MapEntry<DateTime, double>> entries) {
    if (entries.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // If all are zero
    if (entries.every((e) => e.value == 0)) {
      return const Center(child: Text('No data available'));
    }

    double maxY = 0;
    final barData = <BarChartGroupData>[];
    final dates = <DateTime>[];

    for (int i = 0; i < entries.length; i++) {
      final e = entries[i];
      dates.add(e.key);
      if (e.value > maxY) maxY = e.value;

      barData.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: e.value,
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
    final totalHours = entries.fold<double>(0, (sum, entry) => sum + entry.value);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Hours:",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${totalHours.toStringAsFixed(1)}h",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Activity Chart",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
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
                              _buildBottomTitle(value, meta, dates),
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
                                    color: Colors.grey[200],
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
                        color: Colors.grey[200]!,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: barData,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the bottom (x-axis) label: e.g. "M/d"
  Widget _buildBottomTitle(
      double value, TitleMeta meta, List<DateTime> dates) {
    if (value < 0 || value >= dates.length) {
      return Container();
    }
    final date = dates[value.toInt()];
    final label = "${date.month}/${date.day}"; // e.g. "1/5"
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[300],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot>(
        future: userDocFuture,
        builder: (context, snapshot) {
          // 1) Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2) Error or no data
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(child: Text('No data available'));
          }

          // 3) Parse all entries from doc
          final allEntries = _parseParticipationLog(snapshot.data!);

          // Decide how to filter based on _selectedRange
          List<MapEntry<DateTime, double>> filteredEntries;
          if (_selectedRange == "Weekly") {
            filteredEntries = _filterByDays(allEntries, 7);
          } else if (_selectedRange == "Monthly") {
            filteredEntries = _filterByDays(allEntries, 30);
          } else {
            // "All": no filter
            filteredEntries = allEntries;
          }

          return Column(
            children: [
              // Our dropdown
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      "Select Range:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _selectedRange,
                      items: _rangeOptions.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedRange = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Expanded chart
              Expanded(
                child: _buildChartWidget(filteredEntries),
              ),
            ],
          );
        },
      ),
    );
  }
}
