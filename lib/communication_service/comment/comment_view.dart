import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/communication_service/comment/Detail_comment.dart';
import 'package:aws_frame_account/provider/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentViewPage extends StatefulWidget {
  CommentViewPage({Key? key}) : super(key: key);

  @override
  State<CommentViewPage> createState() => _CommentViewPageState();
}

const List<String> _filterlist = ['날짜', '제목'];

class _CommentViewPageState extends State<CommentViewPage> {
  final TextEditingController _searchController = TextEditingController();

  late var year;
  late var current_year;
  late var month;
  late var current_month;
  List<Map<String, dynamic>> _comments = [];

  List<Map<String, dynamic>> _foundComments = [];


  String dropdownValue = _filterlist.first;

  final gql = GraphQLController.Obj;

  bool loading = true;

  late Stream<GraphQLResponse>? stream;

  StreamSubscription<GraphQLResponse<dynamic>>? listener = null;

  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.centerDocked;

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _comments;
    } else {
      if (dropdownValue == '날짜')
        results = _comments
            .where((comment) => comment["date"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      else
        results = _comments
            .where((comment) => comment["title"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();


      print(results);
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundComments = results;
    });
  }

  void storeAndSort(var result) {
    _comments = [];
    _foundComments = [];
    result.forEach((value) {
      // print(value.createdAt.toString().substring(0,10));
      _comments.add({
        'date': value.createdAt.toString().substring(0, 10)?? '',
        'title': value.TITLE?? '',
        'username': value.USERNAME?? '',
        'user_id': value.USER_ID?? '',
        'board_id': value.BOARD_ID?? '',
        'new_conversation': value.NEW_CONVERSATION_INST,
        'new_conversation_createdat':
        value.NEW_CONVERSATION_CREATEDAT.toString()
      });
    });
    _comments.sort((a, b) {
      String aa = a['new_conversation_createdat'];

      String bb = b['new_conversation_createdat'];
      return bb.compareTo(aa);
    });
    _foundComments = List.from(_comments);

  }

  void subscribeCommentChange() {
    listener = stream!.listen(
      (snapshot) {
        print('data : ${snapshot.data!}');
        gql.listInstitutionCommentBoard('1234').then((result) {
          print(result);
          _comments = [];
          _foundComments = [];
          result.forEach((value) {
            // print(value.createdAt.toString().substring(0,10));
            _comments.add({
              'date': value.createdAt.toString().substring(0, 10)?? '',
              'title': value.TITLE?? '',
              'username': value.USERNAME?? '',
              'user_id': value.USER_ID?? '',
              'board_id': value.BOARD_ID?? '',
              'new_conversation': value.NEW_CONVERSATION_INST,
              'new_conversation_createdat':
                  value.NEW_CONVERSATION_CREATEDAT.toString()
            });
            // _foundComments.add({
            //   'date': value.createdAt.toString().substring(0, 10),
            //   'title': value.TITLE,
            //   'username': value.USERNAME,
            //   'user_id': value.USER_ID,
            //   'board_id': value.BOARD_ID,
            //   'new_conversation_createdat': value.NEW_CONVERSATION_CREATEDAT
            //       .toString()
            // });
          });
          _comments.sort((a, b) {
            String aa = a['new_conversation_createdat'];

            String bb = b['new_conversation_createdat'];
            return bb.compareTo(aa);
          });
          _foundComments = List.from(_comments);
          setState(() {
            _foundComments = _foundComments;
          });
        });
      },
      onError: (Object e) => safePrint('Error in subscription stream: $e'),
    );
  }

  @override
  void dispose() {
    if (listener != null) listener?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    int index = 0;
    year = DateTime.now().year;
    month = DateTime.now().month;
    current_year = year;
    current_month = month;
    // gql.listInstitutionCommentBoard('1234').then((result) {
    //   print(result);
    //   result.forEach((value) {
    //     // print(value.createdAt.toString().substring(0,10));
    //     _comments.add({
    //       'date': value.createdAt.toString().substring(0, 10)?? '',
    //       'title': value.TITLE?? '',
    //       'username': value.USERNAME?? '',
    //       'user_id': value.USER_ID?? '',
    //       'board_id': value.BOARD_ID?? '',
    //       'new_conversation': value.NEW_CONVERSATION_INST,
    //       'new_conversation_createdat':
    //           value.NEW_CONVERSATION_CREATEDAT.toString()
    //     });
    //     // _foundComments.add({
    //     //   'date': value.createdAt.toString().substring(0, 10),
    //     //   'title': value.TITLE,
    //     //   'username': value.USERNAME,
    //     //   'user_id': value.USER_ID,
    //     //   'board_id': value.BOARD_ID,
    //     //   'new_conversation_createdat': value.NEW_CONVERSATION_CREATEDAT
    //     //       .toString()
    //     // });
    //   });
    //
    //   _comments.sort((a, b) {
    //     String aa = a['new_conversation_createdat'];
    //
    //     String bb = b['new_conversation_createdat'];
    //     return bb.compareTo(aa);
    //   });
    //   _foundComments = List.from(_comments);
    //   setState(() {
    //     loading = false;
    //   });
    // });

    gql
        .listInstitutionCommentBoard('USER_ID', '1', '$year',
        month < 10 ? '0${month}' : '$month',
        nextToken: null) //institution_id
        .then((result) {
      print(result);
      if (result.isNotEmpty) {
        storeAndSort(result);

        month--;
        if (month == 0) {
          month = 12;
          year--;
        }
      }
      print('year : $year');
      print('month : $month');

      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    stream = gql.subscribeInstitutionCommentBoard("1234");
    print(stream);
    subscribeCommentChange();
    // gql.queryListUsers("123").then((users) {
    //   users.forEach((value) {
    //     // if(index == 0){
    //     //   selectedUserName = '${value.NAME}(${value.BIRTH})';
    //     //   dropdownValue = selectedUserName;
    //     //   selectedUserId = '${value.ID}';
    //     // }
    //     // _userData[value.ID] = '${value.NAME}(${value.BIRTH})';
    //     // index++;
    //   });
    //   setState(() {
    //     loading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<LoginState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('코멘트 모아보기'),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                            child: Container(
                              // Add padding around the search bar
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              // Use a Material design search bar
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                controller: _searchController,
                                onChanged: (value) => _runFilter(value),
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  // Add a clear button to the search bar
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () => _searchController.clear(),
                                  ),
                                  // Add a search icon or button to the search bar
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      _runFilter(_searchController.text.trim());
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            onChanged: (String? value) {
                              setState(
                                () {
                                  dropdownValue = value!;
                                },
                              );
                            },
                            items: _filterlist
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: _foundComments.isNotEmpty
                          ? ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(16.0),
                              children: _buildListCards(context),
                            )
                          : const Text(
                              '검색된 내용이 없습니다',
                              style: TextStyle(fontSize: 24),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
    ;
  }

  List<StatelessWidget> _buildListCards(BuildContext context) {
    if (_foundComments.isEmpty) {
      return const <Card>[];
    }
    final ThemeData theme = Theme.of(context);

    return _foundComments.map((comment) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailCommentPage(
                      user_id: comment['user_id'],
                      board_id: comment['board_id'],
                    )),
          );
        },
        child: Stack(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Card(
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: CircleAvatar(
                            child: Image.asset(
                              'image/frame.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(comment['date']),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            comment['username'] + ' 훈련자님',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            comment['title'],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            comment['new_conversation'] == true
                ? Container(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('image/new_message.png'),
                    ),
                  )
                : const SizedBox()
            // Container(
            //   alignment: Alignment.topLeft,
            //   margin: EdgeInsets.all(20),
            //   padding: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(100),
            //       border: Border.all(width: 2, color: Colors.white)),
            //   child: Icon(
            //     Icons.add_comment,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      );
    }).toList();
  }
}
