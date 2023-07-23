import 'dart:math';

import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:flutter/material.dart';
import 'package:spider_chart/spider_chart.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:age_calculator/age_calculator.dart';

class AnalyzingReportPage extends StatefulWidget {
  const AnalyzingReportPage({Key? key}) : super(key: key);

  @override
  State<AnalyzingReportPage> createState() => _AnalyzingReportPageState();
}

class _AnalyzingReportPageState extends State<AnalyzingReportPage> {
  bool darkMode = false;

  bool useSides = false;

  double numberOfFeatures = 3;

  var userbutton = '유저 데이터 추가';
  var brainbutton = '뇌파 데이터 추가';
  late final gql;
  int usercount = 0;
  int braincount = 0;

  @override
  void initState() {
    super.initState();
    gql = GraphQLController.Obj;
    // gql.queryListMonthlyDBItems.then((dynamic) {
    //   print(dynamic);
    // });

    gql.queryListMonthlyDBItems().then((result) {
      print(result);
    }).catchError((error) {
      print(error);
    });

    DateTime birthday = DateTime(1965, 10, 8);

    DateDuration duration;

    // Find out your age as of today's date 2021-03-08
    duration = AgeCalculator.age(birthday);
    print(
        'Your age is ${duration.years}'); // Your age is Years: 24, Months: 0, Days: 3
    double age = ((duration.years ~/ 10) * 10);
    print(age);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);

    const ticks = [7, 14, 21, 28, 35];
    var features = ["AA(3)", "BB", "CC(3)", "DD", "EE", "FF", "GG", "HH"];
    var data = [
      [10.0, 20, 28, 5, 16, 15, 17, 6],
      [14.5, 1, 4, 14, 23, 10, 6, 19]
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
      body: Center(
        child: Container(
          color: darkMode ? Colors.black : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    useSides
                        ? Text(
                            'Polygon border',
                            style: darkMode
                                ? TextStyle(color: Colors.white)
                                : TextStyle(color: Colors.black),
                          )
                        : Text(
                            'Circular border',
                            style: darkMode
                                ? TextStyle(color: Colors.white)
                                : TextStyle(color: Colors.black),
                          ),
                    Switch(
                      value: this.useSides,
                      onChanged: (value) {
                        setState(() {
                          useSides = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
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
              Expanded(
                child: darkMode
                    ? RadarChart.dark(
                        ticks: ticks,
                        features: features,
                        data: data,
                        reverseAxis: false,
                        useSides: useSides,
                      )
                    : RadarChart.light(
                        ticks: ticks,
                        features: features,
                        data: data,
                        reverseAxis: true,
                        useSides: useSides,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
