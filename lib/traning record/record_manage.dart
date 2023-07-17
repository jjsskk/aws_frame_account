import 'package:aws_frame_account/camera_gallary/graph_page.dart';
import 'package:aws_frame_account/protector_service/protector_service.dart';
import 'package:flutter/material.dart';

//needed when using queryItem method
import 'package:aws_frame_account/models/Todo.dart';
import 'package:aws_frame_account/models/MonthlyDBTest.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class Manage extends StatefulWidget {
  const Manage({Key? key, required this.shouldLogOut}) : super(key: key);
  final VoidCallback shouldLogOut;

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  var data = '눌러주세요';

  Future<void> createTodo() async {
    try {
      final todo = Todo(name: 'my first todo', description: 'todo description');
      final request = ModelMutations.create(todo);
      final response = await Amplify.API.mutate(request: request).response;

      final createdTodo = response.data;
      if (createdTodo == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdTodo.name}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<MonthlyDBTest?> queryItem() async {
    const ID = '1234';
    final queryPredicate = MonthlyDBTest.ID.eq(ID);

    try {
      final request = ModelQueries.list<MonthlyDBTest>(
        MonthlyDBTest.classType,
        where: queryPredicate,
      );
      print("here");
      final response = await Amplify.API.query(request: request).response;
      final test = response.data?.items.first;
      if (test == null) {
        safePrint('errors: ${response.errors}');
      }
      print(test.toString());
      return test;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }

  Future<List<MonthlyDBTest?>> queryListItems() async {
    try {
      final request = ModelQueries.list(MonthlyDBTest.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      if (items == null) {
        print('errors: ${response.errors}');
        return <MonthlyDBTest?>[];
      }
      return items;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return <MonthlyDBTest?>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              semanticLabel: 'logout',
            ),
            onPressed: widget.shouldLogOut,
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GraphPage()),
                );
              },
              child: Text('Go to the Graphpage')),
          SizedBox(height: 10,),
          TextButton(
            onPressed: () {
              queryItem().then((value) {
                setState(() {
                  data = value.toString();
                });
              });
            },
            child: Text(data),
          )
        ],
      ),
    );
  }
}
