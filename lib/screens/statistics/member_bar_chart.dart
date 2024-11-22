import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MemberBarChart extends StatefulWidget {
  final Map<String, int> memberStats; // Dữ liệu thống kê thành viên

  MemberBarChart({required this.memberStats});

  @override
  _MemberBarChartState createState() => _MemberBarChartState();
}

class _MemberBarChartState extends State<MemberBarChart> {
  String selectedYear = DateFormat('yyyy').format(DateTime.now()); // Mặc định chọn năm hiện tại

  // Hàm lọc thống kê thành viên theo năm
  Map<String, int> getMonthlyData() {
    Map<String, int> monthlyData = {};
    for (int i = 1; i <= 12; i++) {
      String monthKey = '$selectedYear-${i.toString().padLeft(2, '0')}';
      monthlyData[monthKey] = widget.memberStats[monthKey] ?? 0; // Nếu không có sự kiện, gán 0
    }
    return monthlyData;
  }
  @override
  Widget build(BuildContext context) {
    Map<String, int> monthlyData = getMonthlyData();
    List<String> months = [];
    List<int> values = [];

    monthlyData.forEach((key, value) {
      months.add(key.substring(5)); // Lấy tháng (MM)
      values.add(value);
    });

    int maxMembers = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0;

    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Thống kê thành viên ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Chọn năm: ', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: selectedYear,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items: List.generate(5, (index) {
                      int year = DateTime.now().year - index;
                      return DropdownMenuItem<String>(
                        value: year.toString(),
                        child: Text(year.toString()),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  maxY: maxMembers.toDouble() + 3,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${months[groupIndex]}: ',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: rod.toY.toString(),
                              style: const TextStyle(color: Colors.yellowAccent),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < months.length) {
                            return Text(
                              months[index],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, horizontalInterval: 2),
                  barGroups: months.asMap().entries.map((entry) {
                    int index = entry.key;
                    double value = values[index].toDouble();
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          color: value == 0
                              ? Colors.transparent
                              : Colors.green,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(show: false),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
