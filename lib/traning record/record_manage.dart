import 'package:aws_frame_account/camera_gallary/graph_page.dart';
import 'package:aws_frame_account/protector_service/protector_serviice.dart';
import 'package:flutter/material.dart';

class Manage extends StatefulWidget {
  const Manage({Key? key, required this.shouldLogOut}) : super(key: key);
  final VoidCallback shouldLogOut;
  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage'),
        centerTitle: true,
      ),
      body: Column(
          children: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GraphPage()),
                      );
                    },
                    child: Text('Go to the Graphpage'))
          ],
        ),
    );

  }
}
