
import 'dart:math';

import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spider_chart/spider_chart.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/MonthlyDBTest.dart';

class BrainSignalPage extends StatefulWidget {
  const BrainSignalPage({Key? key}) : super(key: key);

  @override
  State<BrainSignalPage> createState() => _BrainSignalPageState();
}

class _BrainSignalPageState extends State<BrainSignalPage> {
  bool darkMode = false;
  String? selectedLabel;
  bool useSides = false;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    value = value + 1;

    const style = TextStyle(
        color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 14);
    String text = value.toInt().toString();
    text = text + "월";
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = '';
    switch (value.toInt()) {
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Map<String, String> buttonLabels = {
    "avg_att": "평균\n집중도",
    "avg_med": "평균\n안정감",
    "con_score": "주의력",
    "spacetime_score": "시공간",
    "exec_score": "집행기능",
    "mem_score": "기억력",
    "ling_score": "언어기능",
    "cal_score": "계산력",
    "reac_score": "반응속도",
    "orient_score": "지남력",
  }; //버튼 이름

  List<double> _getGraphData(String label) {
    List<double> graphData = [];
    DateTime twelveMonthsAgo = DateTime.now().subtract(Duration(days: 365 * 1));
    for (var result in results) {
      // 날짜 필터링
      String? monthStr = result?.month;
      int year = int.parse(monthStr!.substring(0, 4));
      int month = int.parse(monthStr.substring(4, 6));
      DateTime date = DateTime(year, month);
      if (date.isBefore(twelveMonthsAgo)) {
        continue;
      }
      double? value;
      switch (label) {
        case "avg_att":
          value = result?.avg_att?.toDouble();
          break;
        case "avg_med":
          value = result?.avg_med?.toDouble();
          break;
        case "con_score":
          value = result?.con_score?.toDouble();
          break;
        case "spacetime_score":
          value = result?.spacetime_score?.toDouble();
          break;
        case "exec_score":
          value = result?.exec_score?.toDouble();
          break;
        case "mem_score":
          value = result?.mem_score?.toDouble();
          break;
        case "ling_score":
          value = result?.ling_score?.toDouble();
          break;
        case "cal_score":
          value = result?.cal_score?.toDouble();
          break;
        case "reac_score":
          value = result?.reac_score?.toDouble();
          break;
        case "orient_score":
          value = result?.orient_score?.toDouble();
          break;
        default:
          value = null;
      }

      if (value != null) {
        graphData.add(value);
      }
    }
    return graphData;
  }

  LineChartData _getLineChartData() {
    List<double> graphData = [];
    if (selectedLabel != null) {
      graphData = _getGraphData(selectedLabel!);
    }

    return LineChartData(
        lineTouchData: LineTouchData(enabled: true),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,


        ),
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  // interval: 3,
                  getTitlesWidget: bottomTitleWidgets),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,

                getTitlesWidget: leftTitleWidgets,

                reservedSize: 28,
                // margin: 12,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1)),
        minX: 0,
        maxX: (graphData.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
              spots: graphData
                  .asMap()
                  .map((i, e) => MapEntry(i, FlSpot(i.toDouble(), e)))
                  .values
                  .toList(),
            isCurved: true,
            gradient: LinearGradient(colors: gradientColors),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList()),
            ),)
        ]);
  }

  Widget _buildLineChart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: LineChart(_getLineChartData()),
      ),
    );
  }

  Widget _buildButtons() {
    return GridView.count(
      crossAxisCount: 5,  // 3열을 만듦
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // 스크롤을 막음
      padding: EdgeInsets.all(1.0),
      children: buttonLabels.keys.map((label) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),

          fixedSize: Size(10.0, 5.0), // 원하는 버튼 width와 height를 설
        ),
        onPressed: () {
          for (var result in results) {
            String? month = result?.month.substring(4, 6);
            var value;
            switch (label) {
              case "avg_att":
                value = result?.avg_att;
                break;
              case "avg_med":
                value = result?.avg_med;
                break;
              case "con_score":
                value = result?.con_score;
                break;
              case "spacetime_score":
                value = result?.spacetime_score;
                break;
              case "exec_score":
                value = result?.exec_score;
                break;
              case "mem_score":
                value = result?.mem_score;
                break;
              case "ling_score":
                value = result?.ling_score;
                break;
              case "cal_score":
                value = result?.cal_score;
                break;
              case "reac_score":
                value = result?.reac_score;
                break;
              case "orient_score":
                value = result?.orient_score;
                break;
              default:
                value = null;
            }
            setState(() {
              selectedLabel = label;
            });
            print("Month: $month, $label: $value");
          }
        },
        child: Text(
            buttonLabels[label]!,
          style: TextStyle(fontSize: 13.0, height: 1.3),  // 버튼 텍스트 크기 조절
        ),
      )).toList(),
    );
  }


  double numberOfFeatures = 3;
  List<MonthlyDBTest?> results = []; //넣어 둘 친구
  late final gql;
  int usercount = 0;
  int braincount = 0;

  Future<void> fetchData() async {
    gql = GraphQLController.Obj;

    try {
      gql.queryListMonthlyDBItems().then((result) {
        print(result);
      }).catchError((error) {
        print(error);
      });

      final data = await gql.queryListMonthlyDBItems();

      print(data);
      print("Type of myResult: ${data.runtimeType}");

      // 날짜에 따라 오름차순으로 정렬
      data.sort((a, b) {
        int yearA = int.parse(a.month.substring(0, 4));
        int monthA = int.parse(a.month.substring(4, 6));
        int dayA = int.parse(a.month.substring(6, 8));
        DateTime aDate = DateTime(yearA, monthA, dayA);

        int yearB = int.parse(b.month.substring(0, 4));
        int monthB = int.parse(b.month.substring(4, 6));
        int dayB = int.parse(b.month.substring(6, 8));
        DateTime bDate = DateTime(yearB, monthB, dayB);

        return aDate.compareTo(bDate);
      });

      for (int i = 0; i < data.length; i++) {
        MonthlyDBTest? currentItem = data[i];
        if (currentItem != null) {
          // currentItem에 대한 작업 수행
          print(data[i]);
        } else {
          // 아이템이 null인 경우에 대한 처리
          print("null");
        }
      }

      setState(() {
        results = data;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);


    // features = features.sublist(0, numberOfFeatures.floor());
    // data = data
    //     .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
    //     .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('뇌 신호 그래프'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: darkMode ? Colors.black : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      darkMode
                          ? Text(
                        'Light mode',
                        style: TextStyle(color: Colors.white),
                      )
                          : Text(
                        'Dark mode',
                        style: TextStyle(color: Colors.black),
                      ),
                      Switch(
                        value: this.darkMode,
                        onChanged: (value) {
                          setState(() {
                            darkMode = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Expanded(
                //   child: ListView(
                //     children: _buildButtons(),
                //   ),
                // ),
                _buildButtons(),
                AspectRatio(
                  aspectRatio: 6 / 5,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Color(0xff232d37)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: _buildLineChart() ,
                    ),
                  ),
                ),

              ]
            ),
          ),
        ),
      ),
    );
  }
}
