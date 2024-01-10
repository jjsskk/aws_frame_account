import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/backey/backKey_dialog.dart';
import 'package:aws_frame_account/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_account/communication_service/communication_yard.dart';
import 'package:aws_frame_account/drawer/drawer.dart';
import 'package:aws_frame_account/bottomappbar/globalkey.dart';
import 'package:aws_frame_account/home/hompage_linechart.dart';
import 'package:aws_frame_account/loading_page/loading_page.dart';
import 'package:aws_frame_account/login_session.dart';
import 'package:aws_frame_account/provider/login_state.dart';
import 'package:aws_frame_account/traning%20record/traning_report.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key,
      required this.shouldLogOut})
      : super(key: key);

  // final VoidCallback didtogglegraph;
  final VoidCallback shouldLogOut;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final iconColor = Colors.white;

  late final bottomappbar;
  late final keyObj;
  late var appState;
  final gql = GraphQLController.Obj;

  bool loading_User = true;
  bool loading_Brain = true;

  var latestdata = [];
  int max = 0; // the most elevated value
  String nameForMax = ''; //the most elevated data name
  Map<int, int> dataForCamparing = {};

  // bool checkAttribute = false; //  to call getProtectorAttributes() once

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backKeyInterceptor,
        context: context); // for back key
    keyObj = KeyForBottomAppbar();
    bottomappbar = GlobalBottomAppBar(keyObj: keyObj);
    getProtectorAttributes();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backKeyInterceptor);
    super.dispose();
  }

  void getProtectorAttributes() async {
    try {
      // checkAttribute = true;
      var attribute = await Amplify.Auth.fetchUserAttributes();
      attribute.forEach((element) {
        if (element.userAttributeKey.key == "name")
          setState(() {
            // username = element.value;
            gql.protectorName = (element.value) ?? "no result";
          });

        if (element.userAttributeKey.key == "phone_number")
          setState(() {
            // userphonenumber = element.value;
            gql.protectorPhonenumber = (element.value) ?? " no result";
          });

        if (element.userAttributeKey.key == "email")
          setState(() {
            // useremail = element.value;
            gql.protectorEmail = (element.value) ?? "no result";
            // loading = false;
          });

        if (element.userAttributeKey.key.toLowerCase() ==
            "custom:institutionNumber".toLowerCase())
          setState(() {
            // useremail = element.value;
            gql.institutionNumber = (element.value) ?? "no result";
          });

        if (element.userAttributeKey.key.toLowerCase() ==
            "custom:userNumber".toLowerCase())
          setState(() {
            // useremail = element.value;
            gql.userNumber = (element.value) ?? "no result";
            getUserData(element.value);
            getMonthlyDBComparingData();
            print(attribute.toString());
          });
      });
    } catch (e) {
      print("error : $e");
    }
  }

  void getUserData(String id) async {
    final data = gql.queryUserDBItem(id).then((value) {
      // gql.userId = value.ID;
      gql.userBirth = "${value.BIRTH}";
      gql.userName = value.NAME;
      print("value : $value");
      setState(() {
        loading_User = false;
      });
    });
    // futuresList.add(data);
    // await Future.wait(futuresList);
    // setState(() {
    //   loading = false;
    // });
  }

  void getMonthlyDBComparingData() async {
    // gql.queryMonthlyDBLatestTwoItems().then((value) { // already sorted two data fetched using query
    gql.queryMonthlyDBLatestItem().then((values) {
      print("values: $values");
      if (values.isNotEmpty) {
        values.sort((a, b) {
          String aa = a.month;

          String bb = b.month;
          return bb.compareTo(aa);
        });
      }
      var value = [];
      if (values.length > 1) value = values.sublist(0, 2);
      print("sort: $value");
      if (value.length == 2) {
        latestdata = value.sublist(value.length - 2);
        print("here :$latestdata");
        Map<String, List<int>> diff = {};
        diff['주의력 점수'] = [
          latestdata.first.con_score - latestdata.last.con_score,
          latestdata.last.con_score,
          latestdata.first.con_score
        ];

        diff['시공간 점수'] = [
          latestdata.first.spacetime_score - latestdata.last.spacetime_score,
          latestdata.last.spacetime_score,
          latestdata.first.spacetime_score
        ];

        diff['집행기능 점수'] = [
          latestdata.first.exec_score - latestdata.last.con_score,
          latestdata.last.con_score,
          latestdata.first.exec_score
        ];

        diff['기억력 점수'] = [
          latestdata.first.mem_score - latestdata.last.mem_score,
          latestdata.last.mem_score,
          latestdata.first.mem_score
        ];

        diff['언어기능 점수'] = [
          latestdata.first.ling_score - latestdata.last.ling_score,
          latestdata.last.ling_score,
          latestdata.first.ling_score
        ];

        diff['계산력 점수'] = [
          latestdata.first.cal_score - latestdata.last.cal_score,
          latestdata.last.cal_score,
          latestdata.first.cal_score
        ];

        diff['반응속도 점수'] = [
          latestdata.first.reac_score - latestdata.last.reac_score,
          latestdata.last.reac_score,
          latestdata.first.reac_score
        ];

        diff['지남력 점수'] = [
          latestdata.first.orient_score - latestdata.last.orient_score,
          latestdata.last.orient_score,
          latestdata.first.orient_score
        ];

        diff['집중력 점수 '] = [
          latestdata.first.avg_att - latestdata.last.avg_att,
          latestdata.last.avg_att,
          latestdata.first.avg_att
        ];

        diff['안정감 점수'] = [
          latestdata.first.avg_med - latestdata.last.avg_med,
          latestdata.last.avg_med,
          latestdata.first.avg_med
        ];

        diff.forEach((key, value) {
          if (max < value[0]) {
            max = value[0];
            nameForMax = key;
            dataForCamparing[int.parse(latestdata.last.month.substring(4, 6))] =
                value[1];
            dataForCamparing[
                int.parse(latestdata.first.month.substring(4, 6))] = value[2];
          }
        });

        print("max : $nameForMax");
      } else
        max = -1;
      setState(() {
        loading_Brain = false;
      });
    });
  }

  // In this app, back key default function make app terminated, not page poped because of Navigator() in main page and login_sesssion page
  Future<bool> backKeyInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON! "); // Do some stuff.
    if (stopDefaultButtonEvent) return Future(() => true); // prevent

    // If a dialog (or any other route) is open, don't run the interceptor.
    // return type is true -> run interceptor and return type is false -> don't run the interceptor( back key defaut function work)
    if (info.ifRouteChanged(context)) {
      Navigator.of(context).pop();
      return Future(() => true);
    }
    return GlobalBackKeyDialog.getBackKeyDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    appState = context.watch<LoginState>();

    return (loading_User || loading_Brain)
        ? LoadingPage()
        : Scaffold(
            drawer: GlobalDrawer.getDrawer(context, appState),
            key: keyObj.key,
            appBar: AppBar(
              title: Text(
                ' ${gql.userName}님의 동반자 ${gql.protectorName}님 안녕하세요!',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: iconColor),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
                    fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    color: iconColor,
                    Icons.logout,
                    semanticLabel: 'logout',
                  ),
                  onPressed: widget.shouldLogOut,
                ),
              ],
              automaticallyImplyLeading:
                  false, // -> important to making top drawer button not visible while keeping drawer function in scaffold
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage("image/ui (3).png"), // 여기에 배경 이미지 경로를 지정합니다.
                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Text('${gql.userName} 님의 훈련 데이터',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 4,
                      ),
                      // GraphPage(),
                      max > 0
                          ? Linechart(
                              data: dataForCamparing,
                              dataName: nameForMax,
                            )
                          : SizedBox(
                              // 비교 데이터가 없거나 상승 데이터가 없을 떄 차트 대신 나올 asset으로 꾸미면 좋을듯
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      max > 0
                          ? Text('지난달보다 $nameForMax $max 상승!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                          : Text('지난달보다 상승된 데이터가 없습니다ㅠㅠ!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width, // 원하는 너비로 조절
                        child: IconButton(
                          icon: Image.asset('image/mainmenu (8).png'),
                          iconSize: 40.0,
                          // 이 속성은 IconButton의 icon 파라미터가 Icon 위젯일 때 사용됩니다.
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TraningReportPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: MediaQuery.of(context).size.width /
                                3, // 원하는 너비로 조절
                            child: IconButton(
                              icon: Image.asset('image/mainmenu (1).png'),
                              iconSize: 10.0,
                              // 이 속성은 IconButton의 icon 파라미터가 Icon 위젯일 때 사용됩니다.
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CommunicationYardPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width /
                                2.2, // 원하는 너비로 조절
                            height: MediaQuery.of(context).size.width /
                                3, // 원하는 너비로 조절
                            child: IconButton(
                              icon: Image.asset('image/mainmenu (7).png'),
                              iconSize: 10.0,
                              // 이 속성은 IconButton의 icon 파라미터가 Icon 위젯일 때 사용됩니다.
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CommunicationYardPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // Expanded(
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         const SizedBox(
                      //           width: 1,
                      //         ),
                      //         IconButton(
                      //           onPressed: () {
                      //             _key.currentState!.openDrawer();
                      //           },
                      //           icon: Icon(
                      //             Icons.menu,
                      //             color: colorScheme.primary,
                      //             size: 30,
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           width: 5,
                      //         ),
                      //         const SizedBox(
                      //           width: 5,
                      //         ),
                      //         IconButton(
                      //           onPressed: () {},
                      //           icon: Icon(
                      //             Icons.adjust,
                      //             color: colorScheme.primary,
                      //             size: 30,
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           width: 1,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  )),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              tooltip: 'Create',
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('image/ui (14).png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: bottomappbar);
  }
}
