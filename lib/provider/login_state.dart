import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginState extends ChangeNotifier {

  //comment
  void Function(String userId)? _detectCommentChange =
  null;

  Function(String userId)? get detectCommentChange =>
      _detectCommentChange;

  set detectCommentChange(Function(String userId)? func) {
    print('register detectCommentChange');
    _detectCommentChange = func;
    // notifyListeners();
  }

}
