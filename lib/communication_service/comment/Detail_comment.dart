import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/communication_service/comment/new_message.dart';
import 'package:aws_frame_account/loading_page/loading_page.dart';
import 'package:aws_frame_account/provider/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailCommentPage extends StatefulWidget {
  DetailCommentPage({Key? key, required this.user_id, required this.board_id})
      : super(key: key);

  final user_id;
  final board_id;

  @override
  State<DetailCommentPage> createState() => _DetailCommentPageState();
}

class _DetailCommentPageState extends State<DetailCommentPage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  var blue = const Color(0xff1f43f3);

  List<Map<String, dynamic>> _conversations = [];

  late var appState;
  final gql = GraphQLController.Obj;
  late Stream<GraphQLResponse>? stream;
  StreamSubscription<GraphQLResponse<dynamic>>? listener = null;

  String commentTitle = '';
  String commentContent = '';
  String user = '';
  bool loading_comment = true;
  bool loading_conversation = true;
  String date = '';

  void subscribeConversationChange() {
    listener = stream!.listen(
      (snapshot) {
        print('data : ${snapshot.data!}');
        gql.listInstitutionCommentConversation(widget.board_id).then((result) {
          print(result);
          _conversations = [];
          result.forEach((value) {
            // print(value.createdAt.toString().substring(0,10));
            _conversations.add({
              // 'date': value.createdAt.toString().substring(0, 10),
              'date': value.createdAt.toString() ?? '',
              'content': value.CONTENT ?? '',
              'writer': value.WRITER ?? '',
              'board_id': value.BOARD_ID ?? '',
              'conversation_id': value.CONVERSATION_ID ?? '',
              'email': value.EMAIL ?? ''
            });
          });
          _conversations.sort((a, b) {
            String aa = a['date'];

            String bb = b['date'];
            return aa.compareTo(bb);
          });
          setState(() {
            _conversations = _conversations;
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
    gql
        .getInstitutionCommentBoard(widget.user_id, widget.board_id)
        .then((value) {
      print(value);
      commentTitle = value.TITLE;
      commentContent = value.CONTENT;
      user = value.USERNAME;
      date = value.createdAt.toString().substring(0, 10);
      if (value.NEW_CONVERSATION_INST == true) {
        // print('NEW_CONVERSATION_PROTECTOR == true');
        gql.updateCommentBoarddataForReadConversation(
            widget.user_id, widget.board_id);
      }
      setState(() {
        loading_comment = false;
      });
    });

    gql.listInstitutionCommentConversation(widget.board_id).then((result) {
      print(result);
      result.forEach((value) {
        // print(value.createdAt.toString().substring(0,10));
        _conversations.add({
          // 'date': value.createdAt.toString().substring(0, 10),
          'date': value.createdAt.toString() ?? '',
          'content': value.CONTENT ?? '',
          'writer': value.WRITER ?? '',
          'board_id': value.BOARD_ID ?? '',
          'conversation_id': value.CONVERSATION_ID ?? '',
          'email': value.EMAIL ?? ''
        });
      });
      _conversations.sort((a, b) {
        String aa = a['date'];

        String bb = b['date'];
        return aa.compareTo(bb);
      });

      stream = gql.subscribeInstitutionCommentConversation();
      print(stream);
      subscribeConversationChange();
      setState(() {
        loading_conversation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = context.watch<LoginState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('코멘트 상세보기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/ui (5).png'), // 여기에 원하는 이미지 경로를 써주세요.
              fit: BoxFit.cover, // 이미지가 AppBar를 꽉 채우도록 설정
            ),
          ),
        ),
      ),
      body: (loading_comment || loading_conversation)
          ? LoadingPage()
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage("image/ui (3).png"), // 여기에 배경 이미지 경로를 지정합니다.
                    fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: double
                                    .infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
                              ),
                              // height: MediaQuery.of(context).size.height / 10,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("image/ui (9).png"),
                                  // 여기에 배경 이미지 경로를 지정합니다.
                                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          ),
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('$user 훈련자님의 보호자님에게',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Divider(
                                                thickness: 2.0,
                                              ),
                                              Text(date),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height / 3,
                                maxHeight: double.infinity,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("image/community (7).png"),
                                  // 여기에 배경 이미지 경로를 지정합니다.
                                  fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(commentTitle,
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 2.0,
                                            ),
                                            Text(commentContent,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Divider(
                              thickness: 2.0,
                            ),
                            Column(
                              children: _buildListCards(),
                            )
                            // ListView.builder(
                            //   itemCount: data.length,
                            //   itemBuilder: (context, index) {
                            //     // final announcement = snapshot.data![index];
                            //     return Card(
                            //       child: ListTile(
                            //         leading: Icon(Icons.message),
                            //         title: Row(
                            //           children: [
                            //             Text(data[index][0],
                            //                 style: TextStyle(color: Colors.black)),
                            //             const SizedBox(
                            //               width: 10,
                            //             ),
                            //             Text(
                            //               data[index][2],
                            //               style: TextStyle(color: Colors.black),
                            //             ),
                            //           ],
                            //         ),
                            //         subtitle: Text(data[index][1]),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      NewMessage(
                        user_id: widget.user_id,
                        board_id: widget.board_id,
                        writer: gql.protectorName,
                        email: gql.protectorEmail,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  List<Column> _buildListCards() {
    if (_conversations.isEmpty) {
      return const <Column>[];
    }

    return _conversations.map((value) {
      return Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: double.infinity, // container 길이를 text에 맞게 유연하게 늘릴수 있다.
            ),
            // height: MediaQuery.of(context).size.height / 10,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/ui (9).png"),
                // 여기에 배경 이미지 경로를 지정합니다.
                fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 20,
                            ),
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(value['writer'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      gql.protectorEmail == value['email']
                          ? IconButton(
                              icon: Icon(
                                Icons.highlight_remove_rounded,
                                color: blue,
                              ),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('해당 댓글을 삭제하시겠습니까?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                final check = await gql
                                                    .deleteCommentConversationdata(
                                                  value['board_id'],
                                                  value['conversation_id'],
                                                );
                                                if (check) {
                                                  // ScaffoldMessenger.of(context)
                                                  //     .showSnackBar(SnackBar(
                                                  //   content: Text(
                                                  //     '댓글이 삭제 되었습니다',
                                                  //     style:
                                                  //     TextStyle(fontWeight: FontWeight.bold),
                                                  //   ),
                                                  // ));
                                                  Navigator.pop(context);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: const Text(
                                                      '댓글이 삭제 되지 못했습니다. 다시 시도해주세요.',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ));
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('네')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('아니요'))
                                        ],
                                      );
                                    });
                              },
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(value['content'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(value['date'].substring(0, 10) ==
                          DateTime.now().toString().substring(0, 10)
                      ? value['date'].substring(11, 19)
                      : value['date'].substring(0, 10)),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      );
    }).toList();
  }
}
