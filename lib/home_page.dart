import 'package:aws_frame_account/login_session.dart';
import 'package:aws_frame_account/mainpage/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'communication_service/communication_service.dart';
import 'protector_service/protector_serviice.dart';
import 'traning record/record_manage.dart';

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
  String useremail='';
  @override
  void initState() {
    super.initState();
    getCurrentuser();
  }

  void getCurrentuser() async {
    try
    {
      final result = await Amplify.Auth.getCurrentUser();
      print('userid:' + result.userId);
      print('username:' + result.username);
      useremail = result.username;
      print('useremail: '+useremail);
    } catch (e)
    {
      print(e);
    }
  }

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MainPage(
          useremail: useremail,
          didtogglegallery: widget.didtogglegallery,
          pickedimageurl: widget.pickedimageurl,
        );
        break;
      case 1:
        page = Manage(
          shouldLogOut: widget.shouldLogOut,
        );
        break;
      case 2:
        page = ProtectorService(
          shouldLogOut: widget.shouldLogOut,
        );
        break;
      case 3:
        page = CommunicationService(
          shouldLogOut: widget.shouldLogOut,
        );
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Profile'),
      //   centerTitle: true,
      //   backgroundColor: Colors.deepPurpleAccent,
      //   // actions: [
      //   //   IconButton(
      //   //     icon: const Icon(
      //   //       Icons.logout,
      //   //       semanticLabel: 'logout',
      //   //     ),
      //   //     onPressed: widget.shouldLogOut,
      //   //   ),
      //   // ],
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       UserAccountsDrawerHeader(
      //         currentAccountPicture: CircleAvatar(
      //           backgroundImage: widget.pickedimageurl == ''
      //               ? null
      //               : NetworkImage(widget.pickedimageurl!),
      //           backgroundColor: Colors.white,
      //         ),
      //         accountName: Text('JinSu'),
      //         accountEmail: Text('E-mail : $useremail'),
      //         decoration: BoxDecoration(
      //             color: Colors.deepPurpleAccent,
      //             borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(40.0),
      //                 bottomRight: Radius.circular(40.0))),
      //       ),
      //       ListTile(
      //         leading: IconButton(
      //           icon: const Icon(Icons.person, semanticLabel: 'home'),
      //           color: theme.colorScheme.primary,
      //           onPressed: widget.didtogglegallery,
      //         ),
      //         title: const Text('profile'),
      //         onTap: widget.didtogglegallery,
      //         trailing: Icon(Icons.add),
      //       ),
      //
      //     ],
      //   ),
      // ),
      body: Center(
          child: Column(
        children: [
          Expanded(child: mainArea),
          SafeArea(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Main',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.manage_search),
                  label: 'Manage',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2),
                  label: 'protector',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.comment),
                  label: 'Communication',
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          )
        ],
      )),
    );
  }
}
