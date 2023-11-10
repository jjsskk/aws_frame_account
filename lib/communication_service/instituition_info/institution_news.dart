import 'package:aws_frame_account/models/InstitutionNewsTable.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionAnnouncementTable.dart';
import '../../../provider/login_state.dart';
import '../../../storage/storage_service.dart';
import 'package:provider/provider.dart';

class InstitutionNewsPage extends StatefulWidget {
  const InstitutionNewsPage({Key? key}) : super(key: key);

  @override
  _InstitutionNewsPageState createState() => _InstitutionNewsPageState();
}

class _InstitutionNewsPageState extends State<InstitutionNewsPage> {
  late Future<List<InstitutionNewsTable>> _news;
  final gql = GraphQLController.Obj;
  final storageService = StorageService();
  late LoginState newsProvider;




  @override
  void initState() {
    super.initState();
    _news =
        gql.queryInstitutionNewsByInstitutionId(institutionId: "INST_ID_123");

  }

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/ui (4).png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<InstitutionNewsTable>>(
          future: _news,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              snapshot.data!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final news = snapshot.data![index];
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 350,  // 원하는 가로 사이즈로 조절하세요.
                      child: AspectRatio(
                        aspectRatio: 1232 / 392,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InstitutionNewsDetailPage(
                                    news: news, storageService: storageService),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('image/community (7).png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getYearMonthDay(news.createdAt.toString()),
                                    style: TextStyle(color: Colors.black, backgroundColor: Colors.transparent, fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    news.TITLE!,
                                    style: TextStyle(color: Colors.black, backgroundColor: Colors.transparent, fontWeight: FontWeight.w600, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),

                          ),
                        ),
                      ),
                    ),
                  );
                },
              );

            }

            return Center(child: Text('공지사항이 없습니다.'));
          },
        ),
      ),
    );

  }
}

class InstitutionNewsDetailPage extends StatefulWidget {
  final InstitutionNewsTable news;
  final StorageService storageService;
  InstitutionNewsDetailPage(
      {Key? key, required this.news, required this.storageService})
      : super(key: key);

  @override
  State<InstitutionNewsDetailPage> createState() => _InstitutionNewsDetailPageState();
}

class _InstitutionNewsDetailPageState extends State<InstitutionNewsDetailPage> {
  final gql = GraphQLController.Obj;
  String title = '', content  = '', url = '', image = '';

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }
  @override
  void initState() {
    // TODO: implement initState

    title = widget.news.TITLE!;
    widget.news.CONTENT  != null ? content = widget.news.CONTENT!: content = '';
    widget.news.URL!=null ?url = widget.news.URL!:url = '';
    widget.news.IMAGE!=null?image = widget.news.IMAGE!: image = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('기관소식 세부 정보'),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('작성일: ' + getYearMonthDay(widget.news.createdAt.toString())),
              SizedBox(height: 16),
              content != null ? Text(content) : Text(""),
              SizedBox(height: 16),
              url != null ? Text(url) : Text(""),
              SizedBox(height: 16),
              if (image != null)
                if (image.isNotEmpty)
                  FutureBuilder<String>(
                    future: widget.storageService.getImageUrlFromS3(image!),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        String imageUrl = snapshot.data!;
                        return Image.network(imageUrl);
                      } else if (snapshot.hasError) {
                        return Text('이미지를 불러올 수 없습니다.');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
