import 'package:aws_frame_account/globalkey.dart';
import 'package:aws_frame_account/login_page.dart';
import 'package:aws_frame_account/sign_up_page.dart';
import 'package:aws_frame_account/verification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:aws_frame_account/auth_service.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:aws_frame_account/amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:aws_frame_account/home_page.dart';


class LoginState extends ChangeNotifier {
  // final _authService = AuthService();
  // final _amplify = Amplify;
  late var _authService;

  String _useremail = '';
  String _username = '';
  String _userphonenumber = '';

  String get useremail => _useremail;

  set useremail(String value) {
    _useremail = value;
  }


  void set(AuthService authService) {
    this._authService=authService;
  }
  AuthService get() {
    return _authService;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get userphonenumber => _userphonenumber;

  set userphonenumber(String value) {
    _userphonenumber = value;
  }


  LoginState() {
    // _configureAmplify();
    // _authService.authStateController.stream.listen((snapshot) {
    //   final context = NavigationService.naviagatorState.currentState!.overlay!.context;
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.start)
    //     {
    //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
    //           builder: (BuildContext context) =>
    //               StartPage(shouldShowlogin: _authService.showLogin)), (route) => false);
    //
    //       // Navigator.push(
    //       //   context,
    //       //   MaterialPageRoute(
    //       //       builder: (context) =>
    //       //           StartPage(shouldShowlogin: _authService.showLogin)));
    //     }
    //
    //   // Show Login Page
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.login)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => LoginPage(
    //                   shouldShowstart: _authService.showstart,
    //                   didProvideCredentials: _authService.loginWithCredentials,
    //                   shouldShowSignUp: _authService.showSignUp,
    //                 )));
    //
    //   // Show Sign Up Page
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.signUp)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => SignUpPage(
    //                   shouldShowstart: _authService.showstart,
    //                   didProvideCredentials: _authService.signUpWithCredentials,
    //                   shouldShowLogin: _authService.showLogin,
    //                 )));
    //
    //   // Show Verification Code Page
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.verification)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => VerificationPage(
    //                 didProvideVerificationCode: _authService.verifyCode)));
    //
    //   // Show Camera Flow
    //   if (snapshot!.authFlowStatus == AuthFlowStatus.session)
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) =>
    //                 HomePage(shouldLogOut: _authService.logOut)));
    //
    //   //   MaterialPage(
    //   //   child: CameraFlow(shouldLogOut: _authService.logOut))
    //   // });
    // }
    // );
  }

  // void init(){
  //   _configureAmplify();
  // }



// void _configureAmplify() async {
  //   try {
  //     // await _amplify.addPlugin(AmplifyAuthCognito());
  //     // await _amplify.addPlugin(AmplifyStorageS3());
  //     final auth = AmplifyAuthCognito();
  //     final storage = AmplifyStorageS3();
  //     final analytics = AmplifyAnalyticsPinpoint();
  //     await _amplify.addPlugins([auth, storage, analytics]);
  //     await _amplify.configure(amplifyconfig);
  //     _authService.checkAuthStatus();
  //     print('Successfully configured Amplify 🎉');
  //   } catch (e) {
  //     print('Could not configure Amplify ☠️');
  //   }
  // }
}
