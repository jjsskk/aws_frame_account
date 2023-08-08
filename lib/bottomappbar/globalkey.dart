import 'package:flutter/material.dart';


class KeyForBottomAppbar {
 final GlobalKey<ScaffoldState> _key = GlobalKey(); // 보통 이건 하단 스낵바를 만들때 사용한다.

  GlobalKey<ScaffoldState> get key => _key; //요걸 반환함 GlobalKey
  // 이 친구는 글로벌 키를 통해서 ScaffoldState를 리턴한다.
  // KeyForBottomAppbar 클래스는 GlobalKey를
// 이용하여 ScaffoldState에 대한 참조를 저장할 수 있는 클래스입니다.
// 이 클래스의 인스턴스는 앱의 스캐폴드 상태에 전역적으로 액세스할 수 있는 글로벌 키를 관리하는 데 사용됩니다.

  // GlobalKey<ScaffoldState> getKey()
  // {
  //   return GlobalKey();
  // }
}