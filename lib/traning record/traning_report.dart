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
          leading: IconButton(
            icon: Icon(Icons.arrow_circle_left_outlined,
                color: Colors.white, size: 35),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '훈련보고서',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold), // 글자색을 하얀색으로 설정
          ),
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
                        Text("${gql.userName} 님의 두뇌나이", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 400,
                              height: 320,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('image/report (25).png'),
                                ),
                              ),
                            ),
                            Text('${gql.userName} 님의 두뇌는 \'27세\' 입니다!',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Divider(
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        /*
                        Text("최근 훈련 참여도", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('영역별 성취도', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top1', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top2', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top3', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))],
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
                                Text('영역별 수행도', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top1', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top2', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [Text('Top3', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))],
                                )
                              ],
                            )
                          ],
                        ),
                        */
                        const SizedBox(
                          height: 10,
                        ),

                        Stack(
                          children: <Widget>[

                            Image.asset(
                              'image/report (17).png', // 이미지 경로
                              width: 400, // 필요에 따라 조절
                              height: 250, // 필요에 따라 조절
                              //fit: BoxFit.cover, // 이미지를 적절히 맞추거나 채움
                            ),


                            Column(
                                children: [
                                  const SizedBox(
                                    height: 65,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 65,
                                      ),
                                      Column(
                                        children: [
                                          Text(ORIENT_SCORE, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          //Text('지남력 점수'),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Column(
                                        children: [
                                          Text(CON_SCORE, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          //Text('주의력 점수'),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        children: [
                                          Text(SPACETIME_SCORE, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          //Text('시공간 점수'),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        children: [
                                          Text(EXEC_SCORE, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold) ),
                                          //Text('집행기능 점수'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 65,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 65,
                                      ),
                                      Column(
                                        children: [
                                          Text(MEM_SCORE, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          //Text('기억력 점수'),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 48,
                                      ),
                                      Column(
                                        children: [
                                          Text(LING_SCORE, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          //Text('언어기능 점수'),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        children: [
                                          Text(CAL_SCORE, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          //Text('계산력 점수'),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        children: [
                                          Text(REAC_SCORE, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                          //Text('반응속도 점수'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]
                            )

                    ]
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                    Stack(
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              const SizedBox(
                                width: 110,
                              ),

                              Image.asset(
                                'image/report (26).png', // 이미지 경로
                                width: 70, // 필요에 따라 조절
                                height: 70,
                                //fit: BoxFit.cover, // 이미지를 적절히 맞추거나 채움
                              ),


                              Image.asset(
                                'image/report (27).png', // 이미지 경로
                                width: 70, // 필요에 따라 조절
                                height: 70, // 필요에 따라 조절

                                //fit: BoxFit.cover, // 이미지를 적절히 맞추거나 채움
                              ),
                              const SizedBox(
                                width: 110,
                              ),

                            ]
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(AVG_ATT, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('집중력', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(
                              width: 35,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(AVG_MED, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('안정감', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        ]
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
                        Text("세부 결과 보기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10,
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 180.0, // 원하는 너비로 조절
                              height: 120.0, // 원하는 높이로 조절
                              child: IconButton(
                                icon: Image.asset('image/report (19).png'),
                                iconSize: 10.0, // 이 속성은 IconButton의 icon 파라미터가 Icon 위젯일 때 사용됩니다.
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AnalyzingReportPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 180.0, // 원하는 너비로 조절
                              height: 120.0, // 원하는 높이로 조절
                              child: IconButton(
                                icon: Image.asset('image/report (3).png'),
                                iconSize: 10.0, // 이 속성은 IconButton의 icon 파라미터가 Icon 위젯일 때 사용됩니다.
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BrainSignalPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
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
            backgroundImage: AssetImage('image/ui (14).png'),
            backgroundColor: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: bottomappbar);
  }
}
