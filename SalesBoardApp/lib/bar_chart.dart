import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:salesboardapp/models/Sales.dart';
import 'package:intl/intl.dart';

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key, required this.sales});

  final List<SalesResult> sales;

  final Color leftBarColor = const Color(0xff1a5ca5);
  final Color rightBarColor = Colors.red;
  final Color avgColor = const Color(0xff89c740);

  @override
  State<StatefulWidget> createState() => SubBarChart();
}

class SubBarChart extends State<BarChartPage> {
  late int divide;
  late List<SalesResult> sale;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  double max = 0.0;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    sale = widget.sales;
    for (var element in sale) {
      if (max < double.parse(element.sales)) {
        max = double.parse(element.sales);
      }
    }
    max = max + 100.0;
    divide = (max * 0.5).toInt();

    List<BarChartGroupData> items = [];
    int index = 0;
    for (var element in sale) {
      items.add(makeGroupData(index, (double.parse(element.sales) / divide), element.date));
      index++;
    }
    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Total Sales',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: max / divide,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.grey,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            sale[groupIndex].sales,
                            // "Hi $groupIndex",
                            const TextStyle(
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, response) {
                        if (response == null || response.spot == null) {
                          setState(() {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                          });
                          return;
                        }

                        touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                        setState(() {
                          if (!event.isInterestedForInteractions) {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                            return;
                          }
                          showingBarGroups = List.of(rawBarGroups);
                          if (touchedGroupIndex != -1) {
                            var sum = 0.0;
                            for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                              sum += rod.toY;
                            }
                            final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;

                            showingBarGroups[touchedGroupIndex] = showingBarGroups[touchedGroupIndex].copyWith(
                              barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                return rod.copyWith(toY: avg, color: widget.avgColor);
                              }).toList(),
                            );
                          }
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: const FlGridData(show: true),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    final mid = (max / divide) / 2;
    final fi = (max / divide);

    // log("value: $value, mid: $mid, fi: $fi");

    if (value.toInt() == 0) {
      text = '0';
    } else if (value.toInt() == mid.toInt()) {
      text = test((max ~/ 2).toString());
    } else if (value.toInt() == fi.toInt()) {
      text = test(max.toInt().toString());
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  String test(String str) {
    var result = NumberFormat.compact(locale: 'en_IN').format(int.parse(str));
    // if (result.contains('K') && result.length > 3) {
    //   result = result.substring(0, result.length - 1);
    //   var prefix = (result.split('.').last.length) + 1;
    //   var temp = (double.parse(result) * .001).toStringAsFixed(prefix);
    //   result = '${double.parse(temp)}M';
    // }
    return result;
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = Text(
      sale[value.toInt()].date,
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, String y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: 15,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.black.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.black.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.black.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.black.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.black.withOpacity(0.4),
        ),
      ],
    );
  }
}
