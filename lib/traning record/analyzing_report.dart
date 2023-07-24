import 'dart:math';
import 'dart:core';

import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/models/ModelProvider.dart';
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
  bool darkMode = false;

  bool useSides = false;

  double numberOfFeatures = 3;

  List<String> users = [];
  var userbutton = '유저 데이터 추가';
  var brainbutton = '뇌파 데이터 추가';
  late final gql;
  int usercount = 0;
  int braincount = 0;

  String state = 'Animation start';
  bool isRunning = true;
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

  int CON_SCORE_AVG = 0; // 주의력 점수

  int SPACETIME_SCORE_AVG = 0; //시공간 점수

  int EXEC_SCORE_AVG = 0; //집행기능 점수

  int MEM_SCORE_AVG = 0; // 기억력 점수

  int LING_SCORE_AVG = 0; //언어기능 점수

  int CAL_SCORE_AVG = 0; //계산력 점수

  int REAC_SCORE_AVG = 0; //반응속도 점수

  int ORIENT_SCORE_AVG = 0; //지남력점수

  List<Future<dynamic?>> futuresList = [];
  int ageEra = 0;
  var month = 1;
  var year = 2023;

  @override
  void initState() {
    super.initState();
    gql = GraphQLController.Obj;
    gql.queryMonthlyDBItem().then((value) {
      setState(() {
        CON_SCORE = value!.con_score;
        SPACETIME_SCORE = value!.spacetime_score;
        EXEC_SCORE = value!.exec_score;
        MEM_SCORE = value!.mem_score;
        LING_SCORE = value!.ling_score;
        CAL_SCORE = value!.cal_score;
        REAC_SCORE = value!.reac_score;
        ORIENT_SCORE = value!.orient_score;
      });
    });
    month = DateTime.now().month;
    year = DateTime.now().year;
    extractSimilarAge();
    // gql.queryListMonthlyDBItems.then((dynamic) {
    //   print(dynamic);
    // });

    //   gql.queryListMonthlyDBItems().then((result) {
    //     print("here:$result");
    //   }).catchError((error) {
    //     print("error: $error");
    //   });
  }

  void extractSimilarAge() {
    users = [];
    String birth = "19651008";
    int year = int.parse(birth.substring(0, 4));
    int month = int.parse(birth.substring(4, 6));
    int day = int.parse(birth.substring(6, 8));
    DateTime birthday = DateTime(year, month, day);

    DateDuration duration;

    // Find out your age as of today's date 2021-03-08
    duration = AgeCalculator.age(birthday);
    int age = duration.years;
    print('Your age is ${age}'); // Your age is Years: 24, Months: 0, Days: 3

    setState(() {
      ageEra = ((duration.years ~/ 10) * 10);
    });

    int diff = age - ageEra;

    print(diff);

    int maxYear = (year + diff) * 10000;
    int minYear = (year - (9 - diff)) * 10000;
    print(minYear);
    print(maxYear);

    gql.queryListUserDBItems(minYear, maxYear).then((result) {
      // print(result);
      result.forEach((value) {
        // print("${value.id}");
        users.add(value.id);
      });
      calculateAverageSignal();
    }).catchError((error) {
      print(error);
    });
  }

  void calculateAverageSignal() async {
    futuresList = [];
    int CON_SCORE_SUM = 0; // 주의력 점수

    int SPACETIME_SCORE_SUM = 0; //시공간 점수

    int EXEC_SCORE_SUM = 0; //집행기능 점수

    int MEM_SCORE_SUM = 0; // 기억력 점수

    int LING_SCORE_SUM = 0; //언어기능 점수

    int CAL_SCORE_SUM = 0; //계산력 점수

    int REAC_SCORE_SUM = 0; //반응속도 점수

    int ORIENT_SCORE_SUM = 0; //지남력점수
    // String month = "20230701";
    // int monthint = int.parse(month.substring(0, 7));
    // monthint = monthint *10;
    int changeddate = year * 10000 + month * 100;

    print("monthint: $changeddate");

    int number = 0;
    users.forEach((id) async {
      // print(id);
      Future<dynamic?> future =
          gql.queryMonthlyDBSimilarAgeData(id, changeddate).then((value) {
        if (value != null) {
          number++;
          CON_SCORE_SUM += value.con_score as int;
          // CON_SCORE_AVG = (CON_SCORE_SUM ~/ number); //135/3= 45

          SPACETIME_SCORE_SUM += value.spacetime_score as int;
          // SPACETIME_SCORE_AVG = (SPACETIME_SCORE_SUM ~/ number);

          EXEC_SCORE_SUM += value.exec_score as int; //집행기능 점수
          // EXEC_SCORE_AVG = (EXEC_SCORE_SUM ~/ number);

          MEM_SCORE_SUM += value.mem_score as int; // 기억력 점수
          // MEM_SCORE_AVG = (MEM_SCORE_SUM ~/ number);

          LING_SCORE_SUM += value.ling_score as int; //언어기능 점수
          // LING_SCORE_AVG = (LING_SCORE_SUM ~/ number);

          CAL_SCORE_SUM += value.cal_score as int; //계산력 점수
          // CAL_SCORE_AVG = (CAL_SCORE_SUM ~/ number);

          REAC_SCORE_SUM += value.reac_score as int; //반응속도 점수
          // REAC_SCORE_AVG = (REAC_SCORE_SUM ~/ number);

          ORIENT_SCORE_SUM += value.orient_score as int; //지남력점수
          // ORIENT_SCORE_AVG = (ORIENT_SCORE_SUM ~/ number);

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
      if (number > 0) {
        CON_SCORE_AVG = (CON_SCORE_SUM ~/ number); //135/3= 45

        SPACETIME_SCORE_AVG = (SPACETIME_SCORE_SUM ~/ number);

        EXEC_SCORE_AVG = (EXEC_SCORE_SUM ~/ number);

        MEM_SCORE_AVG = (MEM_SCORE_SUM ~/ number);

        LING_SCORE_AVG = (LING_SCORE_SUM ~/ number); //언어기능 점수

        CAL_SCORE_AVG = (CAL_SCORE_SUM ~/ number); //계산력 점수

        REAC_SCORE_AVG = (REAC_SCORE_SUM ~/ number); //반응속도 점수

        ORIENT_SCORE_AVG = (ORIENT_SCORE_SUM ~/ number);
      } else {
        CON_SCORE_AVG = 0; //135/3= 45

        SPACETIME_SCORE_AVG = 0;

        EXEC_SCORE_AVG = 0;

        MEM_SCORE_AVG = 0;

        LING_SCORE_AVG = 0; //언어기능 점수

        CAL_SCORE_AVG = 0; //계산력 점수

        REAC_SCORE_AVG = 0; //반응속도 점수

        ORIENT_SCORE_AVG = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);

    const ticks = [20, 40, 60, 80, 100];
    var features = [
      "주의력($CON_SCORE)",
      "시공간($SPACETIME_SCORE)",
      "집행기능($EXEC_SCORE)",
      "기억력($MEM_SCORE)",
      "언어기능($LING_SCORE)",
      "계산력($CAL_SCORE)",
      "반응속도($REAC_SCORE)",
      "지남력($ORIENT_SCORE)"
    ];
    var data = [
      [
        CON_SCORE,
        SPACETIME_SCORE,
        EXEC_SCORE,
        MEM_SCORE,
        LING_SCORE,
        CAL_SCORE,
        REAC_SCORE,
        ORIENT_SCORE
      ]
    ];

    // features = features.sublist(0, numberOfFeatures.floor());
    // data = data
    //     .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
    //     .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('분석 보고서'),
        centerTitle: true,
      ),
      body: Container(
        color: darkMode ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: DropdownDatePicker(
                      inputDecoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      // optional
                      isDropdownHideUnderline: true,
                      // optional
                      isFormValidator: true,
                      // optional
                      startYear: 2022,
                      // optional
                      endYear: 2030,
                      // optional
                      width: 10,
                      // optional
                      locale: "ko",
                      // selectedDay: 14, // optional
                      showDay: false,
                      selectedMonth: month,
                      // optional
                      selectedYear: year,
                      // optional
                      // onChangedDay: (value) => print('onChangedDay: $value'),
                      onChangedMonth: (value) {
                        print('onChangedMonth: $value');
                        month = int.parse(value!);
                      },
                      onChangedYear: (value) {
                        print('onChangedYear: $value');
                        year = int.parse(value!);
                      },
                      //boxDecoration: BoxDecoration(
                      // border: Border.all(color: Colors.grey, width: 1.0)), // optional
                      // showDay: false,// optional
                      // dayFlex: 2,// optional
                      // locale: "zh_CN",// optional
                      // hintDay: 'Day', // optional
                      // hintMonth: 'Month', // optional
                      // hintYear: 'Year', // optional
                      // hintTextStyle: TextStyle(color: Colors.grey), // optional
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        calculateAverageSignal();
                      },
                      icon: Icon(Icons.search))
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      await gql.createUserData();
                      setState(() {
                        usercount++;
                        userbutton = "$usercount번 추가";
                      });
                    },
                    child: Text(userbutton),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () async {
                      await gql.createMonthlyData();
                      setState(() {
                        braincount++;
                        brainbutton = "$braincount번 추가";
                      });
                    },
                    child: Text(brainbutton),
                  ),
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       darkMode
              //           ? Text(
              //               'Light mode',
              //               style: TextStyle(color: Colors.white),
              //             )
              //           : Text(
              //               'Dark mode',
              //               style: TextStyle(color: Colors.black),
              //             ),
              //       Switch(
              //         value: this.darkMode,
              //         onChanged: (value) {
              //           setState(() {
              //             darkMode = value;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       useSides
              //           ? Text(
              //               'Polygon border',
              //               style: darkMode
              //                   ? TextStyle(color: Colors.white)
              //                   : TextStyle(color: Colors.black),
              //             )
              //           : Text(
              //               'Circular border',
              //               style: darkMode
              //                   ? TextStyle(color: Colors.white)
              //                   : TextStyle(color: Colors.black),
              //             ),
              //       Switch(
              //         value: this.useSides,
              //         onChanged: (value) {
              //           setState(() {
              //             useSides = value;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: <Widget>[
              //       Text(
              //         'Number of features',
              //         style: TextStyle(
              //             color: darkMode ? Colors.white : Colors.black),
              //       ),
              //       Expanded(
              //         child: Slider(
              //           value: this.numberOfFeatures,
              //           min: 3,
              //           max: 8,
              //           divisions: 5,
              //           onChanged: (value) {
              //             setState(() {
              //               numberOfFeatures = value;
              //             });
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.zero,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: RadarChart.light(
                    ticks: ticks,
                    features: features,
                    data: data,
                    reverseAxis: false,
                    useSides: true,
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  shrinkWrap: true,
                  children: [
                    Center(child: Text('평균연령 $ageEra세 점수 ')),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('주의력'),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 1.35,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: CON_SCORE_AVG / 100,
                            animateFromLastPercent: true,
                            center: Text("$CON_SCORE_AVG"),
                            isRTL: false,
                            barRadius: Radius.elliptical(5, 15),
                            progressColor: Colors.redAccent,
                            maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          ),
                        ],
                      ),
                    ),
                    CON_SCORE_AVG <= CON_SCORE
                        ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        : Text('평균보다 점수가부족합니다. 강해지세요!'),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('시공간'),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 1.35,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: SPACETIME_SCORE_AVG / 100,
                            animateFromLastPercent: true,
                            center: Text("$SPACETIME_SCORE_AVG"),
                            isRTL: false,
                            barRadius: Radius.elliptical(5, 15),
                            progressColor: Colors.orangeAccent,
                            maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          ),
                        ],
                      ),
                    ),
                    SPACETIME_SCORE_AVG <= SPACETIME_SCORE
                        ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        : Text('평균보다 점수가부족합니다. 강해지세요!'),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('집행기능'),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 1.35,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: EXEC_SCORE_AVG / 100,
                            animateFromLastPercent: true,
                            center: Text("$EXEC_SCORE_AVG"),
                            isRTL: false,
                            barRadius: Radius.elliptical(5, 15),
                            progressColor: Colors.yellowAccent,
                            maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          ),
                        ],
                      ),
                    ),
                    EXEC_SCORE_AVG <= EXEC_SCORE
                        ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        : Text('평균보다 점수가부족합니다. 강해지세요!'),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('기억력'),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 1.35,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: MEM_SCORE_AVG / 100,
                            animateFromLastPercent: true,
                            center: Text("$MEM_SCORE_AVG"),
                            isRTL: false,
                            barRadius: Radius.elliptical(5, 15),
                            progressColor: Colors.greenAccent,
                            maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          ),
                        ],
                      ),
                    ),
                    MEM_SCORE_AVG <= MEM_SCORE
                        ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        : Text('평균보다 점수가부족합니다. 강해지세요!'),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('언어기능'),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 1.35,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: LING_SCORE_AVG / 100,
                            animateFromLastPercent: true,
                            center: Text("$LING_SCORE_AVG"),
                            isRTL: false,
                            barRadius: Radius.elliptical(5, 15),
                            progressColor: Colors.blueAccent,
                            maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          ),
                        ],
                      ),
                    ),
                    LING_SCORE_AVG <= LING_SCORE
                        ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        : Text('평균보다 점수가부족합니다. 강해지세요!'),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('계산력'),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 1.35,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: CAL_SCORE_AVG / 100,
                            animateFromLastPercent: true,
                            center: Text("$CAL_SCORE_AVG"),
                            isRTL: false,
                            barRadius: Radius.elliptical(5, 15),
                            progressColor: Colors.indigoAccent,
                            maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          ),
                        ],
                      ),
                    ),
                    CAL_SCORE_AVG <= CAL_SCORE
                        ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        : Text('평균보다 점수가부족합니다. 강해지세요!'),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('반응속도'),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 1.35,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: REAC_SCORE_AVG / 100,
                            animateFromLastPercent: true,
                            center: Text("$REAC_SCORE_AVG"),
                            isRTL: false,
                            barRadius: Radius.elliptical(5, 15),
                            progressColor: Colors.purpleAccent,
                            maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          ),
                        ],
                      ),
                    ),
                    REAC_SCORE_AVG <= REAC_SCORE
                        ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        : Text('평균보다 점수가부족합니다. 강해지세요!'),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('지남력'),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width / 1.35,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: ORIENT_SCORE_AVG / 100,
                            animateFromLastPercent: true,
                            center: Text("$ORIENT_SCORE_AVG"),
                            isRTL: false,
                            barRadius: Radius.elliptical(5, 15),
                            progressColor: Colors.greenAccent,
                            maskFilter: MaskFilter.blur(BlurStyle.solid, 3),
                          ),
                        ],
                      ),
                    ),
                    ORIENT_SCORE_AVG <= ORIENT_SCORE
                        ? Text('평균보다 점수가 높으시군요. 훌륭합니다!')
                        : Text('평균보다 점수가부족합니다. 강해지세요!'),
                    Divider(
                      thickness: 2.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
