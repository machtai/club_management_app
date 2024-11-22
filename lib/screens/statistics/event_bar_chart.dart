import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class EventBarChart extends StatefulWidget {
  final Map<String, int> eventStats; // Dữ liệu thống kê sự kiện, ví dụ: {'2024-01': 10, '2024-02': 15, ...}

  EventBarChart({required this.eventStats});

  @override
  _EventBarChartState createState() => _EventBarChartState();
}

class _EventBarChartState extends State<EventBarChart> with SingleTickerProviderStateMixin {
  String selectedYear = DateFormat('yyyy').format(DateTime.now()); // Mặc định chọn năm hiện tại
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Hàm lấy số lượng sự kiện theo tháng của năm đã chọn
  Map<String, int> getMonthlyData() {
    Map<String, int> monthlyData = {};
    for (int i = 1; i <= 12; i++) {
      String monthKey = '$selectedYear-${i.toString().padLeft(2, '0')}';
      monthlyData[monthKey] = widget.eventStats[monthKey] ?? 0; // Nếu không có sự kiện, gán 0
    }
    return monthlyData;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Thời gian animation
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward(); // Bắt đầu animation khi màn hình được tạo
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    // Tìm tháng có số sự kiện cao nhất để quyết định màu sắc
    int maxEvents = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0;

    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Thống kê sự kiện',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            
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
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      maxY: maxEvents.toDouble() + 3,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          // tooltipBgColor: Colors.blueAccent,
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
                        Color barColor = value == 0
                            ? Colors.transparent // Không hiển thị cột nếu không có dữ liệu
                            : value < maxEvents
                                ? Colors.lightBlue // Màu cho cột có giá trị thấp hơn max
                                : Colors.lightBlue; // Màu cho cột có giá trị cao nhất
    
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: _animation.value * value, // Thêm animation vào giá trị Y
                              color: barColor,
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: false, // Không hiển thị màu nền cho các cột
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
