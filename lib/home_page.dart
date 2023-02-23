import 'package:aws_amplified/camera_gallary/camera_flow.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key,
      required this.didtogglegallery,
      required this.didtogglegraph,
      required this.pickedimageurl})
      : super(key: key);
  final VoidCallback didtogglegallery;
  final VoidCallback didtogglegraph;
  String pickedimageurl;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? useremail;
  void getCurrentuser() async{
  try {
    final result = await Amplify.Auth.getCurrentUser();
    print('userid:'+result.userId);
    print ('username:'+result.username);
    useremail=result.username;
  } catch (e) {
    print(e);
  }

  }
  @override
  void initState() {
    super.initState();
    getCurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              backgroundImage: widget.pickedimageurl == ''
                  ? null
                  : NetworkImage(widget.pickedimageurl!),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: widget.didtogglegallery,
                icon: Icon(Icons.image),
                label: Text('Add image')),
            SizedBox(
              height: 20,
            ),
            Text(
              'Name : Kim Jin SU',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'E-mail : $useremail',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: widget.didtogglegraph,
                child: Text('Go to the Graphpage')),
          ],
        ),
      ),
    );
  }
}
