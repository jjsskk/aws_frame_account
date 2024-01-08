import 'dart:math';
import 'dart:core';

import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/loading_page/loading_page.dart';
import 'package:aws_frame_account/models/ModelProvider.dart';
import 'package:aws_frame_account/traning%20record/custom_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AnalyzingReportPage extends StatefulWidget {
  const AnalyzingReportPage({Key? key}) : super(key: key);

  @override
  State<AnalyzingReportPage> createState() => _AnalyzingReportPageState();
}

class _AnalyzingReportPageState extends State<AnalyzingReportPage> {
  final iconColor = Colors.white;

  bool loading = true;

  var userbutton = '유저(훈련인) 데이터 추가';
  var brainbutton = '뇌파 데이터 추가';

  late final gql;

  int usercount = 0; // DATA count added to USER DB
  int braincount = 0; // DATA count added to MONTHLY DB

  int CON_SCORE = 0;

  // 주의력 점수
  int SPACETIME_SCORE = 0;

  //시공간 점수
  int EXEC_SCORE = 0;

  //집행기능 점수
  int MEM_SCORE = 0;

  // 기억력 점수
  int LING_SCORE = 0;

  //언어기능 점수
  int CAL_SCORE = 0;

  //계산력 점수
  int REAC_SCORE = 0;

  //반응속도 점수
  int ORIENT_SCORE = 0;

  int AVG_ATT = 0;

  //평균 집중력

  int AVG_MED = 0;

  //평균 안정감

  int CON_SCORE_AVG = 0; // 주의력 점수

  int SPACETIME_SCORE_AVG = 0; //시공간 점수

  int EXEC_SCORE_AVG = 0; //집행기능 점수

  int MEM_SCORE_AVG = 0; // 기억력 점수

  int LING_SCORE_AVG = 0; //언어기능 점수

  int CAL_SCORE_AVG = 0; //계산력 점수

  int REAC_SCORE_AVG = 0; //반응속도 점수

  int ORIENT_SCORE_AVG = 0; //지남력점수

  int AVG_ATT_AVG = 0; //평균 집중력

  int AVG_MED_AVG = 0; //평균 안정감

  List<String> users = []; // storing user Ids having similar ageEra

  List<Future<dynamic?>> futuresList = [];
  int ageEra = 0;
  var month = 1; // for DropdownDatePicker
  var year = 2023; // for DropdownDatePicker
  List<String> monthList = [
    '1월',
    '2월',
    '3월',
    '4월',
    '5월',
    '6월',
    '7월',
    '8월',
    '9월',
    '10월',
    '11월',
    '12월',
  ];
  List<String> yearList = [];

  String dropdownYear = '';
  String dropdownMonth = '';

  int numberForonedata = 1; // for extractRequiredUserData()

  Map<String, List<int>> allData = {}; // variable for _getBars()

  void makeYearDropdownValues() {
    month = DateTime.now().month;
    year = DateTime.now().year;
    var tempYear = year - 3;
    for (; tempYear < year + 4; tempYear++) yearList.add('$tempYear년');

    dropdownMonth = '$month월';
    dropdownYear = '$year년';
  }

  @override
  void initState() {
    super.initState();
    makeYearDropdownValues();
    gql = GraphQLController.Obj;
    extractLatestBrainData();
  }

  void extractLatestBrainData() {
    gql.queryMonthlyDBLatestItem().then((values) {
      print(values);
      if (values.isNotEmpty) {
        values.sort((a, b) {
          String aa = a.month;

          String bb = b.month;
          return bb.compareTo(aa);
        });

        var value = values.first;
        setState(() {
          CON_SCORE = value!.con_score;
          SPACETIME_SCORE = value!.spacetime_score;
          EXEC_SCORE = value!.exec_score;
          MEM_SCORE = value!.mem_score;
          LING_SCORE = value!.ling_score;
          CAL_SCORE = value!.cal_score;
          REAC_SCORE = value!.reac_score;
          ORIENT_SCORE = value!.orient_score;
          AVG_ATT = value!.avg_att;
          AVG_MED = value!.avg_med;
          month = int.parse(value.month.substring(4, 6));
          print("month : $month");
          year = int.parse(value.month.substring(0, 4));
        });
      }
      extractSimilarAge();
    });
  }

