import 'package:flutter/material.dart';

import '../provider_login/login_state.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key,required this.didtogglegallery,required this.pickedimageurl,required this.useremail}) : super(key: key);
  final VoidCallback didtogglegallery;
  String pickedimageurl='';
  String useremail='';
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  @override



  @override
  Widget build(BuildContext context) {
    var _authService = context.watch<LoginState>().get();
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('main'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              semanticLabel: 'logout',
            ),
            onPressed: _authService.logOut,
          ),
        ],
      ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: widget.pickedimageurl == ''
                      ? null
                      : NetworkImage(widget.pickedimageurl!),
                  backgroundColor: Colors.white,
                ),
                accountName: Text('JinSu'),
                accountEmail: Text('E-mail : ${widget.useremail}'),
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
      );


  }
}
