import 'package:aws_amplified/analytics/analytics_events.dart';
import 'package:aws_amplified/analytics/analytics_service.dart';
import 'package:aws_amplified/auth_credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback shouldShowLogin;

  // final ValueChanged<SignUpCredentials> didProvideCredentials;
  final Future<void> Function(SignUpCredentials value, BuildContext context)
      didProvideCredentials;

  // final AsyncValueSetter<SignUpCredentials> didProvideCredentials;

  SignUpPage(
      {Key? key,
      required this.didProvideCredentials,
      required this.shouldShowLogin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showspiner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showspiner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(children: [
            Positioned(
              child: Container(
                height: 220,
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
            // Sign Up Form
            Positioned(
              top: 219.85,
              child: Container(
                  color: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  child: _signUpForm()),
            ),

            // Login Button
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height - 113.7,
              child: Container(
                height: 120,
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
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Username TextField
          TextField(
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
          TextField(
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
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _passwordController,
            decoration: InputDecoration(
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
    setState(() {
      showspiner = true;
    });
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print('username: $username');
    print('email: $email');
    print('password: $password');
    final credentials =
        SignUpCredentials(username: username, email: email, password: password);
    await widget.didProvideCredentials(credentials, context);
    AnalyticsService.log(SignUpEvent());
    setState(() {
      showspiner = false;
    });
  }
}
