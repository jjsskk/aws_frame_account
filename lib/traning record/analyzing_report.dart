import 'package:flutter/material.dart';

class AnalyzingReportPage extends StatelessWidget {
  const AnalyzingReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('분석 보고서'),
        centerTitle: true,
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}