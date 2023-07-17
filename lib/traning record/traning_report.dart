import 'package:aws_frame_account/traning%20record/analyzing_report.dart';
import 'package:aws_frame_account/traning%20record/brain_signal_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//needed when using queryItem method
import 'package:aws_frame_account/models/Todo.dart';
import 'package:aws_frame_account/models/MonthlyDBTest.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class TraningReportPage extends StatefulWidget {
  TraningReportPage({Key? key}) : super(key: key);

  @override
  State<TraningReportPage> createState() => _TraningReportPageState();
}

class _TraningReportPageState extends State<TraningReportPage> {
  String CON_SCORE = '';

  // 주의력 점수
  String SPACETIME_SCORE = '';

  //시공간 점수
  String EXEC_SCORE = '';

  //집행기능 점수
  String MEM_SCORE = '';

  // 기억력 점수
  String LING_SCORE = '';

  //언어기능 점수
  String CAL_SCORE = '';

  //계산력 점수
  String REAC_SCORE = '';

  //반응속도 점수
  String ORIENT_SCORE = '';

  //지남력점수
  @override
  void initState() {
    super.initState();
    queryItem().then((value) {
      setState(() {
        CON_SCORE = "${value!.con_score}";
        SPACETIME_SCORE = "${value!.spacetime_score}";
        EXEC_SCORE = "${value!.exec_score}";
        MEM_SCORE = "${value!.mem_score}";
        LING_SCORE = "${value!.ling_score}";
        CAL_SCORE = "${value!.cal_score}";
        REAC_SCORE = "${value!.reac_score}";
        ORIENT_SCORE = "${value!.orient_score}";
      });
    });
  }

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
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('훈련보고서'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text("홍길동님의 두되나이"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('image/brain.jpg'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('홍길동님의 두뇌 \n나이는 10세!')
                  ],
                ),
                Divider(
                  thickness: 2.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("최근 훈련 참여도"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('영역별 성취도'),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [Text('Top1')],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [Text('Top2')],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [Text('Top3')],
                        )
                      ],
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 5,
                        child: VerticalDivider(
                          thickness: 2.0,
                          width: 20,
                          endIndent: 0,
                          indent: 20,
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('영역별 수행도'),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [Text('Top1')],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [Text('Top2')],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [Text('Top3')],
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("영역별 평균 점수"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CON_SCORE == ''
                            ? CircularProgressIndicator()
                            : Text(CON_SCORE),
                        Text('주의력 점수'),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        SPACETIME_SCORE == ''
                            ? CircularProgressIndicator()
                            : Text(SPACETIME_SCORE),
                        Text('시공간 점수'),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        EXEC_SCORE == ''
                            ? CircularProgressIndicator()
                            : Text(EXEC_SCORE),
                        Text('집행기능 점수'),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        MEM_SCORE == ''
                            ? CircularProgressIndicator()
                            : Text(MEM_SCORE),
                        Text('기억력 점수'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        LING_SCORE == ''
                            ? CircularProgressIndicator()
                            : Text(LING_SCORE),
                        Text('언어기능 점수'),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        CON_SCORE == ''
                            ? CircularProgressIndicator()
                            : Text(CON_SCORE),
                        Text('계산력 점수'),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        REAC_SCORE == ''
                            ? CircularProgressIndicator()
                            : Text(REAC_SCORE),
                        Text('반응속도 점수'),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        ORIENT_SCORE == ''
                            ? CircularProgressIndicator()
                            : Text(ORIENT_SCORE),
                        Text('지남력 점수'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("세부 결과 그래프"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnalyzingReportPage()),
                          );
                        },
                        icon: Icon(Icons.analytics),
                        label: Text('분석 보고서')),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BrainSignalPage()),
                          );
                        },
                        icon: Icon(Icons.graphic_eq),
                        label: Text('뇌 신호 그래프')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}