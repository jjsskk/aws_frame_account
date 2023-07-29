import 'dart:ui';

import 'package:aws_frame_account/analytics/analytics_events.dart';
import 'package:aws_frame_account/analytics/analytics_service.dart';
import 'package:aws_frame_account/auth_credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback shouldShowLogin;

  // final ValueChanged<SignUpCredentials> didProvideCredentials;
  final Future<void> Function(SignUpCredentials value, BuildContext context)
      didProvideCredentials;

  // final AsyncValueSetter<SignUpCredentials> didProvideCredentials;

  SignUpPage({
    Key? key,
    required this.didProvideCredentials,
    required this.shouldShowLogin,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

const List<String> _emaillist = [
  'naver.com',
  'gmail.com',
  'kakao.com',
  'daum.net'
];

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordconfirmController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _usernumberController = TextEditingController();
  final _institutionnumberController = TextEditingController();
  bool showspiner = false;
  final _formKey = GlobalKey<FormState>();
  bool isChecked_personal = false;
  bool isChecked_market = false;

  String dropdownValue = _emaillist.first;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blueAccent;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ModalProgressHUD(
        inAsyncCall: showspiner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: ListView(children: [
              const SizedBox(
                height: 50,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 130,
                  height: 130,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('image/frame.png'),
                  ),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '약관동의',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked_personal,
                          onChanged: null
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  titleTextStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  titlePadding: EdgeInsets.all(0),
                                  title: Container(
                                      width: 300,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: theme.primaryColor),
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('개인 정보 이용 동의'),
                                        ],
                                      ))),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
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
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isChecked_personal = true;
                                            });
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('동의'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isChecked_personal = false;
                                            });
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: const Text('동의안함'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              '(필수) 개인정보 동의',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked_market,
                          onChanged: null
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  titleTextStyle: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  titlePadding: EdgeInsets.all(0),
                                  title: Container(
                                      width: 300,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: theme.primaryColor),
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('마케팅 동의'),
                                        ],
                                      ))),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
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
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isChecked_market = true;
                                            });
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('동의'),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isChecked_market = false;
                                            });
                                            Navigator.pop(context, 'Cancel');
                                          },
                                          child: const Text('동의안함'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Text(
                              '(선택) 마케팅 동의',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              // Sign Up Form
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: _signUpForm()),

              // Login Button
              Container(
                height: MediaQuery.of(context).size.height / 5,
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '보호자 정보',
            style: TextStyle(color: Colors.white),
          ),
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
                labelText: '이름',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
          ),

          // Email TextField
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    // RegExp emailRegex = RegExp(r'@');
                    // if (!emailRegex.hasMatch(value!))
                    //   return '올바른 이메일 형식을 입력해주세요';
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.mail, color: Colors.white),
                      labelText: '이메일',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2))),
                ),
              ),
              Text(
                '@',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButton<String>(
                dropdownColor: Colors.black,
                value: dropdownValue,
                onChanged: (String? value) {
                  setState(
                    () {
                      dropdownValue = value!;
                    },
                  );
                },
                items: _emaillist.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '전화번호를 입력해주세요';
              }
              RegExp numberRegex = RegExp(r'^[0-9]+$');
              ;
              if (!numberRegex.hasMatch(value!)) return '숫자만 입력해주세요';
              return null;
            },
            style: const TextStyle(color: Colors.white),
            controller: _phonenumberController,
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                hintText: 'ex: 01012345678',
                icon: Icon(Icons.phone, color: Colors.white),
                labelText: '전화번호',
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

              RegExp passwordRegex =
                  RegExp(r'^(?=.*[a-z])(?=.*\d)[a-z\d]{8,}$');

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
                labelText: '비밀번호',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호 확인을 입력해주세요';
              }
              if (value != _passwordController.text) {
                return '비밀번호와 일치하지 않습니다';
              }

              RegExp passwordRegex =
                  RegExp(r'^(?=.*[a-z])(?=.*\d)[a-z\d]{8,}$');

              if (!passwordRegex.hasMatch(value!))
                return '반드시 소문자와 숫자를 포함해서 최소 8글자 이상 입력해주세요';

              return null;
            },
            style: const TextStyle(color: Colors.white),
            controller: _passwordconfirmController,
            decoration: InputDecoration(
                errorMaxLines: 2,
                icon: Icon(
                  Icons.lock_open,
                  color: Colors.white,
                ),
                labelText: '비밀번호 확인',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1.0,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '훈련자 정보',
            style: TextStyle(color: Colors.white),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '기관번호를 입력해주세요';
              }
              RegExp numberRegex = RegExp(r'^[0-9]+$');

              if (!numberRegex.hasMatch(value!)) return '숫자만 입력해주세요';
              return null;
            },
            style: const TextStyle(color: Colors.white),
            controller: _institutionnumberController,
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                hintText: 'ex: 01012345678',
                icon: Icon(Icons.phone, color: Colors.white),
                labelText: '기관 번호',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '훈련자번호를 입력해주세요';
              }
              RegExp numberRegex = RegExp(r'^[0-9]+$');

              if (!numberRegex.hasMatch(value!)) return '숫자만 입력해주세요';
              return null;
            },
            style: const TextStyle(color: Colors.white),
            controller: _usernumberController,
            decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                hintText: 'ex: 01012345678',
                icon: Icon(Icons.phone, color: Colors.white),
                labelText: '훈련자번호',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
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
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
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
    );
  }

  void _signUp() async {
    if (!isChecked_personal) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '개인정보 동의를 눌러주세요',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigoAccent,
      ));
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      showspiner = true;
    });
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim() + '@' + dropdownValue;
    final password = _passwordController.text.trim();
    String tem = '+';
    final phonenumber = tem + _phonenumberController.text.trim();
    final institutionphonenumber = _institutionnumberController.text.trim();
    final usernumber = _usernumberController.text.trim();
    _formKey.currentState!.validate();
    print('username: $username');
    print('email: $email');
    print('password: $password');
    final credentials = SignUpCredentials(
        username: email,
        name: username,
        password: password,
        phonenumber: phonenumber,
        usernumber: usernumber,
        institutionnumber:
            institutionphonenumber); // username is recognized as user's email by amplify api
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
