import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:simialrfiguresapp/screens/home_screen.dart';
import '../widgets/square_button2.dart';

class SecondScreen extends StatelessWidget {
  final List outputs;
  final XFile image;
  final TextEditingController controller;
  const SecondScreen({super.key, required this.image, required this.controller, required this.outputs});


  Widget photoBox() {
    return Hero(
      tag: image,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2,
          ),
        ),
        width: 300,
        height: 300,
        child: Image.file(File(image.path)),
      ),
    );
  }
  String justName(){
    String a = formatLabel(outputs[0]["label"]);
    String name = a.substring(0, a.length-1);

    return name;
  }

  String postPosition(){
    String a = formatLabel(outputs[0]["label"]);
    String postPosition = a.substring(a.length-1, a.length);

    return postPosition;
  }

  int confidence(List output){
    double result = output[0]["confidence"];
    int confidence = (result * 100).round();
    return confidence;
  }
  String formatLabel(String label) {
    return label.replaceAll(RegExp(r'^\d+\s'), '');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFE0EA),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15,),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BasicText(text: '${controller.text}님은 ', fontSize: 40, color: Colors.black, fontWeight: FontWeight.w600),
                      BasicText(text: justName(), fontSize: 50, color: Colors.lightBlue, fontWeight: FontWeight.w800),
                      BasicText(text: postPosition(), fontSize: 40, color: Colors.black, fontWeight: FontWeight.w600),
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0, -15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BasicText(text: '${confidence(outputs)}% ', fontSize: 50, color: Colors.redAccent, fontWeight: FontWeight.w800),
                        const BasicText(text: '닮았습니다!', fontSize: 40, color: Colors.black, fontWeight: FontWeight.w700),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          photoBox(),
          const SizedBox(height: 30,),
          SquareButton2(color: const Color(0xffBDFCC9), text: '다시하기', onPressed: () { Navigator.pop(context);},),
          const SizedBox(height: 20,),
          SquareButton2(color: const Color(0xff83A2CD), text: '공유하기', onPressed: () { Share.share('${controller.text}님은 ${formatLabel(outputs[0]["label"])} ${confidence(outputs)}% 닮았습니다!');},),
        ],
      ),
    );
  }
}
