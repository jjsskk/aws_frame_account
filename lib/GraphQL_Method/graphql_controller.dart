import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_account/models/InstitutionCommentBoardTable.dart';
import 'package:aws_frame_account/models/InstitutionCommentConversationTable.dart';
import 'package:flutter/material.dart';

//needed when using queryItem method
import 'package:aws_frame_account/models/Todo.dart';
import 'package:aws_frame_account/models/MonthlyDBTest.dart';
import 'package:aws_frame_account/models/UserDBTest.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:math';

class GraphQLController {
  static final _Obj = GraphQLController._internal();

  static get Obj => _Obj;

  factory GraphQLController() {
    return _Obj;
  }

  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this clas
  GraphQLController._internal();

  //user
  var birth = 19640101;
  var userid = "1";
  var useridint = 2;

  //brain signal
  var brainmonth = "20230101";

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


  // 병찬






  // 진수

  Future<void> createUserData() async {
    try {
      final row = UserDBTest(
          id: userid,
          birth: birth,
          name: "김수",
          organization: "frame",
          sex: "남");
      final request = ModelMutations.create(row);
      final response = await Amplify.API.mutate(request: request).response;
      birth += 10000;
      useridint++;
      userid = "$useridint";
      final createdUser = response.data;
      if (createdUser == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdUser.name}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<void> createMonthlyData() async {
    try {
      final row = MonthlyDBTest(
        id: "3",
        month: brainmonth,
        avg_att: Random().nextInt(100) + 1,
        avg_med: Random().nextInt(100) + 1,
        con_score: Random().nextInt(100) + 1,
        spacetime_score: Random().nextInt(100) + 1,
        exec_score: Random().nextInt(100) + 1,
        mem_score: Random().nextInt(100) + 1,
        ling_score: Random().nextInt(100) + 1,
        cal_score: Random().nextInt(100) + 1,
        reac_score: Random().nextInt(100) + 1,
        orient_score: Random().nextInt(100) + 1,
      );
      final request = ModelMutations.create(row);
      final response = await Amplify.API
          .mutate(
        request: request,
      )
          .response;
      int month = int.parse(brainmonth);
      month += 100;
      brainmonth = "$month";

      final createdUser = response.data;
      if (createdUser == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdUser.month}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<MonthlyDBTest?> queryMonthlyDBItem() async {
    try {
      var ID = '3';
      int limit =
      1; // Fetch the latest 1 data items, you can change this value to fetch more or less
      String sortDirection =
          "DESC"; // Set to "ASC" for ascending order, or "DESC" for descending order

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "awsamplify",
          document: """
          query ListMonthlyDBTests(\$id: ID, \$limit: Int, \$sortDirection: ModelSortDirection) {
            listMonthlyDBTests(
              id: \$id,
              limit: \$limit,
              sortDirection: \$sortDirection
            ) {
              items {
                id
                month
                total_time
                avg_att
                avg_med
                firsts_name
                first_amt
                second_name
                second_amt
                con_score
                spacetime_score
                exec_score
                mem_score
                ling_score
                cal_score
                reac_score
                orient_score
                createdAt
                updatedAt
              }
            }
          }
        """,
          variables: {
            "id": userId,
            "limit": limit,
            "sortDirection": sortDirection,
          },
        ),
      );

      var response = await operation.response;
      // print(response.data);
      // Map<String, dynamic> json = jsonDecode(response.data);
      // in Dart, you can use the jsonDecode function from the dart:convert library. The jsonDecode function parses a JSON string and returns the corresponding Dart object.
      MonthlyDBTest monthlyDBTest =
          (jsonDecode(response.data)['listMonthlyDBTests']['items'] as List)
              .map((item) => MonthlyDBTest.fromJson(item))
              .toList()
              .first;
      if (monthlyDBTest == null) {
        safePrint('errors: ${response.errors}');
        // safePrint('errors: ${response}');
      }
      return monthlyDBTest;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }

  // Future<List<MonthlyDBTest?>> queryListMonthlyDBItems(int yearMonth) async {
  //   var ID = '3';
  //   // final queryPredicate = MonthlyDBTest.ID.eq(ID);
  //   //20240211- 10000 + 50
  //   //if( yearmonth >  )2
  //   print("yearmonth:${yearMonth - 10000 + 50}");
  //   final queryPredicateDateMax = MonthlyDBTest.MONTH.le("$yearMonth");
  //   final queryPredicateDatemin =
  //       MonthlyDBTest.MONTH.gt("${yearMonth - 10000 + 50}");
  //   final queryPredicateall = MonthlyDBTest.ID
  //       .eq(ID)
  //       .and(queryPredicateDateMax)
  //       .and(queryPredicateDatemin);
  //
  //   try {
  //     final request = ModelQueries.list<MonthlyDBTest>(MonthlyDBTest.classType,
  //         where: queryPredicateall);
  //     final response = await Amplify.API.query(request: request).response;
  //
  //     final items = response.data?.items;
  //     if (items == null) {
  //       print('errors: ${response.errors}');
  //       return const [];
  //     }
  //     return items;
  //   } on ApiException catch (e) {
  //     print('Query failed: $e');
  //     return const [];
  //   }
  // }

  Future<List<MonthlyDBTest?>> queryListMonthlyDBItems() async {
    try {
      var ID = '3';
      int limit =
      12; // Fetch the latest 12 data items, you can change this value to fetch more or less
      String sortDirection =
          "DESC"; // Set to "ASC" for ascending order, or "DESC" for descending order

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "awsamplify",
          document: """
          query ListMonthlyDBTests(\$id: ID, \$limit: Int, \$sortDirection: ModelSortDirection) {
            listMonthlyDBTests(
              id: \$id,
              limit: \$limit,
              sortDirection: \$sortDirection
            ) {
              items {
                id
                month
                total_time
                avg_att
                avg_med
                firsts_name
                first_amt
                second_name
                second_amt
                con_score
                spacetime_score
                exec_score
                mem_score
                ling_score
                cal_score
                reac_score
                orient_score
                createdAt
                updatedAt
              }
            }
          }
        """,
          variables: {
            "id": ID,
            "limit": limit,
            "sortDirection": sortDirection,
          },
        ),
      );

      var response = await operation.response;
      // print(response.data);
      // Map<String, dynamic> json = jsonDecode(response.data);
      // in Dart, you can use the jsonDecode function from the dart:convert library. The jsonDecode function parses a JSON string and returns the corresponding Dart object.
      List<MonthlyDBTest> monthlyDBTests =
      (jsonDecode(response.data)['listMonthlyDBTests']['items'] as List)
          .map((item) => MonthlyDBTest.fromJson(item))
          .toList();
      if (monthlyDBTests == null) {
        print('errors: ${response.errors}');
        return const [];
      }
      return monthlyDBTests;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  // Future<List<MonthlyDBTest?>> queryMonthlyDBTwoItems(int yearMonth) async {
  //   var ID = '3';
  //   // final queryPredicate = MonthlyDBTest.ID.eq(ID);
  //   //20240211- 10000 + 50
  //   //if( yearmonth >  )2
  //   print("yearmonth:${yearMonth - 10000 + 50}");
  //   final queryPredicateDateMax = MonthlyDBTest.MONTH.le("$yearMonth");
  //   final queryPredicateDatemin =
  //   MonthlyDBTest.MONTH.gt("${yearMonth - 10000 + 50}");
  //   final queryPredicateall = MonthlyDBTest.ID
  //       .eq(ID)
  //       .and(queryPredicateDateMax)
  //       .and(queryPredicateDatemin);
  //
  //   try {
  //     final request = ModelQueries.list<MonthlyDBTest>(MonthlyDBTest.classType,
  //         where: queryPredicateall,
  //    );
  //     final response = await Amplify.API.query(request: request).response;
  //
  //     final items = response.data?.items;
  //     if (items == null) {
  //       print('errors: ${response.errors}');
  //       return const [];
  //     }
  //     return items;
  //   } on ApiException catch (e) {
  //     print('Query failed: $e');
  //     return const [];
  //   }
  // }

  Future<List<MonthlyDBTest?>> queryMonthlyDBLatestTwoItems() async {
    try {
      var ID = '3';
      int limit =
      2; // Fetch the latest 2 data items, you can change this value to fetch more or less
      String sortDirection =
          "DESC"; // Set to "ASC" for ascending order, or "DESC" for descending order

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "awsamplify",
          document: """
          query ListMonthlyDBTests(\$id: ID, \$limit: Int, \$sortDirection: ModelSortDirection) {
            listMonthlyDBTests(
              id: \$id,
              limit: \$limit,
              sortDirection: \$sortDirection
            ) {
              items {
                id
                month
                total_time
                avg_att
                avg_med
                firsts_name
                first_amt
                second_name
                second_amt
                con_score
                spacetime_score
                exec_score
                mem_score
                ling_score
                cal_score
                reac_score
                orient_score
                createdAt
                updatedAt
              }
            }
          }
        """,
          variables: {
            "id": ID,
            "limit": limit,
            "sortDirection": sortDirection,
          },
        ),
      );

      var response = await operation.response;
      // print(response.data);
      // Map<String, dynamic> json = jsonDecode(response.data);
      // in Dart, you can use the jsonDecode function from the dart:convert library. The jsonDecode function parses a JSON string and returns the corresponding Dart object.
      List<MonthlyDBTest> monthlyDBTests =
      (jsonDecode(response.data)['listMonthlyDBTests']['items'] as List)
          .map((item) => MonthlyDBTest.fromJson(item))
          .toList();
      if (monthlyDBTests == null) {
        print('errors: ${response.errors}');
        return const [];
      }
      return monthlyDBTests;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  Future<MonthlyDBTest?> queryMonthlyDBRequiredItem(
      int yearMonth) async {
    print(yearMonth + 40);
    final queryPredicateDate = MonthlyDBTest.MONTH
        .between(yearMonth.toString(), (yearMonth + 40).toString());
    final queryPredicateboth = MonthlyDBTest.ID.eq(userId).and(queryPredicateDate);

    try {
      final request = ModelQueries.list<MonthlyDBTest>(
        MonthlyDBTest.classType,
        where: queryPredicateboth,
      );
      final response = await Amplify.API.query(request: request).response;
      final test = response.data?.items.last; // latest data
      if (test == null) {
        safePrint('errors: ${response.errors}');
        return null;
      }
      print(test.toString());
      return test;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }

  // Future<UserDBTest?> queryUserDBItem(String id) async {
  //   const ID = '1';
  //
  //   final queryPredicate = UserDBTest.ID.eq(ID);
  //   // final queryPredicateboth = UserDBTest.BIRTH.between(start, end).and(queryPredicateId);
  //
  //   try {
  //     final request = ModelQueries.list<UserDBTest>(
  //       UserDBTest.classType,
  //       where: queryPredicate,
  //     );
  //     // print('apiname: ${request.apiName}');
  //     final response = await Amplify.API.query(request: request).response;
  //     final test = response.data?.items.first;
  //     if (test == null) {
  //       safePrint('errors: ${response.errors}');
  //     }
  //     print(test.toString());
  //     return test;
  //   } on ApiException catch (e) {
  //     safePrint('Query failed: $e');
  //     return null;
  //   }
  // }
  Future<UserDBTest?> queryUserDBItem(String id) async {
    const ID = '1';
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "awsamplify",
          document: """
          query getUserDBTest(\$id: ID!) {
            getUserDBTest(
              id: \$id
            ) {
                id
                birth
                name
                organization
                sex            
                createdAt
                updatedAt
            }
          }
        """,
          variables: {
            "id": ID,
          },
        ),
      );

      var response = await operation.response;
      {
        print(response.data);
        if (response.data == null) {
          safePrint('errors: ${response.errors}');
          return null;
        }
        UserDBTest user =
        UserDBTest.fromJson(jsonDecode(response.data)['getUserDBTest']);
        if (user == null) {
          safePrint('errors: ${response.errors}');
          return null;
        }

        return user;
      }
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }

  Future<List<UserDBTest?>> queryListUserDBItems(int start, int end) async {
    final queryPredicate = UserDBTest.BIRTH.between(start, end);
    try {
      final request =
      ModelQueries.list(UserDBTest.classType, where: queryPredicate);
      final response = await Amplify.API.query(request: request,).response;

      final items = response.data?.items;
      if (items == null) {
        print('errors: ${response.errors}');
        return <UserDBTest?>[];
      }
      return items;
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return <UserDBTest?>[];
  }

  Future<bool?> createCommentBoarddata(String user_id, String title,
      String writer, String content, String username, String inst_id) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': time,
      'CONTENT': content,
      'WRITER': writer,
      'TITLE': title,
      'USERNAME': username,
      'INSTITUTION_ID': inst_id,
      'NEW_CONVERSATION_PROTECTOR': false,
      'NEW_CONVERSATION_INST': false,
      'NEW_CONVERSATION_CREATEDAT': time,
      'createdAt': time,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          apiName: "Protector_API",
          variables: {
            'input': row,
          },
          document: '''
            mutation createInstitutionCommentBoardTable(\$input: CreateInstitutionCommentBoardTableInput!) {
                  createInstitutionCommentBoardTable(input: \$input) {
	                  BOARD_ID
	                  USER_ID
	                  WRITER
	                  CONTENT
	                  TITLE
	                  USERNAME
	                  INSTITUTION_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
	                  createdAt
	                  updatedAt
               }  
              }
            ''',
        ),
      )
          .response;
      {
        final createdData = response.data;
        if (createdData == null ||
            jsonDecode(createdData!)['createInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Stream<GraphQLResponse>? subscribeInstitutionCommentBoard() {
    String inst_id = 'aaa';
    try {
      var operation = Amplify.API.subscribe(
        GraphQLRequest(
          apiName: "Protector_API",
          document: """
     subscription onsubscribeCommentBoardTable {
        onsubscribeCommentBoardTable {
	                  BOARD_ID
	                  USER_ID
	                  WRITER
	                  CONTENT
	                  TITLE
	                  USERNAME
	                  INSTITUTION_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
	                  createdAt
	                  updatedAt
        }
      }
    """,
        ),
        onEstablished: () {
          print("subscription success");
        },
      ).handleError(
            (Object error) {
          safePrint('Error in subscription stream: $error');
        },
      );

      // var response = await operation.response;
      // List<InstitutionScheduleTable> schedules =
      // (jsonDecode(response.data)['listInstitutionScheduleTables']['items']
      // as List)
      //     .map((item) => InstitutionScheduleTable.fromJson(item))
      //     .toList();
      // if (schedules == null) {
      //   print('errors: ${response.errors}');
      //   return const [];
      // }
      return operation;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }


  Future<List<InstitutionCommentBoardTable?>> listInstitutionCommentBoard(
      String filterName,  String year, String month,
      {String? nextToken}) async {
    final time = '${TemporalDateTime.now()}';
    var remain = time.substring(12);
    var start = '$year-$month-00$remain';
    var end = '$year-$month-40$remain';

    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
        document: """
          query ListInstitutionCommentBoardTables(\$filter: TableInstitutionCommentBoardTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionCommentBoardTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                BOARD_ID
                USER_ID
                WRITER
                TITLE
                USERNAME
                CONTENT
                INSTITUTION_ID
                NEW_CONVERSATION_PROTECTOR
                NEW_CONVERSATION_INST
                NEW_CONVERSATION_CREATEDAT
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              filterName: {"eq": userId},
              "NEW_CONVERSATION_CREATEDAT": {
                "between": [start, end]
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        var data = jsonDecode(response.data);
        var items = data['listInstitutionCommentBoardTables']['items'];
        if (response.data == null || items == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        List<InstitutionCommentBoardTable?> comments = (items as List)
            .map((item) => InstitutionCommentBoardTable.fromJson(item))
            .toList();
        var newNextToken =
        data['listInstitutionCommentBoardTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var nextComments = await listInstitutionCommentBoard(
              filterName, year, month,
              nextToken: newNextToken);
          comments.addAll(nextComments!);
        }

        return comments;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  // Future<List<InstitutionCommentBoardTable>?> listInstitutionCommentBoard(
  //     String institutionId) async {
  //   // String inst_id = 'aaa';
  //   // int dateNext = int.parse(date);
  //   // dateNext += 40;
  //   try {
  //     var operation = Amplify.API.query(
  //       request: GraphQLRequest(
  //         apiName: "Protector_API",
  //         document: """
  //     query listInstitutionCommentBoardTables(\$filter: TableInstitutionCommentBoardTableFilterInput) {
  //       listInstitutionCommentBoardTables(
  //         filter: \$filter,
  //       ) {
  //         items {
  //                   BOARD_ID
  //                   USER_ID
  //                   WRITER
  //                   TITLE
  //                   USERNAME
  //                   INSTITUTION_ID
  //                   NEW_CONVERSATION_PROTECTOR
  //                   NEW_CONVERSATION_INST
  //                   NEW_CONVERSATION_CREATEDAT
  //                   createdAt
  //                   updatedAt
  //         }
  //       }
  //     }
  //   """,
  //         variables: {
  //           "filter": {
  //             "INSTITUTION_ID": {"eq": institutionId},
  //           },
  //         },
  //       ),
  //     );
  //
  //     var response = await operation.response;
  //     print(response.data);
  //     List<InstitutionCommentBoardTable> comments =
  //         (jsonDecode(response.data)['listInstitutionCommentBoardTables']
  //                 ['items'] as List)
  //             .map((item) => InstitutionCommentBoardTable.fromJson(item))
  //             .toList();
  //     if (comments == null ||
  //         jsonDecode(response.data)['listInstitutionCommentBoardTables']
  //                 ['items'] ==
  //             null) {
  //       safePrint('errors: ${response.errors}');
  //       return const [];
  //     }
  //     return comments;
  //   } on ApiException catch (e) {
  //     print('Query failed: $e');
  //     return const [];
  //   }
  // }

  Future<InstitutionCommentBoardTable?> getInstitutionCommentBoard(
      String user_id, String board_id) async {
    // String inst_id = 'aaa';
    // int dateNext = int.parse(date);
    // dateNext += 40;
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
      query getInstitutionCommentBoardTable(\$USER_ID: String!, \$BOARD_ID: String!) {
       getInstitutionCommentBoardTable(USER_ID: \$USER_ID, BOARD_ID: \$BOARD_ID)
        {
	                  BOARD_ID
	                  USER_ID
	                  WRITER
	                  CONTENT
	                  TITLE
	                  USERNAME
	                  INSTITUTION_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
	                  createdAt
	                  updatedAt
          
        }
      }
    """,
          variables: {"USER_ID": user_id, "BOARD_ID": board_id},
        ),
      );

      var response = await operation.response;
      {
        print(response.data);
        if (response.data == null) {
          safePrint('errors: ${response.errors}');
          return null;
        }
        InstitutionCommentBoardTable comment =
        InstitutionCommentBoardTable.fromJson(
            jsonDecode(response.data)['getInstitutionCommentBoardTable']);
        if (comment == null) {
          print('errors: ${response.errors}');
          return null;
        }
        return comment;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future<bool?> updateCommentBoarddata(
      String user_id, String board_id, String title, String content) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': board_id,
      'CONTENT': content,
      'TITLE': title,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          apiName: "Protector_API",
          variables: {
            'input': row,
          },
          document: '''
            mutation updateInstitutionCommentBoardTable(\$input: UpdateInstitutionCommentBoardTableInput!) {
                  updateInstitutionCommentBoardTable(input: \$input) {
	                  BOARD_ID
	                  USER_ID
	                  CONTENT
	                  TITLE
	                  updatedAt
               }  
              }
            ''',
        ),
      )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)['updateInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<bool?> deleteCommentBoarddata(
      String user_id,
      String board_id,
      ) async {
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': board_id,
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          apiName: "Protector_API",
          document: '''
            mutation deleteInstitutionCommentBoardTable(\$input: DeleteInstitutionCommentBoardTableInput!) {
                  deleteInstitutionCommentBoardTable(input: \$input) {
                    USER_ID
                    BOARD_ID
               }  
              }
            ''',
          variables: {
            'input': row,
          },
        ),
      )
          .response;
      {
        final deletedData = response.data;
        if (deletedData == null ||
            jsonDecode(deletedData!)['deleteInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${deletedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<bool?> createCommentConversationdata(
      String board_id, String writer, String content, String email) async {
    final time = '${TemporalDateTime.now()}';

    final row = {
      'BOARD_ID': board_id,
      'CONVERSATION_ID': time,
      'CONTENT': content,
      'WRITER': writer,
      'EMAIL': email,
      'createdAt': time,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          apiName: "Protector_API",
          variables: {
            'input': row,
          },
          document: '''
            mutation createInstitutionCommentConversationTable(\$input: CreateInstitutionCommentConversationTableInput!) {
                  createInstitutionCommentConversationTable(input: \$input) {
	                  BOARD_ID
	                  CONVERSATION_ID
	                  WRITER
	                  CONTENT
	                  EMAIL
	                  createdAt
	                  updatedAt
               }  
              }
            ''',
        ),
      )
          .response;
      {
        final createdData = response.data;
        if (createdData == null ||
            jsonDecode(createdData!)[
            'createInstitutionCommentConversationTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${createdData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<List<InstitutionCommentConversationTable?>>
  listInstitutionCommentConversation(String boardId,
      {String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query ListInstitutionCommentConversationTables(\$filter: TableInstitutionCommentConversationTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionCommentConversationTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                BOARD_ID
                CONVERSATION_ID
                WRITER
                CONTENT
                EMAIL
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "BOARD_ID": {"eq": boardId},
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        var data = jsonDecode(response.data);
        var items = data['listInstitutionCommentConversationTables']['items'];

        if (items == null || response.data == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        List<InstitutionCommentConversationTable?> conversations = (items
        as List)
            .map((item) => InstitutionCommentConversationTable.fromJson(item))
            .toList();
        var newNextToken =
        data['listInstitutionCommentConversationTables']['nextToken'];
        // print('nullcheck : $newNextToken');
        if (newNextToken != null) {
          // recursive call for next page's data
          var nextConversations = await listInstitutionCommentConversation(
              boardId,
              nextToken: newNextToken);
          conversations.addAll(nextConversations!);
        }

        return conversations;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  Stream<GraphQLResponse>? subscribeInstitutionCommentConversation() {
    try {
      var operation = Amplify.API.subscribe(
        GraphQLRequest(
          apiName: "Protector_API",
          document: """
     subscription onsubscribeCommentConversationTable {
        onsubscribeCommentConversationTable {
	            	    BOARD_ID
	                  CONVERSATION_ID
	                  WRITER
	                  CONTENT
	                  EMAIL
	                  createdAt
	                  updatedAt
        }
      }
    """,
        ),
        onEstablished: () {
          print("subscription success");
        },
      );

      // var response = await operation.response;
      // List<InstitutionScheduleTable> schedules =
      // (jsonDecode(response.data)['listInstitutionScheduleTables']['items']
      // as List)
      //     .map((item) => InstitutionScheduleTable.fromJson(item))
      //     .toList();
      // if (schedules == null) {
      //   print('errors: ${response.errors}');
      //   return const [];
      // }
      return operation;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future<bool?> updateCommentConversationdata(
      String board_id,
      String conversation_id,
      String content,
      ) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'BOARD_ID': board_id,
      'CONVERSATION_ID': conversation_id,
      'CONTENT': content,
      'updatedAt': time
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          apiName: "Protector_API",
          variables: {
            'input': row,
          },
          document: '''
            mutation updateInstitutionCommentConversationTable(\$input: UpdateInstitutionCommentConversationTableInput!) {
                  updateInstitutionCommentConversationTable(input: \$input) {
	            	    BOARD_ID
	                  CONVERSATION_ID
	                  WRITER
	                  CONTENT
	                  EMAIL
	                  createdAt
	                  updatedAt
               }  
              }
            ''',
        ),
      )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)[
            'updateInstitutionCommentConversationTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<bool?> deleteCommentConversationdata(
      String board_id,
      String conversation_id,
      ) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'BOARD_ID': board_id,
      'CONVERSATION_ID': conversation_id,
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          apiName: "Protector_API",
          variables: {
            'input': row,
          },
          document: '''
            mutation deleteInstitutionCommentConversationTable(\$input: DeleteInstitutionCommentConversationTableInput!) {
                  deleteInstitutionCommentConversationTable(input: \$input) {
	            	    BOARD_ID
	                  CONVERSATION_ID
	                  WRITER
	                  CONTENT
	                  EMAIL
	                  createdAt
	                  updatedAt
               }  
              }
            ''',
        ),
      )
          .response;
      {
        final deletedData = response.data;
        if (deletedData == null ||
            jsonDecode(deletedData!)[
            'deleteInstitutionCommentConversationTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${deletedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<bool?> updateCommentBoarddataForNewConversation(
      String user_id, String board_id) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': board_id,
      'NEW_CONVERSATION_PROTECTOR': true,
      'NEW_CONVERSATION_CREATEDAT': time
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          apiName: "Protector_API",
          variables: {
            'input': row,
          },
          document: '''
            mutation updateInstitutionCommentBoardTable(\$input: UpdateInstitutionCommentBoardTableInput!) {
                  updateInstitutionCommentBoardTable(input: \$input) {
	                  BOARD_ID
	                  USER_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
               }  
              }
            ''',
        ),
      )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)['updateInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }

  Future<bool?> updateCommentBoarddataForReadConversation(
      String user_id, String board_id) async {
    final time = '${TemporalDateTime.now()}';
    final row = {
      'USER_ID': user_id,
      'BOARD_ID': board_id,
      'NEW_CONVERSATION_INST': false,
    };
    try {
      final response = await Amplify.API
          .mutate(
        request: GraphQLRequest<String>(
          apiName: "Protector_API",
          variables: {
            'input': row,
          },
          document: '''
            mutation updateInstitutionCommentBoardTable(\$input: UpdateInstitutionCommentBoardTableInput!) {
                  updateInstitutionCommentBoardTable(input: \$input) {
	                  BOARD_ID
	                  USER_ID
	                  NEW_CONVERSATION_PROTECTOR
	                  NEW_CONVERSATION_INST
	                  NEW_CONVERSATION_CREATEDAT
               }  
              }
            ''',
        ),
      )
          .response;
      {
        final updatedData = response.data;
        if (updatedData == null ||
            jsonDecode(updatedData!)['updateInstitutionCommentBoardTable'] ==
                null) {
          safePrint('errors: ${response.errors}');
          return false;
        }
        safePrint('Mutation result: ${updatedData.toString()}');
        // print('User created successfully: ${response.data}');;
        return true;
      }
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
      return false;
    }
  }
}
// institution
