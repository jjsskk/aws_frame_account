import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';

//needed when using queryItem method
import 'package:aws_frame_account/models/Todo.dart';
import 'package:aws_frame_account/models/MonthlyDBTest.dart';
import 'package:aws_frame_account/models/UserDBTest.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:math';

class GraphQLController {
  GraphQLController();

  static final _Obj = GraphQLController();

  //user
  var birth = 19640101;
  var userid = "2";
  var useridint = 2;

  //brain signal
  var brainmonth = "20230101";

  static get Obj => _Obj;

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
        id: "1",
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
      final response = await Amplify.API.mutate(request: request).response;
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
    const ID = '1234';
    // final queryPredicatemonth = MonthlyDBTest.MONTH.eq(ID);
    // final queryPredicate = MonthlyDBTest.ID.eq(ID).and(queryPredicatemonth);
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

  Future<List<MonthlyDBTest?>> queryListMonthlyDBItems() async {
    try {
      const ID = '1';
      final queryPredicate = MonthlyDBTest.ID.eq(ID);
      final request = ModelQueries.list(
        MonthlyDBTest.classType,
        where: queryPredicate,
        limit: 12
      );
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

  Future<UserDBTest?> queryUserDBItem() async {
    const ID = '1234';
    final queryPredicate = UserDBTest.ID.eq(ID);

    try {
      final request = ModelQueries.list<UserDBTest>(
        UserDBTest.classType,
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

  Future<List<UserDBTest?>> queryListUserDBItems() async {
    try {
      final request = ModelQueries.list(UserDBTest.classType);
      final response = await Amplify.API.query(request: request).response;

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
}
