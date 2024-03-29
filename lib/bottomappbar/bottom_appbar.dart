import 'package:aws_frame_account/bottomappbar/globalkey.dart';
import 'package:flutter/material.dart';

class GlobalBottomAppBar extends StatelessWidget {
  GlobalBottomAppBar({required this.keyObj});

  final keyObj;

  // GlobalKey<ScaffoldState> get key => _key;

  @override
  Widget build(BuildContext context) {
    var colorScheme = const Color(0xfff1f1f1);
    var theme = Theme.of(context);
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      // if you want to remove notch, input null
      color: const Color(0xfff1f1f1),
      child: IconTheme(
        data: IconThemeData(color: const Color(0xff2b3fee)),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 65,
            ),
            IconButton(
              onPressed: () {
                // print(keyObj.key);
                keyObj.key.currentState!.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: 35,
              ),
            ),
            const SizedBox(
              width: 180,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
