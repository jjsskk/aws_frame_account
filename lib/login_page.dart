import 'package:aws_amplified/analytics/analytics_events.dart';
import 'package:aws_amplified/analytics/analytics_service.dart';
import 'package:aws_amplified/auth_credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback shouldShowSignUp;
  final Future<void> Function(LoginCredentials value, BuildContext context)
      didProvideCredentials;

  // final ValueChanged<LoginCredentials> didProvideCredentials;

  LoginPage(
      {Key? key,
      required this.didProvideCredentials,
      required this.shouldShowSignUp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showSpinner = false; //로그인 or signup시 대기시간동안 스핀이 돌도록....


  @override
  void initState() {
    super.initState();
    Get.deleteAll();
  }
  @override
  Widget build(BuildContext context) {
    // 2
    return Scaffold(
      // 3
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(children: [
            Positioned(
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('image/frame.png'),
                        ),
                      ),
                    ]),
              ),
              top: 0,
              right: 0,
              left: 0,
            ),
            // Login Form
            Positioned(
              top: 249.93,
              child: Container(
                  color: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: _loginForm()),
            ),

            // 6
            // Sign Up Button
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height - 133.65,
              child: Container(
                padding: EdgeInsets.only(bottom: 50),
                  height: 200,
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: widget.shouldShowSignUp,
                    label: Text(
                      'Don\'t have an account? Sign up.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        minimumSize: Size(155, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.indigo),
                    icon: Icon(Icons.arrow_forward),
                  )),
            )
          ]),
        ),
      ),
    );
  }

  // 5
  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Username TextField
        TextField(
          style: const TextStyle(color: Colors.white),
          controller: _usernameController,
          decoration: const InputDecoration(
              icon: Icon(
                Icons.mail,
                color: Colors.white,
              ),
              labelText: 'Username',
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2))),
        ),

        // Password TextField
        TextField(
          style: const TextStyle(color: Colors.white),
          controller: _passwordController,
          decoration:const InputDecoration(
            icon: Icon(
              Icons.lock_open,
              color: Colors.white,
            ),
            labelText: 'Password',
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white,width: 2)
            )
          ),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        SizedBox(
          height: 50,
        ),

        // Login Button
        Center(
          child: Container(
            padding: EdgeInsets.all(15),
            height: 90,
            width: 90,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: GestureDetector(
              onTap: _login,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1))
                    ]),
                child: Center(
                  child: Text(
                    'login',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // 7
  void _login() async {
    setState(() {
      showSpinner = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('password: $password');
    final credentials =
        LoginCredentials(username: username, password: password);
    await widget.didProvideCredentials(credentials, context);
    AnalyticsService.log(LoginEvent());

    setState(() {
      showSpinner = false;
    });
  }
}
