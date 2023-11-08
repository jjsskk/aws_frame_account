import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_account/drawer/drawer.dart';
import 'package:aws_frame_account/bottomappbar/globalkey.dart';
import 'package:aws_frame_account/provider/login_state.dart';
import 'package:aws_frame_account/traning%20record/analyzing_report.dart';
import 'package:aws_frame_account/traning%20record/brain_signal_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class TraningReportPage extends StatefulWidget {
  TraningReportPage({Key? key}) : super(key: key);

  @override
  State<TraningReportPage> createState() => _TraningReportPageState();
}

class _TraningReportPageState extends State<TraningReportPage> {
  String CON_SCORE = '';

  // 주의력 점수
  String SPACETIME_SCORE = '';

  //시공간 점수
  String EXEC_SCORE = '';

  //집행기능 점수
  String MEM_SCORE = '';

  // 기억력 점수
  String LING_SCORE = '';

  //언어기능 점수
  String CAL_SCORE = '';

  //계산력 점수
  String REAC_SCORE = '';

  //반응속도 점수
  String ORIENT_SCORE = '';

  String AVG_ATT = '';

  //평균 집중력

  String AVG_MED = '';

  //평균 안정감

  //지남력
  late var appState;

  //지남력점수
  late final gql;
  late final bottomappbar;
  late final keyObj;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    keyObj = KeyForBottomAppbar();
    bottomappbar = GlobalBottomAppBar(keyObj: keyObj);

    gql = GraphQLController.Obj;
    gql.queryMonthlyDBItem().then((value) {
      setState(() {
        CON_SCORE = "${value!.con_score}";
        SPACETIME_SCORE = "${value!.spacetime_score}";
        EXEC_SCORE = "${value!.exec_score}";
        MEM_SCORE = "${value!.mem_score}";
        LING_SCORE = "${value!.ling_score}";
        CAL_SCORE = "${value!.cal_score}";
        REAC_SCORE = "${value!.reac_score}";
        ORIENT_SCORE = "${value!.orient_score}";
        AVG_ATT = "${value!.avg_att}";
        AVG_MED = "${value!.avg_med}";
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<LoginState>();

    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
        key: keyObj.key,
        drawer: GlobalDrawer.getDrawer(context, appState),
        appBar: AppBar(
            title: Text('훈련보고서'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            )
            ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text("${gql.userName}님의 두뇌나이"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              child: CircleAvatar(
                                backgroundImage: AssetImage('image/brain.jpg'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('${appState.userName}의 두뇌 \n나이는 10세!')
                          ],
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("최근 훈련 참여도"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('영역별 성취도'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top1')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top2')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top3')],
                                )
                              ],
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height / 5,
                                child: VerticalDivider(
                                  thickness: 2.0,
                                  width: 20,
                                  endIndent: 0,
                                  indent: 20,
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('영역별 수행도'),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top1')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top2')],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top3')],
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("영역별 평균 점수"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(CON_SCORE),
                                Text('주의력 점수'),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(SPACETIME_SCORE),
                                Text('시공간 점수'),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(EXEC_SCORE),
                                Text('집행기능 점수'),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(MEM_SCORE),
                                Text('기억력 점수'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(LING_SCORE),
                                Text('언어기능 점수'),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(CAL_SCORE),
                                Text('계산력 점수'),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(REAC_SCORE),
                                Text('반응속도 점수'),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(ORIENT_SCORE),
                                Text('지남력 점수'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(AVG_ATT),
                                Text('집중력 점수'),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(AVG_MED),
                                Text('안정감 점수'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("세부 결과 그래프"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AnalyzingReportPage()),
                                  );
                                },
                                icon: Icon(Icons.analytics),
                                label: Text('분석 보고서')),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BrainSignalPage()),
                                  );
                                },
                                icon: Icon(Icons.graphic_eq),
                                label: Text('뇌 신호 그래프')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Create',
          child: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('image/frame.png'),
            backgroundColor: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: bottomappbar);
  }
}
