import 'package:aws_frame_account/analytics/analytics_events.dart';
import 'package:aws_frame_account/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class VerificationPage extends StatefulWidget {
  // final ValueChanged<String> didProvideVerificationCode;
  final Future<void> Function(String value, BuildContext context) didProvideVerificationCode;

  VerificationPage({Key? key, required this.didProvideVerificationCode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationCodeController = TextEditingController();
  bool showspiner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ModalProgressHUD(
        inAsyncCall: showspiner,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 40),
            child: _verificationForm(),
          ),
        ),
      ),
    );
  }

  Widget _verificationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Verification Code TextField
        TextField(
          style: const TextStyle(color: Colors.white),
          controller: _verificationCodeController,
          decoration: InputDecoration(
              icon: Icon(
                Icons.confirmation_number,
                color: Colors.white,
              ),
              labelText: '인증코드',
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2))),
        ),
        SizedBox(
          height: 20,
        ),
        // Verify Button
        ElevatedButton(
            onPressed: _verify,
            child: Text('Verify',style: TextStyle(fontWeight: FontWeight.bold),),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple))
      ],
    );
  }

  void _verify() async{
    setState(() {
      showspiner = true;
    });
    final verificationCode = _verificationCodeController.text.trim();
    await widget.didProvideVerificationCode(verificationCode, context);
    // AnalyticsService.log(VerificationEvent());
    setState(() {
      showspiner = false;
    });
  }
}
