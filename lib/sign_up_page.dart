import 'dart:ui';

import 'package:aws_frame_account/analytics/analytics_events.dart';
import 'package:aws_frame_account/analytics/analytics_service.dart';
import 'package:aws_frame_account/auth_credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback shouldShowLogin;
  final VoidCallback shouldShowstart;

  // final ValueChanged<SignUpCredentials> didProvideCredentials;
  final Future<void> Function(SignUpCredentials value, BuildContext context)
      didProvideCredentials;

  // final AsyncValueSetter<SignUpCredentials> didProvideCredentials;

  SignUpPage(
      {Key? key,
      required this.didProvideCredentials,
      required this.shouldShowLogin,
      required this.shouldShowstart})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}
enum SingingCharacter { agree, disagree }
class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showspiner = false;
  final _formKey = GlobalKey<FormState>();
  SingingCharacter? _radio = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showspiner,
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
              Container(
                color: Colors.black87,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                  child: Column(
                    children: [
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Text(
                            '본인은 행정기관이 보유하고 있는 부동산 전산자료를 한국수출보험공사에게 제공'
                            " 하는데 대하여 아래와 같이 동의합니다.\n"
                            "-  아      래  -\n"
                            "1. 	사용목적 : 구상권 및 소구권의 행사\n"
                            " 2. 	자료제공의 범위 : 소유 부동산 현황 (전국)\n"
                            "3. 	동의서의 유효기간 :\n"
                            "- 수출신용보증의 구상채무 소멸시까지\n"
                            "- 수출어음보험의 소구채무 소멸시까지\n"
                            "- 수출보증보험의 구상채무 소멸시까지\n",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('동의',style: TextStyle(color: Colors.white),),
                          Radio<SingingCharacter>(
                            activeColor: Colors.white,
                            value: SingingCharacter.agree,
                            groupValue: _radio,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _radio = value;
                              });
                            },
                          ),
                          Text('비동의',style: TextStyle(color: Colors.white),),
                          Radio<SingingCharacter>(
                            activeColor: Colors.white,
                            value: SingingCharacter.disagree,
                            groupValue: _radio,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _radio = value;
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Username TextField
              // Sign Up Form
              Container(
                  color: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: _signUpForm()),

              // Login Button
              Container(
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height / 3 +
                        MediaQuery.of(context).size.height / 2),
                color: Colors.black87,
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: widget.shouldShowLogin,
                  label: Text(
                    'Already have an account? Login.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(155, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.indigo),
                  icon: Icon(Icons.arrow_forward),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
              style: const TextStyle(color: Colors.white),
              controller: _usernameController,
              decoration: const InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2))),
            ),

            // Email TextField
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이메일을 입력해주세요';
                }
                return null;
              },
              style: const TextStyle(color: Colors.white),
              controller: _emailController,
              decoration: InputDecoration(
                  icon: Icon(Icons.mail, color: Colors.white),
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2))),
            ),

            // Password TextField
            TextFormField(

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호을 입력해주세요';
                }
                RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*\d)[a-z\d]{8,}$');
                if (!passwordRegex.hasMatch(value!))
                  return '반드시 소문자와 숫자를 포함해서 최소 8글자 이상 입력해주세요';
                return null;
              },
              style: const TextStyle(color: Colors.white),
              controller: _passwordController,
              decoration: InputDecoration(
                errorMaxLines: 2,
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
            SizedBox(
              height: 50,
            ),
            // Sign Up Button
            Center(
              child: Container(
                padding: EdgeInsets.all(15),
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: GestureDetector(
                  onTap: _signUp,
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
                        'signup',
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
      ),
    );
  }

  void _signUp() async {
    if(_radio != SingingCharacter.agree)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            '개인정보 동의를 눌러주세요',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.indigoAccent,
        ));
      return;
      }
    if (!_formKey.currentState!.validate())
      return;
      setState(() {
      showspiner = true;
    });
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    _formKey.currentState!.validate();
    print('username: $username');
    print('email: $email');
    print('password: $password');
    final credentials =
        SignUpCredentials(username: email, email: username, password: password); // username is recognized as user's email by amplify api
    await widget.didProvideCredentials(credentials, context);
    // AnalyticsService.log(SignUpEvent());
    setState(() {
      showspiner = false;
    });
  }
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content, {super.key});

  final String content;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          content,
          style: const TextStyle(fontSize: 18),
        ),
      );
}
