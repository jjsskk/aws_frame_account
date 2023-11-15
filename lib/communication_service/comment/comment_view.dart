import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/communication_service/comment/Detail_comment.dart';
import 'package:aws_frame_account/loading_page/loading_page.dart';
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

  bool loading_comment = true;

  bool loading_scroll = false;
  double _dragDistance = 0;

  late Stream<GraphQLResponse>? stream;

  StreamSubscription<GraphQLResponse<dynamic>>? listener = null;

  bool dropDownDisappear = true;

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
        'date': value.createdAt.toString().substring(0, 10) ?? '',
        'title': value.TITLE ?? '',
        'username': value.USERNAME ?? '',
        'user_id': value.USER_ID ?? '',
        'content': value.CONTENT ?? '',
        'board_id': value.BOARD_ID ?? '',
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
        gql
            .listInstitutionCommentBoard('USER_ID', '$current_year',
                current_month < 10 ? '0${current_month}' : '$current_month',
                nextToken: null) //institution_id
            .then((result) {
          print(result);
          if (result.isNotEmpty) {
            storeAndSort(result);
            setCurrentDate();
          }
          print('year : $year');
          print('month : $month');

          if (mounted) {
            setState(() {
              loading_comment = false;
            });
          }
        });
      },
      onError: (Object e) => safePrint('Error in subscription stream: $e'),
    );
  }

  scrollNotification(notification) {
    // 스크롤 최대 범위
    var containerExtent = notification.metrics.viewportDimension;

    if (notification is ScrollStartNotification) {
      // 스크롤을 시작하면 발생(손가락으로 리스트를 누르고 움직이려고 할때)
      // 스크롤 거리값을 0으로 초기화함
      _dragDistance = 0;
    } else if (notification is OverscrollNotification) {
      // 안드로이드에서 동작
      // 스크롤을 시작후 움직일때 발생(손가락으로 리스트를 누르고 움직이고 있을때 계속 발생)
      // 스크롤 움직인 만큼 빼준다.(notification.overscroll)
      _dragDistance -= notification.overscroll;
    } else if (notification is ScrollUpdateNotification) {
      // ios에서 동작
      // 스크롤을 시작후 움직일때 발생(손가락으로 리스트를 누르고 움직이고 있을때 계속 발생)
      // 스크롤 움직인 만큼 빼준다.(notification.scrollDelta)
      _dragDistance -= notification.scrollDelta!;
    } else if (notification is ScrollEndNotification) {
      // 스크롤이 끝났을때 발생(손가락을 리스트에서 움직이다가 뗐을때 발생)

      // 지금까지 움직인 거리를 최대 거리로 나눈다.
      var percent = _dragDistance / (containerExtent);
      // 해당 값이 -0.4(40프로 이상) 아래서 위로 움직였다면
      if (percent <= -0.4) {
        // maxScrollExtent는 리스트 가장 아래 위치 값
        // pixels는 현재 위치 값
        // 두 같이 같다면(스크롤이 가장 아래에 있다)
        if (notification.metrics.maxScrollExtent ==
            notification.metrics.pixels) {
          print('데이터 불러온다');
          setState(() {
            // 서버에서 데이터를 더 가져오는 효과를 주기 위함
            // 하단에 프로그레스 서클 표시용
            loading_scroll = true;
          });

          // 서버에서 데이터 가져온다.

          gql
              .listInstitutionCommentBoard(
                  'USER_ID', '$year', month < 10 ? '0${month}' : '$month',
                  nextToken: null) //institution_id
              .then((result) {
            print(result);
            if (result.isNotEmpty) {
              List<Map<String, dynamic>> _commentsTemp = [];
              result.forEach((value) {
                // print(value.createdAt.toString().substring(0,10));
                _commentsTemp.add({
                  'date': value.createdAt.toString().substring(0, 10) ?? '',
                  'title': value.TITLE ?? '',
                  'username': value.USERNAME ?? '',
                  'content': value.CONTENT ?? '',
                  'user_id': value.USER_ID ?? '',
                  'board_id': value.BOARD_ID ?? '',
                  'new_conversation': value.NEW_CONVERSATION_INST,
                  'new_conversation_createdat':
                      value.NEW_CONVERSATION_CREATEDAT.toString()
                });
              });
              _commentsTemp.sort((a, b) {
                String aa = a['new_conversation_createdat'];

                String bb = b['new_conversation_createdat'];
                return bb.compareTo(aa);
              });
              _comments.addAll(_commentsTemp);
              _foundComments.addAll(_commentsTemp);
            }
            decreaseMonth();
            print('year : $year');
            print('month : $month');

            if (mounted) {
              setState(() {
                loading_scroll = false;
              });
            }
          });
          // gql
          //     .listInstitutionCommentBoard(
          //     selectedName == '전체' ? 'INSTITUTION_ID' : 'USER_ID',
          //     selectedId,
          //     '$year',
          //     month < 10 ? '0${month}' : '$month',
          //     nextToken: null) //institution_id
          //     .then((result) {
          //   print(result);
          //   print('the number of data :${result.length}');
          //
          //   if (result.isNotEmpty) {
          //     List<Map<String, dynamic>> _commentsTemp = [];
          //     result.forEach((value) {
          //       // print(value.createdAt.toString().substring(0,10));
          //       _commentsTemp.add({
          //         'date': value.createdAt.toString().substring(0, 10) ?? '',
          //         'title': value.TITLE ?? '',
          //         'username': value.USERNAME ?? '',
          //         'user_id': value.USER_ID ?? '',
          //         'board_id': value.BOARD_ID ?? '',
          //         'new_conversation': value.NEW_CONVERSATION_PROTECTOR,
          //         'new_conversation_createdat':
          //         value.NEW_CONVERSATION_CREATEDAT.toString()
          //       });
          //     });
          //     _commentsTemp.sort((a, b) {
          //       String aa = a['new_conversation_createdat'];
          //
          //       String bb = b['new_conversation_createdat'];
          //       return bb.compareTo(aa);
          //     });
          //     _comments.addAll(_commentsTemp);
          //     _foundComments.addAll(_commentsTemp);
          //
          //     month--;
          //     if (month == 0) {
          //       month = 12;
          //       year--;
          //     }
          //     print('year : $year');
          //     print('month : $month');
          //   }
          //   if (mounted) {
          //     setState(() {
          //       loading_scroll = false;
          //       // _foundComments = _foundComments;
          //     });
          //   }
          // });
        }
      }
    }
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
        .listInstitutionCommentBoard(
            'USER_ID', '$year', month < 10 ? '0${month}' : '$month',
            nextToken: null) //institution_id
        .then((result) {
      print(result);
      if (result.isNotEmpty) {
        storeAndSort(result);
      }
      decreaseMonth();
      print('year : $year');
      print('month : $month');

      if (mounted) {
        setState(() {
          loading_comment = false;
        });
      }
    });
    stream = gql.subscribeInstitutionCommentBoard(); //1234 기관 id
    print(stream);
    subscribeCommentChange();
  }

  void decreaseMonth() {
    month--;
    if (month == 0) {
      month = 12;
      year--;
    }
  }

  void setCurrentDate() {
    year = current_year;
    month = current_month - 1;
    if (month == 0) {
      month = 12;
      year--;
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<LoginState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '코멘트 모아보기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
      body: loading_comment
          ? LoadingPage()
          : Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("image/ui (3).png"), // 여기에 배경 이미지 경로를 지정합니다.
            fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
          ),
        ),
            child: Center(
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
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) => _runFilter(value),
                                  decoration: InputDecoration(
                                    hintText: '검색해주세요..',
                                    // Add a clear button to the search bar
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.transparent,
                                      ),
                                      onPressed: () => _searchController.clear(),
                                    ),
                                    // Add a search icon or button to the search bar
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        _runFilter(_searchController.text.trim());
                                      },
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: AssetImage(
                                      "image/community (6).png",
                                    ),
                                  ),
                                ),
                              ),

                              // Container(
                              //   // Add padding around the search bar
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 8.0),
                              //   // Use a Material design search bar
                              //   child: TextField(
                              //     style: TextStyle(color: Colors.black),
                              //     controller: _searchController,
                              //     onChanged: (value) => _runFilter(value),
                              //     decoration: InputDecoration(
                              //       hintText: 'Search...',
                              //       // Add a clear button to the search bar
                              //       suffixIcon: IconButton(
                              //         icon: Icon(Icons.clear),
                              //         onPressed: () => _searchController.clear(),
                              //       ),
                              //       // Add a search icon or button to the search bar
                              //       prefixIcon: IconButton(
                              //         icon: Icon(Icons.search),
                              //         onPressed: () {
                              //           _runFilter(_searchController.text.trim());
                              //         },
                              //       ),
                              //       border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(20.0),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: dropDownDisappear
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        dropDownDisappear = !dropDownDisappear;
                                      });
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 9,
                                      child:
                                          Image.asset('image/community (4).png'),
                                    ),
                                  )
                                : Container(
                                    height:
                                        MediaQuery.of(context).size.height / 27,
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image:
                                            AssetImage("image/report (20).png"),
                                        // 여기에 배경 이미지 경로를 지정합니다.
                                        fit: BoxFit
                                            .fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
                                      ),
                                    ),
                                    child: Center(
                                      child: DropdownButton<String>(
                                        dropdownColor: Colors.indigoAccent,
                                        value: dropdownValue,
                                        icon: Icon(
                                          // Add this
                                          Icons.arrow_drop_down, // Add this
                                          color: Colors.white, // Add this
                                        ),
                                        onChanged: (String? value) {
                                          setState(
                                            () {
                                              dropdownValue = value!;
                                              dropDownDisappear =
                                                  !dropDownDisappear;
                                            },
                                          );
                                        },
                                        items: _filterlist
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                      Expanded(
                          child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          /*
                       스크롤 할때 발생되는 이벤트
                       해당 함수에서 어느 방향으로 스크롤을 했는지를 판단해
                       리스트 가장 밑에서 아래서 위로 40프로 이상 스크롤 했을때
                       서버에서 데이터를 추가로 가져오는 루틴이 포함됨.
                      */
                          if (!loading_scroll) scrollNotification(notification);
                          return false;
                        },
                        child: ListView(
                            physics: AlwaysScrollableScrollPhysics(),
                            // controller: _scrollController,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(16.0),
                            children: _buildListCards(context)),
                      )),
                    ],
                  ),
                ),
              ),
          ),
    );
    ;
  }

  List<Widget> _buildListCards(BuildContext context) {
    if (_foundComments.isEmpty) {
      return [
        const Text(
          '검색된 내용이 없습니다',
          style: TextStyle(fontSize: 24),
        ),
        loading_scroll
            ? Center(child: CircularProgressIndicator())
            : const SizedBox(),
      ];
    }
    final ThemeData theme = Theme.of(context);
    var temp = _foundComments.map((comment) {
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
        child: Container(
          height: MediaQuery.of(context).size.height / 5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: comment['new_conversation'] == true
                  ? AssetImage('image/community (11).png')
                  : AssetImage("image/community (7).png"),
              // 여기에 배경 이미지 경로를 지정합니다.
              fit: BoxFit.fill, // 이미지가 전체 화면을 커버하도록 설정합니다.
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        comment['content'],
                        maxLines: 2,
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
      );
    }).toList();
    temp.add(InkWell(
      child: loading_scroll
          ? Center(child: CircularProgressIndicator())
          : const SizedBox(),
    ));

    return temp;
  }
}
