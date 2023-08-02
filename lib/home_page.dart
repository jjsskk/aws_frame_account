import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_account/camera_gallary/graph_page.dart';
import 'package:aws_frame_account/communication_service/communication_yard.dart';
import 'package:aws_frame_account/drawer/drawer.dart';
import 'package:aws_frame_account/globalkey.dart';
import 'package:aws_frame_account/linechart.dart';
import 'package:aws_frame_account/loadingpage.dart';
import 'package:aws_frame_account/login_session.dart';
import 'package:aws_frame_account/mainpage/mainpage.dart';
import 'package:aws_frame_account/provider_login/login_state.dart';
import 'package:aws_frame_account/traning%20record/traning_report.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'communication_service/communication_service.dart';
import 'protector_service/protector_service.dart';
import 'traning record/record_manage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key,
      required this.didtogglegallery,
      // required this.didtogglegraph,
      required this.pickedimageurl,
      required this.shouldLogOut})
      : super(key: key);
  final VoidCallback didtogglegallery;

  // final VoidCallback didtogglegraph;
  final VoidCallback shouldLogOut;
  String pickedimageurl = '';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String useremail = '';
  // String username = '';
  // String userphonenumber = '';

  // final GlobalKey<ScaffoldState> _key = GlobalKey();

  late final bottomappbar;
  late final keyObj;
  late var appState;
  final gql = GraphQLController.Obj;
  bool loading_User = true;
  bool loading_Brain = true;
  List<Future<dynamic?>> futuresList = [];
  var latestdata = [];
  int max = 0;
  String nameForMax = '';
  Map<int, int> dataForCamparing = {};

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backKeyInterceptor, context: context);// for back key
    keyObj = KeyForBottomAppbar();
    bottomappbar = GlobalBottomAppBar(keyObj: keyObj);
  }

  bool checkAttribute = false;

  @override
  void dispose() {
    BackButtonInterceptor.remove(backKeyInterceptor);
    super.dispose();
  }


  void getProtectorAttributes() async {
    try {
      // var result = await Amplify.Auth.fetchAuthSession();
      //   while(!(result.isSignedIn)){
      //   print("here: ${result.isSignedIn}");
      //   result = await Amplify.Auth.fetchAuthSession();
      // }
      //   await  Future.delayed(const Duration(milliseconds: 5000));
      checkAttribute = true;
      var attribute = await Amplify.Auth.fetchUserAttributes();
      attribute.forEach((element) {
        if (element.userAttributeKey.key == "name")
          setState(() {
            // username = element.value;
            appState.protectorName = (element.value) ?? "no result";
          });

        if (element.userAttributeKey.key == "phone_number")
          setState(() {
            // userphonenumber = element.value;
            appState.protectorPhonenumber = (element.value) ?? " no result";
          });

        if (element.userAttributeKey.key == "email")
          setState(() {
            // useremail = element.value;
            appState.protectorEmail = (element.value) ?? "no result";
            // loading = false;
          });

        if (element.userAttributeKey.key.toLowerCase() ==
            "custom:institutionNumber".toLowerCase())
          setState(() {
            // useremail = element.value;
            appState.institutionNumber = (element.value) ?? "no result";
          });

        if (element.userAttributeKey.key.toLowerCase() ==
            "custom:userNumber".toLowerCase())
          setState(() {
            // useremail = element.value;
            appState.userNumber = (element.value) ?? "no result";
            getUserData(element.value);
            getMonthlyDBData(element.value);
            print(attribute.toString());
          });
      });
    } catch (e) {
      print("error : $e");
    }
  }

  void getUserData(String id) async {
    final data = gql.queryUserDBItem(id).then((value) {
      appState.userId = value.id;
      appState.userBirth = "${value.birth}";
      appState.userName = value.name;
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

  void getMonthlyDBData(String id) async {
    final data =
        gql.queryMonthlyDBTwoItems(int.parse("20240201")).then((value) {
      // print("value: $value");

      value.sort((a, b) {
        var aa = int.parse(a.month);
        var bb = int.parse(b.month);
        return aa.compareTo(bb);
      });
      latestdata = value.sublist(value.length - 2);
      print("here :$latestdata");
      Map<String, List<int>> diff = {};
      diff['주의력 점수'] = [
        latestdata.last.con_score - latestdata.first.con_score,
        latestdata.first.con_score,
        latestdata.last.con_score
      ];

      diff['시공간 점수'] = [
        latestdata.last.spacetime_score - latestdata.first.spacetime_score,
        latestdata.first.spacetime_score,
        latestdata.last.spacetime_score
      ];

      diff['집행기능 점수'] = [
        latestdata.last.exec_score - latestdata.first.con_score,
        latestdata.first.con_score,
        latestdata.last.exec_score
      ];

      diff['기억력 점수'] = [
        latestdata.last.mem_score - latestdata.first.mem_score,
        latestdata.first.mem_score,
        latestdata.last.mem_score
      ];

      diff['언어기능 점수'] = [
        latestdata.last.ling_score - latestdata.first.ling_score,
        latestdata.first.ling_score,
        latestdata.last.ling_score
      ];

      diff['계산력 점수'] = [
        latestdata.last.cal_score - latestdata.first.cal_score,
        latestdata.first.cal_score,
        latestdata.last.cal_score
      ];

      diff['반응속도 점수'] = [
        latestdata.last.reac_score - latestdata.first.reac_score,
        latestdata.first.reac_score,
        latestdata.last.reac_score
      ];

      diff['지남력 점수'] = [
        latestdata.last.orient_score - latestdata.first.orient_score,
        latestdata.first.orient_score,
        latestdata.last.orient_score
      ];

      diff['집중력 점수 '] = [
        latestdata.last.avg_att - latestdata.first.avg_att,
        latestdata.first.avg_att,
        latestdata.last.avg_att
      ];

      diff['안정감 점수'] = [
        latestdata.last.avg_med - latestdata.first.avg_med,
        latestdata.first.avg_med,
        latestdata.last.avg_med
      ];

      diff.forEach((key, value) {
        if (max < value.first) {
          max = value.first;
          nameForMax = key;
          dataForCamparing[int.parse(latestdata.first.month.substring(4, 6))] = value[1];
          dataForCamparing[int.parse(latestdata.last.month.substring(4, 6))] = value[2];
        }
      });

      print("max : $nameForMax");
      setState(() {
        loading_Brain = false;
      });
    });
  }

  Future<bool> _onBackKey() async {
    return await showDialog(
            context: context,
            useRootNavigator: false,
            // without this, info.ifRouteChanged(context) dont recognize context change. check page stack
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('끝내겠습니까?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('네')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('아니요'))
                ],
              );
            }) ??
        Future(() => true);
  }

  // In this app, back key default function make app terminated, not page poped because of Navigator() in main page and login_sesssion page
  Future<bool> backKeyInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    if (stopDefaultButtonEvent) return Future(() => true); // prevent

    // If a dialog (or any other route) is open, don't run the interceptor.
    // return type is true -> run interceptor and return type is false -> don't run the interceptor( back key defaut function work)
    if (info.ifRouteChanged(context)) {
      Navigator.of(context).pop();
      return Future(() => true);
    }
    return _onBackKey();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    appState = context.watch<LoginState>();

    if (!checkAttribute) getProtectorAttributes();

    return (loading_User || loading_Brain)
        ? LoadingPage()
        : Scaffold(
            drawer: GlobalDrawer.getDrawer(context, appState),
            key: keyObj.key,
            appBar: AppBar(
              title: Text(
                '${appState.userName}님의 동반자 ${appState.protectorName}님 안녕하세요',
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    semanticLabel: 'logout',
                  ),
                  onPressed: widget.shouldLogOut,
                ),
              ],
              automaticallyImplyLeading:
                  false, // -> important to making top drawer button not visible while keeping drawer function in scaffold
            ),
            body: Center(
                child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text('${appState.userName}님 훈련 데이터'),
                          const SizedBox(
                            height: 10,
                          ),
                          // GraphPage(),
                          Linechart(
                            data: dataForCamparing,
                            dataName: nameForMax,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          max > 0
                              ? Text(
                                  '${appState.userName}님 지난달보다 $nameForMax $max 상승!')
                              : Text(
                                  '${appState.userName}님 지난달보다 상승된 데이터가 없습니다ㅠㅠ!'),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TraningReportPage()),
                                );
                              },
                              child: Text('훈련결과 보러가기')),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.accessibility_new_rounded),
                                  label: Text('오늘의 활동기록')),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CommunicationYardPage()),
                                    );
                                  },
                                  icon: Icon(Icons.account_box),
                                  label: Text('소통마당')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              tooltip: 'Create',
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('image/frame.png'),
                backgroundColor: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: bottomappbar);
  }
}
