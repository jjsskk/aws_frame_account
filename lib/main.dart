// // dart async library you will refer to when setting up real time updates
// import 'dart:async';
//
// // flutter and ui libraries
// import 'package:flutter/material.dart';
//
// // amplify packages you will need to use
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:amplify_datastore/amplify_datastore.dart';
// import 'package:amplify_api/amplify_api.dart';
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
//
// // amplify configuration and models that should have been generated for you
// import 'amplifyconfiguration.dart';
// import 'models/ModelProvider.dart';
// import 'models/Todo.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Amplified Todo',
//       home: TodosPage(),
//     );
//   }
// }
//
// class TodosPage extends StatefulWidget {
//   const TodosPage({Key? key}) : super(key: key);
//
//   @override
//   State<TodosPage> createState() => _TodosPageState();
// }
//
// class _TodosPageState extends State<TodosPage> {
//
//   // loading ui state - initially set to a loading state
//   bool _isLoading = true;
//   late StreamSubscription<QuerySnapshot<Todo>> _subscription;
//   // list of Todos - initially empty
//   List<Todo> _todos = [];
//
//   // amplify plugins
//   final _dataStorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
//   final apiPlugin = AmplifyAPI();
//   final authPlugin = AmplifyAuthCognito();
//
//   @override
//   void initState() {
//
//     // kick off app initialization
//     _initializeApp();
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _subscription.cancel();
//   }
//   Future<void> _initializeApp() async {
//     // configure Amplify
//     await _configureAmplify();
//
//     // Query and Observe updates to Todo models. DataStore.observeQuery() will
//     // emit an initial QuerySnapshot with a list of Todo models in the local store,
//     // and will emit subsequent snapshots as updates are made
//     //
//     // each time a snapshot is received, the following will happen:
//     // _isLoading is set to false if it is not already false
//     // _todos is set to the value in the latest snapshot
//     _subscription = Amplify.DataStore.observeQuery(Todo.classType)
//         .listen((QuerySnapshot<Todo> snapshot) {
//       setState(() {
//         if (_isLoading) _isLoading = false;
//         _todos = snapshot.items;
//       });
//     });
//   }
//
//   Future<void> _configureAmplify() async {
//     try {
//       // add Amplify plugins
//       // await Amplify.addPlugins([_dataStorePlugin]);// device의 local 저장소로만 data 저장(인터넷 없어도 가능)
//       await Amplify.addPlugins([_dataStorePlugin, apiPlugin, authPlugin]);//aws amplify 의 db와 연동해서 모든 data 거기에 저장
//
//       // configure Amplify
//       //
//       // note that Amplify cannot be configured more than once!
//       await Amplify.configure(amplifyconfig);
//     } catch (e) {
//
//       // error handling can be improved for sure!
//       // but this will be sufficient for the purposes of this tutorial
//       safePrint('An error occurred while configuring Amplify: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Todo List'),
//       ),
//       body: _isLoading                                  // if in a loading state
//            ? const Center(child: CircularProgressIndicator())  // display progress indicator
//             : TodosList(todos: _todos),                   // or the todos list otherwise,
//       // body: _isLoading
//       //     ? Center(child: CircularProgressIndicator())
//       //     : TodosList(todos: _todos),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddTodoForm()),
//           );
//         },
//         tooltip: 'Add Todo',
//         label: Row(
//           children: const [Icon(Icons.add), Text('Add todo')],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
//
// class TodosList extends StatelessWidget {
//   const TodosList({
//     required this.todos,
//     Key? key,
//   }) : super(key: key);
//
//   final List<Todo> todos;
//
//   @override
//   Widget build(BuildContext context) {
//     return todos.isNotEmpty
//         ? ListView(
//         padding: const EdgeInsets.all(8),
//         children: todos.map((todo) => TodoItem(todo: todo)).toList())
//         : const Center(
//       child: Text('Tap button below to add a todo!'),
//     );
//   }
// }
//
// class TodoItem extends StatelessWidget {
//   const TodoItem({
//     required this.todo,
//     Key? key,
//   }) : super(key: key);
//
//   final double iconSize = 24.0;
//   final Todo todo;
//
//   void _deleteTodo(BuildContext context) async {
//     try {
//       // to delete data from DataStore, you pass the model instance to
//       // Amplify.DataStore.delete()
//       await Amplify.DataStore.delete(todo);
//     } catch (e) {
//       safePrint('An error occurred while deleting Todo: $e');
//     }
//   }
//
//   Future<void> _toggleIsComplete() async {
//
//     // copy the Todo you wish to update, but with updated properties
//     final updatedTodo = todo.copyWith(isComplete: !todo.isComplete);
//     try {
//
//       // to update data in DataStore, you again pass an instance of a model to
//       // Amplify.DataStore.save()
//       await Amplify.DataStore.save(updatedTodo);
//     } catch (e) {
//       safePrint('An error occurred while saving Todo: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: InkWell(
//         onTap: () {
//           _toggleIsComplete();
//         },
//         onLongPress: () {
//           _deleteTodo(context);
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     todo.name ?? "string value is null",
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(todo.description ?? 'No description'),
//                 ],
//               ),
//             ),
//             Icon(
//                 todo.isComplete
//                     ? Icons.check_box
//                     : Icons.check_box_outline_blank,
//                 size: iconSize),
//           ]),
//         ),
//       ),
//     );
//   }
// }
//
// class AddTodoForm extends StatefulWidget {
//   const AddTodoForm({Key? key}) : super(key: key);
//
//   @override
//   State<AddTodoForm> createState() => _AddTodoFormState();
// }
//
// class _AddTodoFormState extends State<AddTodoForm> {
//   late final TextEditingController _nameController;
//   late final TextEditingController _descriptionController;
//
//   @override
//   void initState() {
//     _nameController = TextEditingController();
//     _descriptionController = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _nameController.dispose();
//     _descriptionController.dispose();
//   }
//
//   Future<void> _saveTodo() async {
//     // get the current text field contents
//     final name = _nameController.text;
//     final description = _descriptionController.text;
//     // create a new Todo from the form values
//     // `isComplete` is also required, but should start false in a new Todo
//     final newTodo = Todo(
//       name: name,
//       description: description.isNotEmpty ? description : null,
//       isComplete: false,
//     );
//     try {
//       // to write data to DataStore, you simply pass an instance of a model to
//       // Amplify.DataStore.save()
//       await Amplify.DataStore.save(newTodo);
//       // after creating a new Todo, close the form
//       // Be sure the context at that moment is still valid and mounted
//       if (mounted) {
//         Navigator.of(context).pop();
//       }
//     } catch (e) {
//       safePrint('An error occurred while saving Todo: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Todo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration:
//                 const InputDecoration(filled: true, labelText: 'Name'),
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                     filled: true, labelText: 'Description'),
//               ),
//               ElevatedButton(
//                 onPressed: _saveTodo,
//                 child: const Text('Save'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:aws_frame_account/auth_service.dart';
import 'package:aws_frame_account/camera_gallary/camera_flow.dart';
import 'package:aws_frame_account/login_page.dart';
import 'package:aws_frame_account/sign_up_page.dart';
import 'package:aws_frame_account/verification_page.dart';
import 'package:flutter/material.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

