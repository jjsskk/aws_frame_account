import 'package:aws_frame_account/controller/graph_controller.dart';
import 'package:aws_frame_account/graph/linechart.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key, required this.didtogglegraph}) : super(key: key);
  final VoidCallback didtogglegraph;

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {

  List<String> csvlist =[];
 late String csvname;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
            onPressed: widget.didtogglegraph,
            icon: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
        title: Text('Graph Page'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
       body: csvlist.length == 0 ? Center(child: CircularProgressIndicator()) : Linechart(csvlist: csvlist,)


    );
  }
  @override
  void initState() {
    super.initState();
    // downloadFile();
    configure();
  }
  void configure() async{
    final listOptions =
    S3ListOptions(accessLevel: StorageAccessLevel.protected);
    // 4 다음으로 S3ListOptions을 지정하여 모든 관련 사진을 나열하도록 Storage에 요청합니다.
    final result = await Amplify.Storage.list(options: listOptions);


    for(var item in result.items){
      if( item.key != ''){
        // print('list : ${item.key}');
      Get.put(GraphController(csvname: item.key),tag: item.key);
      setState(() {
      csvlist.add(item.key);
      });
      }
    }
    csvname =csvlist.first;

  }
  // Future<void> downloadFile() async {
  //   final documentsDir = await getApplicationDocumentsDirectory();
  //   final filepath = documentsDir.path + '/20230206_165833_Spectrum.csv';
  //   final file = File(filepath);
  //   print('file path : '+filepath);
  //
  //   // final listOptions =
  //   // S3ListOptions(accessLevel: StorageAccessLevel.private);
  //   final downloadOptions = S3DownloadFileOptions(
  //     accessLevel: StorageAccessLevel.protected,
  //     // e.g. us-west-2:2f41a152-14d1-45ff-9715-53e20751c7ee
  //
  //   );
  //
  //   try {
  //     final result = await Amplify.Storage.downloadFile(
  //       key: '20230206_165833_Spectrum.csv',
  //       local: file,
  //       options:downloadOptions ,
  //       onProgress: (progress) {
  //         safePrint('Fraction completed: ${progress.getFractionCompleted()}');
  //       },
  //     );
  //     final contents = result.file.readAsStringSync();
  //     setState(() {
  //       rawdata = contents;
  //     });
  //     // Or you can reference the file that is created above
  //     // final contents = file.readAsStringSync();
  //     safePrint('Downloaded contents: $contents');
  //   } on StorageException catch (e) {
  //     safePrint('Error downloading file: $e');
  //   }
  // }




}
