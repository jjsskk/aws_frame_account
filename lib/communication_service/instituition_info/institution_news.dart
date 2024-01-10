import 'package:aws_frame_account/loading_page/loading_page.dart';
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
    _news = gql.queryInstitutionNewsByInstitutionId();
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
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingPage();

            if (snapshot.hasData) {
              snapshot.data!
                  .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final news = snapshot.data![index];
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 350, // 원하는 가로 사이즈로 조절하세요.
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
                                    getYearMonthDay(DateTime.parse(
                                            news.createdAt.toString())
                                        .toLocal()
                                        .toString()), //UTC ->KST
                                    style: TextStyle(
                                        color: Colors.black,
                                        backgroundColor: Colors.transparent,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    news.TITLE!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        backgroundColor: Colors.transparent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
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
  State<InstitutionNewsDetailPage> createState() =>
      _InstitutionNewsDetailPageState();
}

class _InstitutionNewsDetailPageState extends State<InstitutionNewsDetailPage> {
  final gql = GraphQLController.Obj;
  String title = '', content = '', url = '', image = '';

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }

  @override
  void initState() {
    // TODO: implement initState

    title = widget.news.TITLE!;
    widget.news.CONTENT != null ? content = widget.news.CONTENT! : content = '';
    widget.news.URL != null ? url = widget.news.URL! : url = '';
    widget.news.IMAGE != null ? image = widget.news.IMAGE! : image = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '기관소식 세부 정보',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20), // 글자색을 하얀색으로 설정
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/ui (4).png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  '작성일: ' +
                      getYearMonthDay(
                          DateTime.parse(widget.news.createdAt.toString())
                              .toLocal()
                              .toString()), //UTC-> KST
                ),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
                content != null ? Text(content) : Text(""),
                SizedBox(height: 16),
                url != null ? Text(url) : Text(""),
                SizedBox(height: 16),
                if (image != null)
                  if (image.isNotEmpty)
                    FutureBuilder<String>(
                      future: widget.storageService.getImageUrlFromS3(image!),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
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
      ),
    );
  }
}
