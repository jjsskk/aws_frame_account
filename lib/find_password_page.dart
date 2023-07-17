import 'package:flutter/material.dart';
import 'package:aws_frame_account/auth_credentials.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Find_Password_Page extends StatefulWidget {
  Find_Password_Page(
      {Key? key,
      required this.resetPassword,
      required this.confirmResetPassword,
      required this.shouldShowLogin})
      : super(key: key);

  final VoidCallback shouldShowLogin;
  final Future<void> Function(
      String username,
      Function(bool check) checkvelification,
      BuildContext context) resetPassword;
  final Future<void> Function(String username, String newPasswor,
      String confirmationCode, BuildContext context) confirmResetPassword;

  @override
  State<Find_Password_Page> createState() => _Find_Password_PageState();
}

class _Find_Password_PageState extends State<Find_Password_Page> {
  final _verificationCodeController = TextEditingController();

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _verificationcheck = false;

  void checkvelification(bool verification) {
    setState(() {
      this._verificationcheck = verification;
    });
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
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
              Column(
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
              const SizedBox(height: 30,),
              // Login Form
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: _verificationForm(),
              ),

              // 6
              // Sign Up Button
              Container(
                  height: MediaQuery.of(context).size.height/6,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: widget.shouldShowLogin,
                        label: Text(
                          'return to login',
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

  Widget _verificationForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'ex: FRAME@naver.com',
                      icon: Icon(Icons.mail, color: Colors.white),
                      labelText: '이메일',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2))),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: _confirmemail,
                  child: Text(
                    'send',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple)),
            ],
          ),
          // _verificationcheck == false ? Text('') : Text('${_emailController.text.trim()}로 인증코드가 발송되었습니다.'),
          const SizedBox(height: 20,),
          Divider(thickness: 1.0,color: Colors.white,),
          // Verification Code TextField
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '인증코드를 입력해주세요';
              }
              return null;
            },
            style: const TextStyle(color: Colors.white),
            controller: _verificationCodeController,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.confirmation_number,
                  color: Colors.white,
                ),
                labelText: '인증 코드',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '새로운 비밀번호을 입력해주세요';
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
                labelText: '새로운 비밀번호 ',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2))),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 20,
          ),
          // Verify Button
          const SizedBox(height: 30,),

          Center(
            child: Container(
              padding: EdgeInsets.all(15),
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: GestureDetector(
                onTap: _verifycode,
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
                      '인증',
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

  void _confirmemail() async {
    setState(() {
      showSpinner = true;
    });
    final _email = _emailController.text.trim();
    await widget.resetPassword(_email, checkvelification, context);
    // AnalyticsService.log(VerificationEvent());
    setState(() {
      showSpinner = false;
    });
  }

  void _verifycode() async {
    if (!_verificationcheck) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '인증번호를 발송해주세요',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigoAccent,
      ));
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      showSpinner = true;
    });
    final _email = _emailController.text.trim();
    final _newpassword = _passwordController.text.trim();
    final _verificationCode = _verificationCodeController.text.trim();
    await widget.confirmResetPassword(
        _email, _newpassword, _verificationCode, context);
    // AnalyticsService.log(VerificationEvent());
    setState(() {
      showSpinner = false;
    });
  }
}
