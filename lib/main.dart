
import 'package:aws_frame_account/auth_service.dart';
import 'package:aws_frame_account/login_session.dart';
import 'package:aws_frame_account/login_page.dart';
import 'package:aws_frame_account/provider_login/login_state.dart';
import 'package:aws_frame_account/sign_up_page.dart';
import 'package:aws_frame_account/start_page.dart';
import 'package:aws_frame_account/verification_page.dart';
import 'package:aws_frame_account/protector_service/protector_serviice.dart';
import 'package:flutter/material.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:path/path.dart';

// Generated in previous step
import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create :(context) => LoginState(),
    builder: (context, child) {
      return MyApp();
    }
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  final _authService = AuthService();
  final _amplify = Amplify;

  @override
  void initState() {
    super.initState();
    _configureAmplify();

  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<LoginState>();
    appState.set(_authService);
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),

      // 1 AuthState를 전송하는 스트림을 관찰할 StreamBuilder로 Navigator를 래핑했습니다
      home: StreamBuilder<AuthState>(
          // 2 AuthService 인스턴스의 authStateController에서 AuthState 스트림에 액세스합니다.
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            // 3스트림에 데이터가 있을 수도 있고 없을 수도 있습니다.
            // AuthState 유형의 데이터에서 authFlowStatus에 안전하게 액세스하기 위해 여기에서는 먼저 검사를 구현합니다
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.start)
                    MaterialPage(
                        child: StartPage(shouldShowlogin: _authService.showLogin)),
                  // 4 스트림이 AuthFlowStatus.login을 전송하면 LoginPage가 표시됩니다
                  // Show Login Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        child: LoginPage(
                          shouldShowstart: _authService.showstart,
                      didProvideCredentials: _authService.loginWithCredentials,
                      shouldShowSignUp: _authService.showSignUp,
                    )),

                  // 5 스트림이 AuthFlowStatus.signUp을 전송하면 SignUpPage가 표시됩니다.
                  // Show Sign Up Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        child: SignUpPage(
                          shouldShowstart: _authService.showstart,
                      didProvideCredentials: _authService.signUpWithCredentials,
                      shouldShowLogin: _authService.showLogin,
                    )),

                  // Show Verification Code Page
                  if (snapshot.data!.authFlowStatus ==
                      AuthFlowStatus.verification)
                    MaterialPage(
                        child: VerificationPage(
                            didProvideVerificationCode:
                                _authService.verifyCode)),

                  // Show Camera Flow
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(
                        child: LoginSession(shouldLogOut: _authService.logOut))
                ],
                onPopPage: (route, result) => route.didPop(result),
              );
            } else {
              // 6 스트림에 데이터가 없으면 CircularProgressIndicator가 표시됩니다
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  void _configureAmplify() async {
    try {
    // await _amplify.addPlugin(AmplifyAuthCognito());
    // await _amplify.addPlugin(AmplifyStorageS3());
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();
      final analytics = AmplifyAnalyticsPinpoint();
    await _amplify.addPlugins([auth,storage,analytics]);
      await _amplify.configure(amplifyconfig);
    _authService.checkAuthStatus();

      print('Successfully configured Amplify 🎉');
    } catch (e) {
      print('Could not configure Amplify ☠️');
    }
  }
}



