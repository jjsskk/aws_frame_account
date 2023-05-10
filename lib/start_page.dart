import 'package:flutter/material.dart';


class StartPage extends StatelessWidget {
  const StartPage({Key? key,required this.shouldShowlogin}) : super(key: key);
  final VoidCallback shouldShowlogin;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: shouldShowlogin, child: Text('기관로그인')),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(onPressed: shouldShowlogin, child: Text('사용자 로그인'))
            ],
          )
        ],
      ),
    );

  }
}