  Future<dynamic> extractRequiredBrainData() {
    int changeddate = year * 10000 + month * 100;
    numberForonedata = 0;
    Future<dynamic> future = gql
        .queryMonthlyDBRequiredItem(gql.userNumber, changeddate)
        .then((values) {
      // 현제 보호자의 유저(훈련인)의 데이터 불러오기
      if (values.isNotEmpty) {
        values.sort((a, b) {
          String aa = a.month;

          String bb = b.month;
          return bb.compareTo(aa);
        });
        var value = values.first;
        if (value != null) {
          setState(() {
            numberForonedata++;
            CON_SCORE = value!.con_score;
            SPACETIME_SCORE = value!.spacetime_score;
            EXEC_SCORE = value!.exec_score;
            MEM_SCORE = value!.mem_score;
            LING_SCORE = value!.ling_score;
            CAL_SCORE = value!.cal_score;
            REAC_SCORE = value!.reac_score;
            ORIENT_SCORE = value!.orient_score;
            AVG_ATT = value!.avg_att;
            AVG_MED = value!.avg_med;
          });
        }
      }
    });

    return future;
  }

  void extractSimilarAge() {
    users = [];
    // String birth = "19651008";
    String birth = gql.userBirth;
    print(birth);
    int year = int.parse(birth.substring(0, 4));
    int month = int.parse(birth.substring(4, 6));
    int day = int.parse(birth.substring(6, 8));
    DateTime birthday = DateTime(year, month, day);

    DateDuration duration;

    // Find out your age as of today's date 2021-03-08
    duration = AgeCalculator.age(birthday);
    int age = duration.years;
    print('Your age is ${age}'); // Your age is Years: 24, Months: 0, Days: 3

    ageEra = ((duration.years ~/ 10) * 10);

    int diff = age - ageEra;

    print(diff);

    int maxYear = (year + diff) * 10000;
    int minYear = (year - (9 - diff)) * 10000;
    print(minYear);
    print(maxYear);

    gql.queryListUserDBItemsForAverageAge(minYear, maxYear).then((result) {
      // extract SimilarAge users Ids
      // print(result);
      result.forEach((value) {
        // print("${value.id}");
        users.add(value.ID);
      });
      futuresList = [];
      calculateAverageSignal();
    }).catchError((error) {
      print(error);
    });
  }

