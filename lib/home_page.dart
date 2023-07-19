import 'package:aws_frame_account/bottomappbar/bottom_appbar.dart';
import 'package:aws_frame_account/camera_gallary/graph_page.dart';
import 'package:aws_frame_account/communication_service/communication_yard.dart';
import 'package:aws_frame_account/globalkey.dart';
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

  var selectedIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  // bool _showNotch = false;

  late final bottomappbar;
  late final keyObj;
  late var appState;
  @override
  void initState() {
    super.initState();
    // getCurrentuser();
    keyObj = KeyForBottomAppbar();
    bottomappbar = GlobalBottomAppBar(keyObj: keyObj);
  }

  void getCurrentuser() async {
    try {
      // final result = await Amplify.Auth.getCurrentUser();
      final attribute = await Amplify.Auth.fetchUserAttributes();
      attribute.forEach((element) {
        if (element.userAttributeKey.key == "name")
          setState(() {
            // username = element.value;
            appState.username =element.value;
            // print("username : ${username}");
          });

        if (element.userAttributeKey.key == "phone_number")
          setState(() {
            // userphonenumber = element.value;
            appState.userphonenumber = element.value;
          });

        if (element.userAttributeKey.key == "email")
          setState(() {
            // useremail = element.value;
            appState.useremail = element.value;
          });
      });
      // print('userid:' + result.userId);
      // print('username:' + result.username);
      print(attribute.toString());
      // useremail = result.username;
      // print('useremail: ' + useremail);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    appState = context.watch<LoginState>();
    if (appState.username == '' ||
        appState.useremail == '' ||
        appState.userphonenumber == '') getCurrentuser();
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('image/frame.png'),

                  // widget.pickedimageurl == ''
                  //     ? null
                  //     : NetworkImage(widget.pickedimageurl!),
                  backgroundColor: Colors.white,
                ),
                accountName: Text('name : ${appState.username}'),
                accountEmail: Text('E-mail : ${appState.useremail}'),
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
              ),
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.person, semanticLabel: 'home'),
                  color: theme.colorScheme.primary,
                  onPressed: widget.didtogglegallery,
                ),
                title: const Text('profile'),
                onTap: widget.didtogglegallery,
                trailing: Icon(Icons.add),
              ),
            ],
          ),
        ),
        key: keyObj.key,
        appBar: AppBar(
          title: Text(
            '홍길동님의 동반자 고길동님 안녕하세요',
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
                      Text('홍길동님 훈련 데이터'),
                      const SizedBox(
                        height: 10,
                      ),
                      GraphPage(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('홍길동님 지난달보다 집중력 상승!'),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TraningReportPage()),
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
        floatingActionButtonLocation: _fabLocation,
        bottomNavigationBar: bottomappbar);
  }
}

// class HomePage extends StatefulWidget {
//   HomePage(
//       {Key? key,
//         required this.didtogglegallery,
//         // required this.didtogglegraph,
//         required this.pickedimageurl,
//         required this.shouldLogOut})
//       : super(key: key);
//   final VoidCallback didtogglegallery;
//
//   // final VoidCallback didtogglegraph;
//   final VoidCallback shouldLogOut;
//   String pickedimageurl = '';
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   var selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     var colorScheme = Theme.of(context).colorScheme;
//     var theme = Theme.of(context);
//     Widget page;
//     switch (selectedIndex) {
//       case 0:
//         page = MainPage(
//           didtogglegallery: widget.didtogglegallery,
//           pickedimageurl: widget.pickedimageurl,
//         );
//         break;
//       case 1:
//         page = Manage(
//           shouldLogOut: widget.shouldLogOut,
//         );
//         break;
//       case 2:
//         page = ProtectorService(
//           shouldLogOut: widget.shouldLogOut,
//         );
//         break;
//       case 3:
//         page = CommunicationService(
//           shouldLogOut: widget.shouldLogOut,
//         );
//         break;
//       default:
//         throw UnimplementedError('no widget for $selectedIndex');
//     }
//     var mainArea = ColoredBox(
//       color: colorScheme.surfaceVariant,
//       child: AnimatedSwitcher(
//         duration: Duration(milliseconds: 200),
//         child: page,
//       ),
//     );
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Profile'),
//       //   centerTitle: true,
//       //   backgroundColor: Colors.deepPurpleAccent,
//       //   // actions: [
//       //   //   IconButton(
//       //   //     icon: const Icon(
//       //   //       Icons.logout,
//       //   //       semanticLabel: 'logout',
//       //   //     ),
//       //   //     onPressed: widget.shouldLogOut,
//       //   //   ),
//       //   // ],
//       // ),
//       // drawer: Drawer(
//       //   child: ListView(
//       //     padding: EdgeInsets.zero,
//       //     children: [
//       //       UserAccountsDrawerHeader(
//       //         currentAccountPicture: CircleAvatar(
//       //           backgroundImage: widget.pickedimageurl == ''
//       //               ? null
//       //               : NetworkImage(widget.pickedimageurl!),
//       //           backgroundColor: Colors.white,
//       //         ),
//       //         accountName: Text('JinSu'),
//       //         accountEmail: Text('E-mail : $useremail'),
//       //         decoration: BoxDecoration(
//       //             color: Colors.deepPurpleAccent,
//       //             borderRadius: BorderRadius.only(
//       //                 bottomLeft: Radius.circular(40.0),
//       //                 bottomRight: Radius.circular(40.0))),
//       //       ),
//       //       ListTile(
//       //         leading: IconButton(
//       //           icon: const Icon(Icons.person, semanticLabel: 'home'),
//       //           color: theme.colorScheme.primary,
//       //           onPressed: widget.didtogglegallery,
//       //         ),
//       //         title: const Text('profile'),
//       //         onTap: widget.didtogglegallery,
//       //         trailing: Icon(Icons.add),
//       //       ),
//       //
//       //     ],
//       //   ),
//       // ),
//       body: Center(
//           child: Column(
//         children: [
//           Expanded(child: mainArea),
//           SafeArea(
//             child: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               items: [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home),
//                   label: 'Main',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.manage_search),
//                   label: 'Manage',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.person_2),
//                   label: 'protector',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.comment),
//                   label: 'Communication',
//                 ),
//               ],
//               currentIndex: selectedIndex,
//               onTap: (value) {
//                 setState(() {
//                   selectedIndex = value;
//                 });
//               },
//             ),
//           )
//         ],
//       )),
//     );
//   }
// }
