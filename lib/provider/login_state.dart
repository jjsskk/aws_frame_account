import 'package:aws_frame_account/bottomappbar/globalkey.dart';
import 'package:aws_frame_account/login_page.dart';
import 'package:aws_frame_account/sign_up_page.dart';
import 'package:aws_frame_account/verification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:aws_frame_account/auth_flow/auth_service.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:aws_frame_account/amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:aws_frame_account/home/home_page.dart';

class LoginState extends ChangeNotifier {
  // final _authService = AuthService();
  // final _amplify = Amplify;
  late var _authService;

  set authService(value) {
    _authService = value;
  }

  get authService => _authService;

  // protector's attribute info
  String _protectorEmail = '';
  String _protectorName = '';
  String _protectorPhonenumber = '';
  String _userNumber = ''; //= userId
  String _institutionNumber = '';

  // user table info
  String _userId = ''; // userNumber
  String _userBirth = '';
  String _userName = '';

  void resetVariables() {
    print("provider!!!");
    // protector's attribute info
    _protectorEmail = '';
    _protectorName = '';
    _protectorPhonenumber = '';
    _userNumber = '';
    _institutionNumber = '';
    // user table info
    _userId = '';
    _userBirth = '';
    _userName = '';
    // notifyListeners(); // don't use ->error occur
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get userNumber => _userNumber;

  set userNumber(String value) {
    _userNumber = value;
  }


  String get protectorEmail => _protectorEmail;

  set protectorEmail(String value) {
    _protectorEmail = value;
  }

  String get protectorName => _protectorName;

  set protectorName(String value) {
    _protectorName = value;
  }

  String get protectorPhonenumber => _protectorPhonenumber;

  set protectorPhonenumber(String value) {
    _protectorPhonenumber = value;
  }

  String get institutionNumber => _institutionNumber;

  set institutionNumber(String value) {
    _institutionNumber = value;
  }

  String get userBirth => _userBirth;

  set userBirth(String value) {
    _userBirth = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }



  // LoginState() {
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
  // }

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
