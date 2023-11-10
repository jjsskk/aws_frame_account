import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../GraphQL_Method/graphql_controller.dart';
import '../../../models/InstitutionAnnouncementTable.dart';
import '../../../provider/login_state.dart';
import '../../../storage/storage_service.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late Future<List<InstitutionAnnouncementTable>> _announcements;
  final gql = GraphQLController.Obj;
  final storageService = StorageService();
  late LoginState announcementProvider;

  Future<List<InstitutionAnnouncementTable>> getAnnouncements(
      String institutionId) {
    return gql.queryInstitutionAnnouncementsByInstitutionId(
        institutionId: institutionId);
  }


  @override
  void initState() {
    super.initState();

    // 초기 데이터 로딩
    _announcements = getAnnouncements("INST_ID_123");
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
        child: FutureBuilder<List<InstitutionAnnouncementTable>>(
          future: _announcements,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              snapshot.data!.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final announcement = snapshot.data![index];
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
                                builder: (context) => AnnouncementDetailPage(
                                    announcement: announcement, storageService: storageService),
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
                                    getYearMonthDay(announcement.createdAt.toString()),
                                    style: TextStyle(color: Colors.black, backgroundColor: Colors.transparent, fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    announcement.TITLE!,
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

class AnnouncementDetailPage extends StatefulWidget {
  final InstitutionAnnouncementTable announcement;
  final StorageService storageService;

  AnnouncementDetailPage(
      {Key? key, required this.announcement, required this.storageService})
      : super(key: key);

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  final gql = GraphQLController.Obj;

  String title = '', content  = '', url = '', image = '';

  String getYearMonthDay(String dateString) {
    return dateString.substring(0, 10);
  }


  bool isUpdated = false;
  @override
  void initState() {
    title = widget.announcement.TITLE!;
    widget.announcement.CONTENT  != null ? content = widget.announcement.CONTENT!: content = '';
    widget.announcement.URL!=null ?url = widget.announcement.URL!:url = '';
    widget.announcement.IMAGE!=null?image = widget.announcement.IMAGE!: image = '';
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항 세부 정보'),
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
              Text(
                  '작성일: ' + getYearMonthDay(widget.announcement.createdAt.toString())),
              SizedBox(height: 16),
              content != null ? Text(content) : Text(""),
              SizedBox(height: 16),
              url != null ? Text(url) : Text(""),
              SizedBox(height: 16),
              if (image != null)
                if (image!.isNotEmpty)
                  FutureBuilder<String>(
                    future:
                    widget.storageService.getImageUrlFromS3(image!),
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
