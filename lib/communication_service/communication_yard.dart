import 'package:aws_frame_account/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_account/communication_service/comment/comment_view.dart';
import 'package:aws_frame_account/communication_service/instituition_info/essential_care_information.dart';
import 'package:aws_frame_account/communication_service/instituition_info/institution_information.dart';
import 'package:aws_frame_account/communication_service/user_activity.dart';
import 'package:aws_frame_account/communication_service/user_care_information.dart';
import 'package:aws_frame_account/drawer/drawer.dart';
import 'package:aws_frame_account/bottomappbar/globalkey.dart';
import 'package:aws_frame_account/provider/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunicationYardPage extends StatefulWidget {
  CommunicationYardPage({Key? key}) : super(key: key);

  @override
  State<CommunicationYardPage> createState() => _CommunicationYardPageState();
}

class _CommunicationYardPageState extends State<CommunicationYardPage> {
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  late final bottomappbar;
  late final keyObj;
  @override
  void initState() {
    super.initState();
    keyObj = KeyForBottomAppbar();
    bottomappbar = GlobalBottomAppBar(keyObj: keyObj);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<LoginState>();
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      drawer: GlobalDrawer.getDrawer(context, appState),
      key: keyObj.key,
      appBar: AppBar(
          title: Text('소통마당',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
                fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EssentialCareInfoPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // 내부 여백을 제거합니다.
                      ),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Column의 크기를 자식의 크기에 맞춤
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        children: <Widget>[
                          Image.asset(
                            'image/community (2).png',
                            width: 120,
                            height: 120,
                          ), // 아이콘
                          Text('이용자 돌봄 정보',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)), // 텍스트
                        ],
                      ),
                    )),
                    Container(
                      width: 1.0, // Width of the vertical divider
                      color: colorScheme.primary,
                    ),
                    Expanded(
                        child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserActivityPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // 내부 여백을 제거합니다.
                      ),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Column의 크기를 자식의 크기에 맞춤
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        children: <Widget>[
                          Image.asset(
                            'image/community (8).png',
                            width: 120,
                            height: 120,
                          ), // 아이콘
                          Text('기관 활동 기록',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)), // 텍스트
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 1.0, // Height of the horizontal divider
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentViewPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero, // 내부 여백을 제거합니다.
                      ),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Column의 크기를 자식의 크기에 맞춤
                        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                        children: <Widget>[
                          Image.asset(
                            'image/community (16).png',
                            width: 120,
                            height: 120,
                          ), // 아이콘
                          Text('코멘트 모아보기',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)), // 텍스트
                        ],
                      ),
                    )),
                    Container(
                      width: 1.0, // Width of the vertical divider
                      color: colorScheme.primary,
                    ),
                    Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InstitutionInfoPage()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // 내부 여백을 제거합니다.
                          ),
                          child: Column(
                            mainAxisSize:
                            MainAxisSize.min, // Column의 크기를 자식의 크기에 맞춤
                            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                            children: <Widget>[
                              Image.asset(
                                'image/community (5).png',
                                width: 120,
                                height: 120,
                              ), // 아이콘
                              Text('기관 정보',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)), // 텍스트
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Container(
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
              //             // _key.currentState!.openDrawer();
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
      floatingActionButtonLocation: _fabLocation,
      bottomNavigationBar: bottomappbar,
    );
  }
}
