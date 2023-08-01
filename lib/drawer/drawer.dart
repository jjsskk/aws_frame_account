import 'package:aws_frame_account/provider_login/login_state.dart';
import 'package:flutter/material.dart';

class GlobalDrawer {
  static Widget getDrawer(BuildContext context, LoginState appState) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Drawer(
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
            accountName: Text('name : ${appState.protectorName}'),
            accountEmail: Text('E-mail : ${appState.protectorEmail}'),
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
              onPressed:  appState.authService.logOut,
            ),
            title: const Text('로그아웃'),
            onTap: appState.authService.logOut,
            trailing: Icon(Icons.logout),
          ),
          // ListTile(
          //   leading: IconButton(
          //     icon: const Icon(Icons.person, semanticLabel: 'home'),
          //     color: theme.colorScheme.primary,
          //     onPressed: widget.didtogglegallery,
          //   ),
          //   title: const Text('profile'),
          //   onTap: widget.didtogglegallery,
          //   trailing: Icon(Icons.add),
          // ),
        ],
      ),
    );
  }
}
