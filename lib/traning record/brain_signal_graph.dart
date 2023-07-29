
import 'dart:math';

import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/MonthlyDBTest.dart';

class BrainSignalPage extends StatefulWidget {
  BrainSignalPage({Key? key,required this.latestDataDate}) : super(key: key);

  String latestDataDate;

  @override
  State<BrainSignalPage> createState() => _BrainSignalPageState();
}

class _BrainSignalPageState extends State<BrainSignalPage> {
  bool darkMode = false;
  String? selectedLabel;
  bool useSides = false;


  List<String> buttonLabels = [
    "avg_att",
    "avg_med",
    "con_score",
    "spacetime_score",
    "exec_score",
    "mem_score",
    "ling_score",
    "cal_score",
    "reac_score",
    "orient_score",
  ]; //버튼 이름
  List<double> _getGraphData(String label) {
    List<double> graphData = [];
    for (var result in results) {
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
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        minX: 0,
        maxX: (graphData.length - 1).toDouble(),
        minY: 0,
        maxY: graphData.isNotEmpty ? graphData.reduce(max) : 0,
        lineBarsData: [
          LineChartBarData(
              spots: graphData
                  .asMap()
                  .map((i, e) => MapEntry(i, FlSpot(i.toDouble(), e)))
                  .values
                  .toList(),
              barWidth: 6,
              color: Colors.blue,
              dotData: FlDotData(show: true))
        ]);
  }

  Widget _buildLineChart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
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
      padding: EdgeInsets.all(8.0),
      children: buttonLabels.map((label) => ElevatedButton(
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
          label,
          style: TextStyle(fontSize: 13.0),  // 버튼 텍스트 크기 조절
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
    //   gql.queryListMonthlyDBItems(int.parse(widget.latestDataDate)).then((result) {
    //     print(result);
    //   }).catchError((error) {
    //     print(error);
    //   });

      final data = await gql.queryListMonthlyDBItems(int.parse(widget.latestDataDate));

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
                _buildLineChart() ,
              ]
            ),
          ),
        ),
      ),
    );
  }
}