  void calculateAverageSignal() async {
    // futuresList = [];
    allData = {};

    int CON_SCORE_SUM = 0; // 주의력 점수

    int SPACETIME_SCORE_SUM = 0; //시공간 점수

    int EXEC_SCORE_SUM = 0; //집행기능 점수

    int MEM_SCORE_SUM = 0; // 기억력 점수

    int LING_SCORE_SUM = 0; //언어기능 점수

    int CAL_SCORE_SUM = 0; //계산력 점수

    int REAC_SCORE_SUM = 0; //반응속도 점수

    int ORIENT_SCORE_SUM = 0; //지남력점수

    int AVG_ATT_SUM = 0;

    int AVG_MED_SUM = 0;

    // String month = "20230701";
    // int monthint = int.parse(month.substring(0, 7));
    // monthint = monthint *10;
    int changeddate = year * 10000 + month * 100;

    print("monthint: $changeddate");

    int numberForavg = 0;
    users.forEach((selectedAgeUserId) async {
      // print(id);
      Future<dynamic> future = gql
          .queryMonthlyDBRequiredItem(selectedAgeUserId, changeddate)
          .then((values) {
        //같은 연렁대 유저(훈련인)의 데이터 불러오기 (보호자의 유저(훈련인)가 아님)
        var value = values.last;
        if (value != null) {
          numberForavg++;
          CON_SCORE_SUM += value.con_score as int;

          SPACETIME_SCORE_SUM += value.spacetime_score as int;

          EXEC_SCORE_SUM += value.exec_score as int; //집행기능 점수

          MEM_SCORE_SUM += value.mem_score as int; // 기억력 점수

          LING_SCORE_SUM += value.ling_score as int; //언어기능 점수

          CAL_SCORE_SUM += value.cal_score as int; //계산력 점수

          REAC_SCORE_SUM += value.reac_score as int; //반응속도 점수

          ORIENT_SCORE_SUM += value.orient_score as int; //지남력점수

          AVG_ATT_SUM += value.avg_att as int;

          AVG_MED_SUM += value.avg_med as int;
          // int a = (CON_SCORE_SUM ~/ number);
          // print("con : ${a}");
        }
      });
      futuresList.add(future);
    });
    // Wait for all the Futures to complete using Future.wait()
    await Future.wait<dynamic>(futuresList).then((List<dynamic> results) {
      // All Futures are completed
      // results is a list containing the results of each Future in the order they were added
    }).catchError((error) {
      // Handle any errors that occurred during the asynchronous operations
      print('Error occurred: $error');
    });
    setState(() {
      if (numberForavg > 0) {
        if (numberForonedata == 0) {
          CON_SCORE = 0;
          SPACETIME_SCORE = 0;
          EXEC_SCORE = 0;
          MEM_SCORE = 0;
          LING_SCORE = 0;
          CAL_SCORE = 0;
          REAC_SCORE = 0;
          ORIENT_SCORE = 0;
          AVG_ATT = 0;
          AVG_MED = 0;
          numberForonedata = 0;
        }

        ORIENT_SCORE_AVG = (ORIENT_SCORE_SUM ~/ numberForavg);
        allData['지남력'] = [ORIENT_SCORE, ORIENT_SCORE_AVG];

        CON_SCORE_AVG = (CON_SCORE_SUM ~/ numberForavg); //135/3= 45
        allData['주의력'] = [CON_SCORE, CON_SCORE_AVG];

        SPACETIME_SCORE_AVG = (SPACETIME_SCORE_SUM ~/ numberForavg);
        allData['시공간'] = [SPACETIME_SCORE, SPACETIME_SCORE_AVG];

        EXEC_SCORE_AVG = (EXEC_SCORE_SUM ~/ numberForavg);
        allData['집행기능'] = [EXEC_SCORE, EXEC_SCORE_AVG];

        MEM_SCORE_AVG = (MEM_SCORE_SUM ~/ numberForavg);
        allData['기억력'] = [MEM_SCORE, MEM_SCORE_AVG];

        LING_SCORE_AVG = (LING_SCORE_SUM ~/ numberForavg); //언어기능 점수
        allData['언어기능'] = [LING_SCORE, LING_SCORE_AVG];

        CAL_SCORE_AVG = (CAL_SCORE_SUM ~/ numberForavg); //계산력 점수
        allData['계산력'] = [CAL_SCORE, CAL_SCORE_AVG];

        REAC_SCORE_AVG = (REAC_SCORE_SUM ~/ numberForavg); //반응속도 점수
        allData['반응 속도'] = [REAC_SCORE, REAC_SCORE_AVG];

        AVG_ATT_AVG = (AVG_ATT_SUM ~/ numberForavg);
        allData['집중력'] = [AVG_ATT, AVG_ATT_AVG];

        AVG_MED_AVG = (AVG_MED_SUM ~/ numberForavg);
        allData['안정감'] = [AVG_MED, AVG_MED_AVG];
      } else {
        if (numberForonedata == 0) {
          CON_SCORE = 0;
          SPACETIME_SCORE = 0;
          EXEC_SCORE = 0;
          MEM_SCORE = 0;
          LING_SCORE = 0;
          CAL_SCORE = 0;
          REAC_SCORE = 0;
          ORIENT_SCORE = 0;
          numberForonedata = 0;
          AVG_ATT = 0;
          AVG_MED = 0;
        }

        ORIENT_SCORE_AVG = 0;
        allData['지남력'] = [ORIENT_SCORE, ORIENT_SCORE_AVG];

        CON_SCORE_AVG = 0; //135/3= 45
        allData['주의력'] = [CON_SCORE, CON_SCORE_AVG];

        SPACETIME_SCORE_AVG = 0;
        allData['시공간'] = [SPACETIME_SCORE, SPACETIME_SCORE_AVG];

        EXEC_SCORE_AVG = 0;
        allData['집행기능'] = [EXEC_SCORE, EXEC_SCORE_AVG];

        MEM_SCORE_AVG = 0;
        allData['기억력'] = [MEM_SCORE, MEM_SCORE_AVG];

        LING_SCORE_AVG = 0; //언어기능 점수
        allData['언어기능'] = [LING_SCORE, LING_SCORE_AVG];

        CAL_SCORE_AVG = 0; //계산력 점수
        allData['계산력'] = [CAL_SCORE, CAL_SCORE_AVG];

        REAC_SCORE_AVG = 0; //반응속도 점수
        allData['반응 속도'] = [REAC_SCORE, REAC_SCORE_AVG];

        AVG_ATT_AVG = 0;
        allData['집중력'] = [AVG_ATT, AVG_ATT_AVG];

        AVG_MED_AVG = 0;
        allData['안정감'] = [AVG_MED, AVG_MED_AVG];
      }

      print('지남력:${allData.keys.first}');
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);

    const ticks = [20, 40, 60, 80, 100];
    var features = [
      "지남력($ORIENT_SCORE)",
      "주의력($CON_SCORE)",
      "시공간($SPACETIME_SCORE)",
      "집행기능($EXEC_SCORE)",
      "기억력($MEM_SCORE)",
      "언어기능($LING_SCORE)",
      "계산력($CAL_SCORE)",
      "반응속도($REAC_SCORE)",
      // "집중력($AVG_ATT)",
      // "안정감($AVG_MED)",
    ];
    var data = [
      [
        ORIENT_SCORE,
        CON_SCORE,
        SPACETIME_SCORE,
        EXEC_SCORE,
        MEM_SCORE,
        LING_SCORE,
        CAL_SCORE,
        REAC_SCORE,

        // AVG_ATT,
        // AVG_MED,
      ]
    ];

    // features = features.sublist(0, numberOfFeatures.floor());
    // data = data
    //     .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
    //     .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('분석 보고서',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: iconColor)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
              fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
            ),
          ),
        ),
      ),
      body: loading
          ? LoadingPage()
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage("image/ui (2).png"), // 여기에 배경 이미지 경로를 지정합니다.
                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 25,
                          width: MediaQuery.of(context).size.width / 3.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage("image/report (20).png"),
                              // 여기에 배경 이미지 경로를 지정합니다.
                              fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                            ),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.indigoAccent,
                              value: dropdownYear,
                              icon: Icon(
                                // Add this
                                Icons.arrow_drop_down, // Add this
                                color: Colors.white, // Add this
                              ),
                              onChanged: (String? value) {
                                setState(
                                  () {
                                    dropdownYear = value!;
                                    year = int.parse(value!.substring(0, 4));
                                  },
                                );
                                print(year);
                              },
                              items: yearList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 25,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage("image/report (20).png"),
                              // 여기에 배경 이미지 경로를 지정합니다.
                              fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                            ),
                          ),
                          child: Center(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.indigoAccent,
                              value: dropdownMonth,
                              icon: Icon(
                                // Add this
                                Icons.arrow_drop_down, // Add this
                                color: Colors.white, // Add this
                              ),
                              onChanged: (String? value) {
                                setState(
                                  () {
                                    dropdownMonth = value!;
                                    int len = value!.length;
                                    month = int.parse(
                                        value!.substring(0, len > 2 ? 2 : 1));
                                  },
                                );
                                print(month);
                              },
                              items: monthList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: DropdownDatePicker(
                        //     inputDecoration: InputDecoration(
                        //         enabledBorder: const OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //               color: Colors.grey, width: 1.0),
                        //         ),
                        //         border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(10))),
                        //     // optional
                        //     isDropdownHideUnderline: true,
                        //     // optional
                        //     isFormValidator: true,
                        //     // optional
                        //     startYear: 2022,
                        //     // optional
                        //     endYear: 2030,
                        //     // optional
                        //     width: 10,
                        //     // optional
                        //     locale: "zh_CN",
                        //     // selectedDay: 14, // optional
                        //     showDay: false,
                        //     selectedMonth: month,
                        //     // optional
                        //     selectedYear: year,
                        //     // optional
                        //     // onChangedDay: (value) => print('onChangedDay: $value'),
                        //     onChangedMonth: (value) {
                        //       print('onChangedMonth: $value');
                        //       month = int.parse(value!);
                        //     },
                        //     onChangedYear: (value) {
                        //       print('onChangedYear: $value');
                        //       year = int.parse(value!);
                        //     },
                        //     //boxDecoration: BoxDecoration(
                        //     // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                        //     // showDay: false,// optional
                        //     // dayFlex: 2,// optional
                        //     // locale: "zh_CN",// optional
                        //     // hintDay: 'Day', // optional
                        //     // hintMonth: 'Month', // optional
                        //     // hintYear: 'Year', // optional
                        //     // hintTextStyle: TextStyle(color: Colors.grey), // optional
                        //   ),
                        // ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  futuresList = [];
                                  futuresList.add(extractRequiredBrainData());

                                  calculateAverageSignal();
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: const Color(0xff1f43f3),
                                )),
                          ),
                        )
                      ],
                    ),
                    // BUTTONS for adding artificial data to DB
                    // Row(
                    //   children: [
                    //     TextButton(
                    //       onPressed: () async {
                    //         await gql.createUserData();
                    //         setState(() {
                    //           usercount++;
                    //           userbutton = "$usercount번 추가";
                    //         });
                    //       },
                    //       child: Text(userbutton),
                    //     ),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     TextButton(
                    //       onPressed: () async {
                    //         await gql.createMonthlyData();
                    //         setState(() {
                    //           braincount++;
                    //           brainbutton = "$braincount번 추가";
                    //         });
                    //       },
                    //       child: Text(brainbutton),
                    //     ),
                    //   ],
                    // ),
                    // RadarChart.light(
                    //   ticks: ticks,
                    //   features: features,
                    //   data: data,
                    //   reverseAxis: false,
                    //   useSides: true,
                    // ),

                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Image.asset("image/report (18).png"),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 64,
                            ),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height / 2.935,
                              child: RadarChart(
                                data: data,
                                ticks: ticks,
                                features: features,
                                reverseAxis: false,
                                outlineColor: Colors.transparent,
                                axisColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Center(child: Text('평균연령 $ageEra세 점수 ')),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        shrinkWrap: true,
                        children: _getBars(), // dynamic coding way
                        //hard coding way
                        // [
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('주의력'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: CON_SCORE / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$CON_SCORE"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.redAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$CON_SCORE_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   CON_SCORE_AVG <= CON_SCORE
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('시공간'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: SPACETIME_SCORE / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$SPACETIME_SCORE"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.orangeAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$SPACETIME_SCORE_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   SPACETIME_SCORE_AVG <= SPACETIME_SCORE
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('집행기능'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: EXEC_SCORE / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$EXEC_SCORE"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.yellowAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$EXEC_SCORE_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   EXEC_SCORE_AVG <= EXEC_SCORE
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('기억력'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: MEM_SCORE / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$MEM_SCORE"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.greenAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$MEM_SCORE_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   MEM_SCORE_AVG <= MEM_SCORE
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('언어기능'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: LING_SCORE / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$LING_SCORE"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.blueAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$LING_SCORE_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   LING_SCORE_AVG <= LING_SCORE
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('계산력'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: CAL_SCORE / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$CAL_SCORE"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.indigoAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$CAL_SCORE_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   CAL_SCORE_AVG <= CAL_SCORE
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('반응속도'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: REAC_SCORE / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$REAC_SCORE"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.purpleAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$REAC_SCORE_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   REAC_SCORE_AVG <= REAC_SCORE
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('지남력'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: ORIENT_SCORE / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$ORIENT_SCORE"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.greenAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$ORIENT_SCORE_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   ORIENT_SCORE_AVG <= ORIENT_SCORE
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('집중력'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: AVG_ATT / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$AVG_ATT"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.greenAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$AVG_ATT_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   AVG_ATT_AVG <= AVG_ATT
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text('안정감'),
                        //         Expanded(
                        //           child: LinearPercentIndicator(
                        //             animation: true,
                        //             lineHeight: 20.0,
                        //             animationDuration: 2000,
                        //             percent: AVG_MED / 100,
                        //             animateFromLastPercent: true,
                        //             center: Text("$AVG_MED"),
                        //             isRTL: false,
                        //             barRadius: Radius.elliptical(5, 15),
                        //             progressColor: Colors.greenAccent,
                        //             maskFilter:
                        //                 MaskFilter.blur(BlurStyle.solid, 3),
                        //           ),
                        //         ),
                        //         Text("$AVG_MED_AVG"),
                        //         Text('(평균연령 $ageEra)'),
                        //       ],
                        //     ),
                        //   ),
                        //   AVG_MED_AVG <= AVG_MED
                        //       ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        //       : Text('평균보다 점수가부족합니다. 강해지세요!'),
                        //   Divider(
                        //     thickness: 2.0,
                        //   ),
                        // ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _getBars() {
    List<Widget> data = [];
    List<MaterialAccentColor> color = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.indigoAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.greenAccent
    ];
    int index = 0;
    allData.forEach((key, value) {
      String higher = '평균보다 점수가 높으시군요. 훌륭합니다!';
      String smaller = '평균보다 점수가부족합니다. 강해지세요!';

      //according to key, you can edit text
      /*
      if(key == '주의력'){
        higher = '';
        smaller = '';
      }else if (key == '시공간'){
        higher = '';
        smaller = '';
      }
      */
      data.add(Container(
        constraints: BoxConstraints(
          maxHeight: double.infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("image/community (20).png"), // 여기에 배경 이미지 경로를 지정합니다.
            fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 7,
                      height: MediaQuery.of(context).size.width / 7,
                      child: Image.asset("image/report (${index + 26}).png")),
                  Expanded(
                    child: LinearPercentIndicator(
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: (value.first) / 100,
                      animateFromLastPercent: true,
                      center: Text("${value.first}"),
                      // user's one data
                      isRTL: false,
                      barRadius: Radius.elliptical(5, 15),
                      progressColor: color[index],
                      maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '  $key',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${value.last}(평균연령 $ageEra)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text('자세한 평가는 전문가가 직접 적어줄거에요',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value.last <= value.first ? higher : smaller,
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ));
      data.add(Divider(
        thickness: 2.0,
      ));

      index++;
    });
    return data;
  }
}
