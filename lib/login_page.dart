import 'package:aws_frame_account/analytics/analytics_events.dart';
import 'package:aws_frame_account/analytics/analytics_service.dart';
import 'package:aws_frame_account/auth_credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback shouldShowSignUp;
  final VoidCallback shouldShowstart;
  final VoidCallback shouldShowsresetpassword;
  final Future<void> Function(LoginCredentials value, BuildContext context)
      didProvideCredentials;

  // final ValueChanged<LoginCredentials> didProvideCredentials;

  LoginPage(
      {Key? key,
      required this.didProvideCredentials,
      required this.shouldShowSignUp,
      required this.shouldShowstart,
      required this.shouldShowsresetpassword})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1
  final _EmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
          child: SafeArea(
            child: ListView(children: [
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: widget.shouldShowstart,
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      Container(
                        width: 130,
                        height: 130,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('image/frame.png'),
                        ),
                      ),
                    ]),
              ),
              // Login Form
              Container(
                  color: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: _loginForm()),

              // 6
              // Sign Up Button
              Container(
                  padding: EdgeInsets.only(bottom: 50),
                  height: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.height / 3 +
                          MediaQuery.of(context).size.height / 2),
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
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
                      ),
                    ],
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  // 5
  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Username TextField
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력해주세요';
              }
              return null;
            },
            style: const TextStyle(color: Colors.white),
            controller: _EmailController,
            decoration: const InputDecoration(
                icon: Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
          ),

          // Password TextField
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해주세요';
              }
              return null;
            },
            style: const TextStyle(color: Colors.white),
            controller: _passwordController,
            decoration: const InputDecoration(
                icon: Icon(
                  Icons.lock_open,
                  color: Colors.white,
                ),
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {}, child: Text('아이디 찾기')),
              Text(' / '),
              TextButton(onPressed: widget.shouldShowsresetpassword, child: Text('비밀번호 찾기')),
            ],
          ),
          SizedBox(
            height: 30,
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
      ),
    );
  }

  // 7
  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      showSpinner = true;
    });
    _formKey.currentState!.validate();
    final Email = _EmailController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $Email');
    print('password: $password');
    final credentials = LoginCredentials(username: Email, password: password);
    await widget.didProvideCredentials(credentials, context);
    // AnalyticsService.log(LoginEvent());

    setState(() {
      showSpinner = false;
    });
  }
}
