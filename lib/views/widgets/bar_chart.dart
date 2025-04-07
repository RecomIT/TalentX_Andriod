import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CustomBarChart extends StatefulWidget {
  final List<String> labels;
  final List<double> values;
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  CustomBarChart({
    Key key,
    @required this.labels,
    @required this.values,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomBarChartState();
}

class CustomBarChartState extends State<CustomBarChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Attendance Overview',
                    style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: BarChart(
                      mainBarData(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // get all bar data
  BarChartData mainBarData() {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          margin: 5,
          getTitles: (double value) {
            return value.toInt() >= 0 && value.toInt() < widget.labels?.length ? widget.labels[value.toInt()] : " ";
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          // vertical labels
          getTitles: (num) => num.toStringAsFixed(0) + "%",
          interval: 20,
          margin: 12,
          getTextStyles: (_) => TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  // util for making bardata
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 8,
    Color barColor = Colors.blue,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 100,
            colors: [Colors.white],
          ),
        ),
      ],
    );
  }

  // generate bar data
  List<BarChartGroupData> showingGroups() => List.generate(
        widget.values?.length,
        (i) => makeGroupData(
          i,
          widget.values[i],
          barColor: getColorFromNumber(i),
        ),
      );
}
