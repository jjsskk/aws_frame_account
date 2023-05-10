import 'package:aws_frame_account/communication_service/communication_service.dart';
import 'package:flutter/material.dart';
class ProtectorService extends StatefulWidget {
  const ProtectorService({Key? key,required this.shouldLogOut}) : super(key: key);
  final VoidCallback shouldLogOut;
  @override
  State<ProtectorService> createState() => _ProtectorServiceState();
}

class _ProtectorServiceState extends State<ProtectorService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Protector service"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunicationService(shouldLogOut: widget.shouldLogOut)),
                );
              },
              child: Text('Go to the Communicationpage'))
        ],
      ),
    );
  }
}
