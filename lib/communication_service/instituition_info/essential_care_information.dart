import 'dart:math';

import 'package:aws_frame_account/GraphQL_Method/graphql_controller.dart';
import 'package:aws_frame_account/models/InstitutionEssentialCareTable.dart';
import 'package:aws_frame_account/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EssentialCareInfoPage extends StatefulWidget {
  const EssentialCareInfoPage({Key? key}) : super(key: key);

  @override
  State<EssentialCareInfoPage> createState() => _EssentialCareInfoPageState();
}

//todo: 유저 테이블에서 가져올 수 있게
//todo: 질문 사항: 유저 테이블에서 연동
class _EssentialCareInfoPageState extends State<EssentialCareInfoPage> {
  List<InstitutionEssentialCareTable> _essentialCare = [];
  final StorageService storageService = StorageService();
  late final gql;
  int index = 0;
  String imageUrl = "";
  String _userid = "";
  List<String> nameList = [];
  String name = '';
  String essentialName = '';
  String birth = '';
  String phoneNumber = '';
  String medication = "";
  String medicationWay = "";
  String institutionId = "";
  String institution = '';

  String convertToE164(String phoneNumber, String countryCode) {
    // 전화번호의 맨 앞자리가 0인 경우, 국가 코드로 대체
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(3);
    }

    return countryCode + phoneNumber;
  }

  Future<void> getEssentialCare() async {
    _essentialCare = [];
    await gql
        .queryEssentialCareInformationByInstitutionIdAndUserId(userId: "2")
        .then((value) {
      if (value != null && value.isNotEmpty) {
        var care = value.first; // 첫 번째 아이템만 사용합니다.
        String tempName = care.NAME! != '' ? "${care.NAME!}" : '';
        nameList = tempName != null
            ? [tempName]
            : []; // nameList에는 첫 번째 아이템의 이름만 들어갑니다.
        setState(() {
          _essentialCare = [care]; // _essentialCare에는 첫 번째 아이템만 들어갑니다.
          name = tempName ?? '';
          print("name");
          print(name);

          essentialName = care.NAME ?? "";
          birth = care.BIRTH ?? "";
          phoneNumber = care.PHONE_NUMBER != null
              ? convertToE164(care.PHONE_NUMBER!, "0")
              : "";
          medication = care.MEDICATION ?? "";
          medicationWay = care.MEDICATION_WAY ?? "";
          imageUrl = care.IMAGE ?? "";
          _userid = care.USER_ID ?? "";
          institutionId = care.INSTITUTION_ID ?? "";
          institution = care.INSTITUTION ?? "";
        });
      } else {
        setState(() {
          _essentialCare = []; // 데이터가 없는 경우 이미지 URL을 빈 문자열로 설정
        });
      }
    }).catchError((error) {
      setState(() {
        _essentialCare = []; // 에러 발생 시 이미지 URL을 빈 문자열로 설정
      });
      print("Error fetching data: $error");
    });
  }

  void initState() {
    super.initState();
    nameList = [];
    gql = GraphQLController.Obj;
    index = 0; //맨 처음 dropdown
    getEssentialCare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.white, size: 35),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(
          '이용자 돌봄 정보',
          style: TextStyle(color: Colors.white), // 글자색을 하얀색으로 설정
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // SizedBox(height:20),
          imageUrl != ""
              ? FutureBuilder<String>(
                  future: storageService.getImageUrlFromS3(imageUrl),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      String careImageUrl = snapshot.data!;
                      return Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(careImageUrl),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('이미지를 불러올 수 없습니다.');
                    }
                    return CircularProgressIndicator();
                  })
              : Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('image/community (14).png'),
                    ),
                  ),
                ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("이름: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  Container(
                    decoration: BoxDecoration(
                      color:Color(0xFFD3D8EA),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(essentialName,style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(),
              ),
              Row(
                children: [
                  Text("생년월일: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  Container(
                    decoration: BoxDecoration(
                      color:Color(0xFFD3D8EA),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(birth,style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ],
          ),


          SizedBox(height: 30),
          Row(
            children: [
              Text("전화번호: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              Container(
                  decoration: BoxDecoration(
                    color:Color(0xFFD3D8EA),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(phoneNumber,style: TextStyle(fontSize: 15)),
                  ),
                ),

            ],
          ),
          SizedBox(height: 30),
          medication != ""
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("복용약: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
               Container(
                 decoration: BoxDecoration(
                   color:Color(0xFFD3D8EA),
                   borderRadius: BorderRadius.all(Radius.circular(20)),
                 ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(medication,style: TextStyle(fontSize: 15)),
                  ),
                ),

            ],
          )
              : Text(""),
          SizedBox(height: 30),
          medicationWay != ""
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("복용법: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              SizedBox(width: 5,),
               Container(
                 decoration: BoxDecoration(
                   color:Color(0xFFD3D8EA),
                   borderRadius: BorderRadius.all(Radius.circular(20)),
                 ),
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(medicationWay, style: TextStyle(fontSize: 15),)
                  ),
                ),

            ],
          )
              : Text(""),

          SizedBox(height: 16),
        ],
      ),
    );
  }
}
