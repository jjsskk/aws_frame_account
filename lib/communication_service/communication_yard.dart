import 'package:aws_frame_account/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_account/communication_service/comment_view.dart';
import 'package:aws_frame_account/communication_service/instituition_info/institution_information.dart';
import 'package:aws_frame_account/communication_service/user_activity.dart';
import 'package:aws_frame_account/communication_service/user_care_information.dart';
import 'package:aws_frame_account/drawer/drawer.dart';
import 'package:aws_frame_account/globalkey.dart';
import 'package:aws_frame_account/provider_login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final keyObj = KeyForBottomAppbar();
final bottomappbar = GlobalBottomAppBar(keyObj: keyObj);

class CommunicationYardPage extends StatelessWidget {
  CommunicationYardPage({Key? key}) : super(key: key);

  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<LoginState>();
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      drawer: GlobalDrawer.getDrawer(context, appState),
      key: keyObj.key,
      appBar: AppBar(
          title: Text('소통마당'),
          centerTitle: true,
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
                      child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserCareInfoPage()),
                            );
                          },
                          icon: Icon(Icons.accessibility_new_rounded),
                          label: Text('이용자 \n돌봄 정보')),
                    ),
                    Container(
                      width: 1.0, // Width of the vertical divider
                      color: colorScheme.primary,
                    ),
                    Expanded(
                      child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserActivityPage()),
                            );
                          },
                          icon: Icon(Icons.accessibility_rounded),
                          label: Text(
                            '이용자 \n활동 기록',
                            maxLines: 2,
                            softWrap: true,
                          )),
                    ),
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
                      child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentViewPage()),
                            );
                          },
                          icon: Icon(Icons.report),
                          label: Text('코멘트 \n모아보기')),
                    ),
                    Container(
                      width: 1.0, // Width of the vertical divider
                      color: colorScheme.primary,
                    ),
                    Expanded(
                        child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstitutionInfoPage()),
                        );
                      },
                      icon: Icon(Icons.analytics),
                      label: Text('기관 정보'),
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
        child: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage('image/frame.png'),
          backgroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: _fabLocation,
      bottomNavigationBar: bottomappbar,
    );
  }
}
