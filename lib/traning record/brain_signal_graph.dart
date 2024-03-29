
import 'dart:math';

import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/MonthlyDBTest.dart';

class BrainSignalPage extends StatefulWidget {
  BrainSignalPage({Key? key}) : super(key: key);


  @override
  State<BrainSignalPage> createState() => _BrainSignalPageState();
}
class _BrainSignalPageState extends State<BrainSignalPage> {

  String? selectedLabel;
  bool useSides = false;

  //그래프 버튼마다 색상을 다르게 하기 위해 존재함 각각 그래프의 색상!
  List<Color> buttomColors = [
    Color(0xff237ACF), // Dark Blue
    Color(0xff905C7E), // Orchid
    Color(0xffAA7F39), // Golden Brown
    Color(0xffDD6031), // Deep Orange
    Color(0xff3CDBD3), // Turquoise
    Color(0xff117A65), // Jungle Green
    Color(0xff764BA2), // Purple
    Color(0xff801336), // Burgundy
    Color(0xffEB9F9A), // Salmon
    Color(0xffFAD201), // Yellow

  ];



  // 이 코드는 그래프의 x축의 값을 나타내는 위젯입니다. 각 월을 반환합니다.
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    // value가 0 또는 양수이고 값이 리스트 범위 내에 있음을 확인합니다.
    if (value >= 0 && value < results.length) {
      String? currentDate = results[value.toInt()]?.month;

      int year = int.parse(currentDate!.substring(0, 4));
      int month = int.parse(currentDate.substring(4, 6));
      String text = "$month월";

      final style = TextStyle(
          color: Color(0xff68737d),
          fontWeight: FontWeight.bold,
          fontSize: 12);

      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(text, style: style, textAlign: TextAlign.center),
      );
    } else {
      return Container();
    }
  }



  //이 위젯은 그래프의 각 y축의 값을 나타내는 위젯입니다.
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

  // 버튼의 각 라벨들을 매핑해주는 것들입니다. 왼쪽에 있는 것은 db를 통해서 불러온 값이고 오른쪽이 보여주고자 하는 값입니다.
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

  //그래프의 데이터를 가져오는 메서드 입니다.
  //twelveMonthsAgo이라는 변수를 통해서 최근 1년까지를 설정하고 버튼을 눌렀을때 그 이름에 따른 데이터를 가져오게 됩니다.
  //그래프 데이터를 각각 수집한 것을 graphData라는 리스트에 넣어 반환하게 됩니다.
  //TODO: 현재시각으로부터 1년을 설정하는 것이 아니라 12개의 데이터를 찾아야하는 건지 질문하기
  List<double> _getGraphData(String label,int colorIndex) {
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

  //그래프 데이터를 통해서 각 값을 가져오고 보여주는 부분입니다.
  // 라인 차트의 디자인을 변경하고 싶다면 이 부분을 수정하면 될 것입니다.
  // selectedGradientColors 여기서 그라데이션 색상이 정해집니다. 두가지로 구성이 되어있는데 하나는 위에서 정한 색상으로 하고 다른 하나는
  // 정한 색상에 투명도를 0.8로 줍니다. 컬러 인덱스와 라벨 인덱스는 동일하게 갑니다.
  // CHART의 디자인을 변경하고 싶다면 LineChartData를 수정하면 됩니다.
  LineChartData _getLineChartData() {
    List<double> graphData = [];
    int colorIndex = 0;
    if (selectedLabel != null) {
      colorIndex = buttonLabels.keys.toList().indexOf(selectedLabel!);
      graphData = _getGraphData(selectedLabel!, colorIndex);
    }
    List<Color> selectedGradientColors = [      buttomColors[colorIndex],
      buttomColors[colorIndex].withOpacity(0.8),
    ];


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
                  reservedSize: 40,
                  interval: 1,
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

            gradient: LinearGradient(colors: selectedGradientColors),
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                  colors: selectedGradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList()),
            ),
          )
        ]);
  }

  //이 위젯은 컨테이너를 생성하고 그 안에 PADDING을 넣고 LineChart를 그리게 됩니다.
  // 정리하면 _buildLineChart는 LineChart를 불러오고 LineChart는 _getLineChartData함수를 통해서 _getGraphData이 데이터를 불러와
  //buttonColors를 통해 그래프의 색을 정하고, leftTitleWidgets를 통해 Y축을 정하고 bottomTitleWidgets으로 x축의 값을 정해 그리게 됩니다.
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

  //그래프 위에 버튼을 구성하는 위젯입니다.
  //그리드를 통해 버튼을 2행으로 구성해서 총 10개를 보여주게 됩니다. 그래서 1행당 5개의 버튼이 존재하게 됩니다.
  // 버튼의 모양을 수정하고 싶다면 이 부분을 수정하면 될 것입니다.
  Widget _buildButtons() {
    return GridView.count(
      crossAxisCount: 5,  // 2행을 만듦
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // 스크롤을 막음
      padding: EdgeInsets.all(1.0),
      children: buttonLabels.keys.map((label) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(), // 이 부분을 통해서 원형으로 구성하게 됩니다.
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

    // 빌드하는 부분입니다. 이 곳에서는 그래프가 들어가는 box의 쉐입을 정하는 곳입니다. 그래프가 있는 곳 박스를 수정하고 싶다면 이 곳을 수정하시면 됩니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('뇌 신호 그래프'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color:  Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

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
