import 'dart:convert';

import 'package:amplify_core/amplify_core.dart';
import 'package:aws_frame_account/models/InstitutionAnnouncementTable.dart';
import 'package:aws_frame_account/models/InstitutionCommentBoardTable.dart';
import 'package:aws_frame_account/models/InstitutionCommentConversationTable.dart';
import 'package:aws_frame_account/models/InstitutionEssentialCareTable.dart';
import 'package:aws_frame_account/models/InstitutionEventScheduleTable.dart';
import 'package:aws_frame_account/models/InstitutionFoodTable.dart';
import 'package:aws_frame_account/models/InstitutionNewsTable.dart';
import 'package:aws_frame_account/models/InstitutionShuttleTimeTable.dart';
import 'package:aws_frame_account/models/MonthlyBrainSignalTable.dart';
import 'package:aws_frame_account/models/UserTable.dart';
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
  String _institutionNumber = '';

  // user table info
  String _userNumber = ''; //= userId
  String _userBirth = '';
  String _userName = '';

  void resetVariables() {
    // protector's attribute info
    _protectorEmail = '';
    _protectorName = '';
    _protectorPhonenumber = '';
    _institutionNumber = '';

    // user table info
    _userNumber = '';
    _userBirth = '';
    _userName = '';
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

  //기관 공지사항 불러오기
  Future<List<InstitutionAnnouncementTable>>
      queryInstitutionAnnouncementsByInstitutionId(
          {String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query ListInstitutionAnnouncementTables(\$filter: TableInstitutionAnnouncementTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionAnnouncementTables(filter: \$filter, limit: \$limit, nextToken: \$nextToken) {
              items {
                ANNOUNCEMENT_ID
                CONTENT
                IMAGE
                INSTITUTION
                INSTITUTION_ID
                TITLE
                URL
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionNumber}
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;

      print(response.data);

      var data = jsonDecode(response.data);
      var items = data['listInstitutionAnnouncementTables']['items'];

      if (items == null || response.data == null) {
        print('errors: ${response.errors}');
        return const [];
      }

      List<InstitutionAnnouncementTable> announcements = (items as List)
          .map((item) => InstitutionAnnouncementTable.fromJson(item))
          .toList();

      var newNextToken = data['listInstitutionAnnouncementTables']['nextToken'];

      if (newNextToken != null) {
        // recursive call for next page's data
        var additionalItems =
            await queryInstitutionAnnouncementsByInstitutionId(
                nextToken: newNextToken);
        announcements.addAll(additionalItems);
      }

      return announcements;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  //기관 뉴스 불러오기
  Future<List<InstitutionNewsTable>> queryInstitutionNewsByInstitutionId(
      { String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
      query ListInstitutionNewsTables(\$filter: TableInstitutionNewsTableFilterInput, \$limit: Int, \$nextToken: String) {
      listInstitutionNewsTables(filter: \$filter, limit: \$limit, nextToken: \$nextToken) {
      items {
      NEWS_ID
      CONTENT
      IMAGE
      INSTITUTION
      INSTITUTION_ID
      TITLE
      URL
      createdAt
      updatedAt
      }
      nextToken
      }
      }
      """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionNumber}
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;

      print(response.data);

      var data = jsonDecode(response.data);
      var items = data['listInstitutionNewsTables']['items'];

      if (items == null || response.data == null) {
        print('errors: ${response.errors}');
        return const [];
      }

      List<InstitutionNewsTable> news = (items as List)
          .map((item) => InstitutionNewsTable.fromJson(item))
          .toList();

      var newNextToken = data['listInstitutionNewsTables']['nextToken'];

      if (newNextToken != null) {
        // recursive call for next page's data
        var additionalItems = await queryInstitutionNewsByInstitutionId(
           nextToken: newNextToken);
        news.addAll(additionalItems);
      }

      return news;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  // 기관 편의사항 식단 사진 불러오기
  Future<InstitutionFoodTable?> queryFoodByInstitutionIdAndDate(
 String date) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query ListInstitutionFoodTables(\$INSTITUTION_ID: String, \$DATE: String) {
            listInstitutionFoodTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}, DATE: {eq: \$DATE}}) {
              items {
                DATE
                INSTITUTION_ID
                IMAGE_URL
                createdAt
                updatedAt
              }
            }
          }
        """,
          variables: {"INSTITUTION_ID": institutionNumber, "DATE": date},
        ),
      );
      var response = await operation.response;

      InstitutionFoodTable food =
          (jsonDecode(response.data)['listInstitutionFoodTables']['items']
                  as List)
              .map((item) => InstitutionFoodTable.fromJson(item))
              .toList()
              .first;
      if (food == null) {
        print('errors: ${response.errors}');

        return null;
      }
      // print(food);
      return food;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  // 기관 편의사항 셔틀 버스 사진 불러오기
  Future<InstitutionShuttleTimeTable?> queryShuttleTimeByInstitutionId(
    ) async {
    // print(institutionId);
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query ListInstitutionShuttleTimeTables(\$INSTITUTION_ID: String) {
            listInstitutionShuttleTimeTables(filter: {INSTITUTION_ID: {eq: \$INSTITUTION_ID}}) {
              items {
                INSTITUTION_ID
                IMAGE_URL
                createdAt
                updatedAt
              }
            }
          }
        """,
          variables: {
            "INSTITUTION_ID": institutionNumber,
          },
        ),
      );
      var response = await operation.response;
      print(response.data);
      var responseData = jsonDecode(response.data);
      List<dynamic> items =
          responseData['listInstitutionShuttleTimeTables']['items'];

      InstitutionShuttleTimeTable shuttleTime =
          InstitutionShuttleTimeTable.fromJson(items[0]);

      if (shuttleTime == null) {
        print('errors: ${response.errors}');

        return null;
      }
      print(shuttleTime);
      return shuttleTime;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  //기관 필수돌봄 정보 불러오기
  Future<List<InstitutionEssentialCareTable>>
      queryEssentialCareInformationByInstitutionIdAndUserId(
          { String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
        query ListInstitutionEssentialCareTables(\$filter: TableInstitutionEssentialCareTableFilterInput, \$limit: Int, \$nextToken: String) {
          listInstitutionEssentialCareTables(filter: \$filter, limit: \$limit, nextToken: \$nextToken) {
            items {
              BIRTH
              INSTITUTION
              INSTITUTION_ID
              MEDICATION
              IMAGE
              MEDICATION_WAY
              NAME
              PHONE_NUMBER
              USER_ID
              createdAt
              updatedAt
            }
            nextToken
          }
        }
      """,
          variables: {
            "filter": {
              "USER_ID": {"eq": userNumber}
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;

      print(response.data);

      var data = jsonDecode(response.data);
      var items = data['listInstitutionEssentialCareTables']['items'];

      if (items == null || response.data == null) {
        print('errors: ${response.errors}');
        return const [];
      }

      List<InstitutionEssentialCareTable> essentialCare = (items as List)
          .map((item) => InstitutionEssentialCareTable.fromJson(item))
          .toList();

      var newNextToken =
          data['listInstitutionEssentialCareTables']['nextToken'];

      if (newNextToken != null) {
        // recursive call for next page's data
        var additionalItems =
            await queryEssentialCareInformationByInstitutionIdAndUserId(
                nextToken: newNextToken);
        essentialCare.addAll(additionalItems);
      }

      return essentialCare;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

//todo: 안됨
  Future<List<InstitutionEssentialCareTable>>
      queryEssentialCareInformationByInstitutionId(
          {required String institutionId, String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query ListInstitutionEssentialCareTables(\$filter: TableInstitutionEssentialCareTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionEssentialCareTables(filter: \$filter, limit: \$limit, nextToken: \$nextToken) {
              items {
                BIRTH
                INSTITUTION
                INSTITUTION_ID
                MEDICATION
                IMAGE
                MEDICATION_WAY
                NAME
                PHONE_NUMBER
                USER_ID
                createdAt
				  updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionId}
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;

      print(response.data);

      var data = jsonDecode(response.data);
      var items = data['listInstitutionEssentialCareTables']['items'];

      if (items == null || response.data == null) {
        print('errors: ${response.errors}');
        return const [];
      }

      List<InstitutionEssentialCareTable> essentialCare = (items as List)
          .map((item) => InstitutionEssentialCareTable.fromJson(item))
          .toList();

      var newNextToken =
          data['listInstitutionEssentialCareTables']['nextToken'];

      if (newNextToken != null) {
        // recursive call for next page's data
        var additionalItems =
            await queryEssentialCareInformationByInstitutionId(
                institutionId: institutionId, nextToken: newNextToken);
        essentialCare.addAll(additionalItems);
      }

      return essentialCare;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  // 진수

  //CLI로 만든 UserDBTestTable 훈련자 가공 데이터 만들기
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

  //CLI로 만든 MonthlyDBTest 테이블에 훈련자 가공 데이터 만들기
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

  // MonthlyBrainSignalTable에서 해당 훈련자의 1년치 데이터 가져오기 -> sorting을 통해 최신데이터 얻기는 각 페이지에서 구현됨
  Future<List<MonthlyBrainSignalTable?>> queryMonthlyDBLatestItem(
      {String? nextToken}) async {
    int currentMonth = DateTime.now().month;
    int day = DateTime.now().day;
    String currentDate =
        '${DateTime.now().year}${currentMonth > 9 ? currentMonth : '0$currentMonth'}40';
    String compareDate =
        '${DateTime.now().year - 1}${currentMonth > 9 ? currentMonth : '0$currentMonth'}01';
    print(currentDate);
    try {
      // var ID = '1';

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query listMonthlyBrainSignalTables(\$filter: TableMonthlyBrainSignalTableFilterInput, \$limit: Int, \$nextToken: String) {
            listMonthlyBrainSignalTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
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
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "id": {"eq": userNumber},
              "month": {
                "between": [compareDate, currentDate]
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        // print("asdf");
        // print(response.data);
        // print("1234");

        var data = jsonDecode(response.data);
        var items = data['listMonthlyBrainSignalTables']['items'];

        if (items == null || response.data == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        // Handle items as needed
        List<MonthlyBrainSignalTable?> monthlyDBTests = (items as List)
            .map((item) => MonthlyBrainSignalTable.fromJson(item))
            .toList();
        var newNextToken = data['listMonthlyBrainSignalTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var additionalItems =
              await queryMonthlyDBLatestItem(nextToken: newNextToken);
          monthlyDBTests.addAll(additionalItems);
        }

        return monthlyDBTests;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  // 특정 훈련자의 특정 월의 MonthlyBrainSignalTable의 인지훈련 데이터 얻기
  Future<List<MonthlyBrainSignalTable?>> queryMonthlyDBRequiredItem(
      String selectedAgeUserId, int yearMonth,
      {String? nextToken}) async {
    try {
      // var ID = '1';

      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query listMonthlyBrainSignalTables(\$filter: TableMonthlyBrainSignalTableFilterInput, \$limit: Int, \$nextToken: String) {
            listMonthlyBrainSignalTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
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
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "id": {"eq": selectedAgeUserId},
              "month": {
                "between": [yearMonth.toString(), (yearMonth + 40).toString()]
              },
            },
            "limit": 1000,
            "nextToken": nextToken,
          },
        ),
      );

      var response = await operation.response;
      {
        print("asdf");
        print(response.data);
        print("1234");

        var data = jsonDecode(response.data);
        var items = data['listMonthlyBrainSignalTables']['items'];

        if (items == null || response.data == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        // Handle items as needed
        List<MonthlyBrainSignalTable?> monthlyDBTests = (items as List)
            .map((item) => MonthlyBrainSignalTable.fromJson(item))
            .toList();
        var newNextToken = data['listMonthlyBrainSignalTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var additionalItems = await queryMonthlyDBRequiredItem(
              selectedAgeUserId, yearMonth,
              nextToken: newNextToken);
          monthlyDBTests.addAll(additionalItems);
        }

        return monthlyDBTests;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  // UserTable에서 해당 훈련자 정보 불러오기
  Future<UserTable?> queryUserDBItem(String id) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query getUserTable(\$ID:String!) {
            getUserTable(
              ID: \$ID
            ) {
                ID
                BIRTH
                CREATEDAT
                INSTITUTION
                INSTITUTION_ID
                NAME
                SEX
                UPDATEDAT
              }
          }
        """,
          variables: {
            "ID": id,
          },
        ),
      );

      var response = await operation.response;
      {
        var data = jsonDecode(response.data);
        var item = data['getUserTable'];
        if (response.data == null || item == null) {
          print('errors: ${response.errors}');
          return null;
        }

        UserTable? User = UserTable.fromJson(item);

        return User;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  //분석 보고서 페이지에서 해당 훈련자와 같은 나이대의 훈련자들의 데이터를 불러오기
  Future<List<UserTable?>> queryListUserDBItemsForAverageAge(int start, int end,
      {String? nextToken}) async {
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query ListUserTables(\$filter: TableUserTableFilterInput, \$limit: Int, \$nextToken: String) {
            listUserTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                ID
                BIRTH
                CREATEDAT
                INSTITUTION
                INSTITUTION_ID
                NAME
                SEX
                UPDATEDAT
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {

              "BIRTH": {
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
        var items = data['listUserTables']['items'];
        if (response.data == null || items == null) {
          print('errors: ${response.errors}');
          return const [];
        }

        List<UserTable?> Users =
            (items as List).map((item) => UserTable.fromJson(item)).toList();
        var newNextToken = data['listUserTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var nextUsers = await queryListUserDBItemsForAverageAge(start, end,
              nextToken: newNextToken);
          Users.addAll(nextUsers);
        }

        return Users;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }

  // 코멘트 페이지들 관련 함수들
  //코멘트 생성하기
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

  // 코멘트 테이블의 CRUD 감지하도록 구독하는 함수
  Stream<GraphQLResponse>? subscribeInstitutionCommentBoard() {
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

      return operation;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  //한달 단위로 코멘트 불러오기
  Future<List<InstitutionCommentBoardTable?>> listInstitutionCommentBoard(
      String filterName, String year, String month,
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
              filterName: {"eq": userNumber},
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

  // 특정 코멘트 1개 불러오기
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
	                  INSTITUTION_ID
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
                    INSTITUTION_ID
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

  // 상세 코멘트 보기 페이지 (Detail_comment.dart)에서 댓글을 위한 함수들 (conversation = 댓글)
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

  // 특정 코멘트의 댓글들 불러오기
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

  //InstitutionCommentConversation Table의 CRUD 감지를 구독하는 함수
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

//보호자가 최신 댓글을 달았음을 NEW_CONVERSATION_PROTECTOR column을 true로 표시하도록 업데이트
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

  // 기관이 최신 댓글 단 코멘트를 보호자가 읽었음을 저장하기 위한 함수
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

  //기관이 등록한 스케줄들을 한달단위로 불러오는 함수
  Future<List<InstitutionEventScheduleTable?>>
      queryInstitutionScheduleByInstitutionId( String date,
          {String? nextToken}) async {
    String inst_id = 'aaa';
    int dateNext = int.parse(date);
    dateNext += 40;
    try {
      var operation = Amplify.API.query(
        request: GraphQLRequest(
          apiName: "Protector_API",
          document: """
          query ListInstitutionEventScheduleTables(\$filter: TableInstitutionEventScheduleTableFilterInput, \$limit: Int, \$nextToken: String) {
            listInstitutionEventScheduleTables(
              filter: \$filter,
              limit: \$limit,
              nextToken: \$nextToken
            ) {
              items {
                INSTITUTION_ID
                SCHEDULE_ID
                CONTENT
                TAG
                TIME
                DATE
                createdAt
                updatedAt
              }
              nextToken
            }
          }
        """,
          variables: {
            "filter": {
              "INSTITUTION_ID": {"eq": institutionNumber},
              "DATE": {
                "between": [date, '$dateNext']
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
        var items = data['listInstitutionEventScheduleTables']['items'];

        if (items == null || response.data == null) {
          print('errors: ${response.errors}');
          return const [];
        }
        List<InstitutionEventScheduleTable?> schedules = (items as List)
            .map((item) => InstitutionEventScheduleTable.fromJson(item))
            .toList();
        var newNextToken =
            data['listInstitutionEventScheduleTables']['nextToken'];

        if (newNextToken != null) {
          // recursive call for next page's data
          var nextSchedules = await queryInstitutionScheduleByInstitutionId(
              date,
              nextToken: newNextToken);
          schedules.addAll(nextSchedules);
        }

        return schedules;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
      return const [];
    }
  }
}

