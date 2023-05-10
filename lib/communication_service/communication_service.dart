import 'package:flutter/material.dart';

import '../provider_login/login_state.dart';
import 'package:provider/provider.dart';
class CommunicationService extends StatefulWidget {
  const CommunicationService({Key? key,required this.shouldLogOut}) : super(key: key);
  final VoidCallback shouldLogOut;
  @override
  State<CommunicationService> createState() => _CommunicationServiceState();
}

class _CommunicationServiceState extends State<CommunicationService> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<LoginState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Communication"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: appState.get().logOut,
              child: Text('logout'))
        ],
      ),
    );
  }
}
