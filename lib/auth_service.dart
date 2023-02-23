import 'dart:async';

import 'package:aws_amplified/auth_credentials.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 1
enum AuthFlowStatus { login, signUp, verification, session }

// 2
class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({required this.authFlowStatus});
}

// 3
class AuthService {
  // 4 authStateController는 관찰할 새로운 AuthState의 다운스트림 전송을 담당합니다
  final authStateController = StreamController<AuthState>();
  AuthCredentials? _credentials;
  late BuildContext context;

  // 5 이는 AuthState 스트림을 signUp으로 업데이트하는 간단한 함수입니다.
  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  // 6 showSignUp과 동일한 기능을 수행하지만 스트림을 업데이트하여 로그인 정보를 전송합니다.
  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

// 1
  Future<void> loginWithCredentials(
      AuthCredentials credentials, BuildContext context) async {
    try {
      this.context = context;
      // 2
      final result = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password);

      // 3
      if (result.isSignedIn) {
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        // 4
        print('User could not be signed in');
      }
    } on AuthException catch (authError) {
      print('Could not login - ${authError.recoverySuggestion}');

      //위젯이 사라지는 순간 조건이 false가 됨
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'please check your email and password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigoAccent,
      ));
    }
  }

// 2
  Future<void> signUpWithCredentials(
      SignUpCredentials credentials, BuildContext context) async {
    try {
      this.context = context;
      //1
      // 2
      final userAttributes = {
        CognitoUserAttributeKey.email: credentials.email,
      }; // aws 가이드 라인이랑 틀림 (인증추가 기능구현)

      // 3
      final result = await Amplify.Auth.signUp(
          //Amplify class는 static singleton
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      // 4
      // if (result.isSignUpComplete) {
      //   loginWithCredentials(credentials);
      // } else {
      // 5 사용자가 이메일을 확인할 때(함수 verifycode 호출시) 사용하도록 _credentials에 SignUpCredentials를 저장합니다
      this._credentials = credentials;

      // 6
      final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
      authStateController.add(state);
      // }

      // 7 어떤 이유로든 등록이 실패하면 로그에 오류를 출력하기만 하면 됩니다.
    } on AuthException catch (authError) {
      print('Failed to sign up - ${authError.recoverySuggestion}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'please enter correct email and password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigoAccent,
      ));
    }
  }

  // void verifyCode(String verificationCode) {
  //   final state = AuthState(authFlowStatus: AuthFlowStatus.session);
  //   authStateController.add(state);
  // }
  void verifyCode(String verificationCode) async {
    try {
      // 2
      final result = await Amplify.Auth.confirmSignUp(
          username: _credentials!.username, confirmationCode: verificationCode);

      // 3
      if (result.isSignUpComplete) {
        loginWithCredentials(_credentials!, context);
      } else {
        // 4
        // Follow more steps
      }
    } on AuthException catch (authError) {
      print('Could not verify code - ${authError.recoverySuggestion}');
    }
  }

  void logOut() async {
    try {
      // 1
      await Amplify.Auth.signOut();

      // 2
      showLogin();
    } on AuthException catch (authError) {
      print('Could not log out - ${authError.recoverySuggestion}');
    }
  }

  void checkAuthStatus() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();

      if (result.isSignedIn) {
        print('User state : login');
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        print('User state : logout');
        final state = AuthState(authFlowStatus: AuthFlowStatus.login);
        authStateController.add(state);
      }
    } catch (authError) {
      print(authError);
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    }
  }
}