// import 'package:amplify_api/amplify_api.dart'; // UNCOMMENT this line after backend is deployed
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';

// Generated in previous step
import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
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
    // _authService.checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
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
                  // 4 스트림이 AuthFlowStatus.login을 전송하면 LoginPage가 표시됩니다
                  // Show Login Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        child: LoginPage(
                      didProvideCredentials: _authService.loginWithCredentials,
                      shouldShowSignUp: _authService.showSignUp,
                    )),

                  // 5 스트림이 AuthFlowStatus.signUp을 전송하면 SignUpPage가 표시됩니다.
                  // Show Sign Up Page
                  if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        child: SignUpPage(
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
                        child: CameraFlow(shouldLogOut: _authService.logOut))
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

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool _amplifyConfigured = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState(); //새로운 유저가 등록을 끝내고 채팅방으로 이동시 유저의 이메이을 콘솔에 출력할것이기때문에
//     _configureAmplify(); // state가 매번 초기화 될때 이 과정을 진행
//   }
//
//   void _configureAmplify() async {
//     // await Amplify.addPlugin(AmplifyAPI()); // UNCOMMENT this line after backend is deployed
//     await Amplify.addPlugin(
//         AmplifyDataStore(modelProvider: ModelProvider.instance));
//
//     // Once Plugins are added, configure Amplify
//     await Amplify.configure(amplifyconfig);
//     try {
//       setState(() {
//         _amplifyConfigured = true;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void _create() async {
//     try {
//       final item =
//           Todo(isComplete: true, description: "Lorem ipsum dolor sit amet");
//       await Amplify.DataStore.save(item);
//       final updatedItem =
//           item.copyWith(isComplete: false, description: "fffffffff");
//       await Amplify.DataStore.save(updatedItem);
//
//       await Amplify.DataStore.delete(updatedItem);
//       List<Todo> Todos = await Amplify.DataStore.query(Todo.classType);
//       print(Todos);
//     } catch (e) {
//       print("Could not query DataStore: ");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 _create();
//               },
//               child: Text('create'))
//         ],
//       ),
//     );
//   }
// }
