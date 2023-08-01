import 'package:aws_frame_account/analytics/analytics_events.dart';
import 'package:aws_frame_account/analytics/analytics_service.dart';
import 'package:aws_frame_account/auth_credentials.dart';
import 'package:aws_frame_account/provider_login/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback shouldShowSignUp;
  final VoidCallback shouldShowsresetpassword;
  final Future<void> Function(LoginCredentials value, BuildContext context)
      didProvideCredentials;

  // final ValueChanged<LoginCredentials> didProvideCredentials;

  LoginPage(
      {Key? key,
      required this.didProvideCredentials,
      required this.shouldShowSignUp,
      required this.shouldShowsresetpassword})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1
  var _emailController = null;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false; //로그인 or signup시 대기시간동안 스핀이 돌도록....
  String _cacheid = '';
  late SharedPreferences _prefs;

  bool isChecked_id = true;
  bool isChecked_autologin = false;
  bool providerReset = false;

  // 캐시에 있는 데이터를 불러오는 함수
  // 이 함수의 기능으로, 어플을 끄고 켜도 데이터가 유지된다.
  _loadId() async {
    _prefs = await SharedPreferences.getInstance(); // 캐시에 저장되어있는 값을 불러온다.
    setState(() {
      // 캐시에 저장된 값을 반영하여 현재 상태를 설정한다.
      // SharedPreferences에 id, pw로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _cacheid = (_prefs.getString('id') ?? '');
      display_cacheId();
      print('cache id :$_cacheid'); // Run 기록으로 id와 pw의 값을 확인할 수 있음.
    });
  }

  late var appState;

  @override
  void initState() {
    super.initState();
    Get.deleteAll();
    _loadId();
  }

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

  void display_cacheId() {
    if (_cacheid == '')
      _emailController = TextEditingController();
    else
      _emailController = TextEditingController(text: _cacheid);
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<LoginState>();
    if (!providerReset) {
      appState.resetVariables();
      providerReset = true;
    }
    // display_cacheId();
    // 2
    return Scaffold(
      backgroundColor: Colors.black87,
      // 3
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
              // Login Form
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: _loginForm(),
              ),
              // 6
              // Sign Up Button
              Container(
                  height: MediaQuery.of(context).size.height / 5,
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
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked_autologin,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked_autologin = value!;
                  });
                },
              ),
              Text(
                '자동 로그인',
                style: TextStyle(color: Colors.white),
              ),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked_id,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked_id = value!;
                  });
                },
              ),
              Text(
                '아이디 저장',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          // Username TextField
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력해주세요';
              }
              return null;
            },
            style: const TextStyle(color: Colors.white),
            controller: _emailController,
            decoration: const InputDecoration(
                icon: Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                labelText: '이메일',
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
                labelText: '비밀번호',
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
              TextButton(
                  onPressed: widget.shouldShowsresetpassword,
                  child: Text('비밀번호 찾기')),
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
    final Email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (isChecked_id)
      _prefs.setString(
          'id', Email); // id를 키로 가지고 있는 값에 입력받은 _id(email)를 넣어줌. = 캐시에 넣어줌
    else
      _prefs.remove('id');

    if (isChecked_autologin)
      _prefs.setBool('autologin',
          true); // id를 키로 가지고 있는 값에 입력받은 _id(email)를 넣어줌. = 캐시에 넣어줌
    else
      _prefs.remove('autologin');

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
