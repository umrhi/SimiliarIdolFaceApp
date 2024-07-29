import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simialrfiguresapp/screens/second_screen.dart';
import 'package:simialrfiguresapp/widgets/square_button1.dart';
import 'package:simialrfiguresapp/widgets/square_button3.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:image_cropper/image_cropper.dart';

import '../widgets/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List _outputs;
  XFile? _image;
  bool hasName = false;
  final ImagePicker picker = ImagePicker();
  final TextEditingController controller = TextEditingController();

  void onFieldSubmitted(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        controller.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(checkName);

    loadModel();
  }
  bool canFind() {
    return (hasName && _image != null);
  }

  void checkName() {
    setState(() {
      hasName = controller.text.isNotEmpty;
    });
  }

  Future loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future classifyImage(XFile image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0,
      imageStd: 255,
      numResults: 2,
      asynch: true,
    );
    setState(() {
      _outputs = output!;
    });
  }

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.redAccent,),
          );
        },
      );
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: const Color(0xffFFE0EA),
            activeControlsWidgetColor : Colors.black,
            backgroundColor: const Color(0xffFFE0EA),
            cropFrameColor: Colors.black,
            cropGridColor: Colors.black,
            cropGridColumnCount: 0,
            cropGridRowCount: 0,
            toolbarWidgetColor : Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
          IOSUiSettings(
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
        ],
      );
      Navigator.of(context).pop();

      if (croppedFile != null) {
        setState(() {
          _image = XFile(croppedFile.path); // 크롭된 이미지를 _image에 저장
        });
      }
    }
  }
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }



  void onPressed() async {
    await classifyImage(_image!);

    _outputs[0]['label'] != '16 x'?
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => SecondScreen(
          image: _image!,
          controller: controller,
          outputs: _outputs,
        ),
      ),
    ) : showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xffFFE0EA),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text("닮은꼴 여돌을 찾을 수 없습니다!"),
            titleTextStyle: const TextStyle(
              fontSize: 40,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
            alignment: Alignment.center,
            content: const Text(
                "눈,코,입이 모두 나온 사진, 옆모습이 아닌 앞모습인 사진을 넣어주세요."),
            contentTextStyle: const TextStyle(
              fontSize: 30,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            actions: [
              SquareButton3(color: Colors.white, text: '확인', onPressed: () {
                Navigator.pop(context);
              },),
            ],
          );
        });
  }
  void showNameCheck(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xffFFE0EA),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text("이름을 다시 확인해주세요!"),
            titleTextStyle: const TextStyle(
              fontSize: 40,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
            alignment: Alignment.center,
            content: const Text(
                "공백포함 4자 이하로 이름을 적어주세요."),
            contentTextStyle: const TextStyle(
              fontSize: 30,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            actions: [
              SquareButton3(color: Colors.white, text: '확인', onPressed: () {
                Navigator.pop(context);
              },),
            ],
          );
        });
  }

  void showManual() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xffFFE0EA),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text("사용법"),
            titleTextStyle: const TextStyle(
              fontSize: 50,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            alignment: Alignment.center,
            content: const Text(
                "앱 화면 하단의 카메라나 갤러리 버튼을 클릭해 사진을 가져와 편집하고, 이름을 입력한 뒤 나타나는 찾기 버튼을 눌러주면 끝입니다!"),
            contentTextStyle: const TextStyle(
              fontSize: 40,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            actions: [
              SquareButton3(color: Colors.white, text: '확인', onPressed: () {
                Navigator.pop(context);
              },),
            ],
          );
        });
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Hero(
      tag: _image!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2,
          ),
        ),
        width: 300,
        height: 300,
        child: Image.file(File(_image!.path)),
      ),
    )
        : Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
        ),
      ),
      width: 300,
      height: 300,
      child: const Center(
        child: Text(
          '사진을 업로드 해주세요',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'CustomFont'
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    bool exit = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xffFFE0EA),
          title: const Text('앱을 종료하시겠습니까?', style: TextStyle(
            fontSize: 30,
            fontFamily: 'CustomFont',
            fontWeight: FontWeight.w600,
            color: Colors.black,),),
          actions: <Widget>[
            SquareButton3(color: const Color(0xffBDFCC9), text: '예', onPressed: () {
              exit = true;
              Navigator.of(context).pop();
            },),
            SquareButton3(color: const Color(0xff83A2CD), text: '아니오', onPressed: () {
              Navigator.of(context).pop();
            },),

          ],
        );
      },
    );
    return exit;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (isBackButton) async {
        bool shouldPop = await _showExitDialog(context);
        if (shouldPop) {
          exit(0); // 앱 종료
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffFFE0EA),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: const EdgeInsets.only(top: 30),
                    onPressed: showManual,
                    icon: const Icon(
                      Icons.question_mark_rounded,
                      size: 35,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BasicText(text: '닮은꼴 ', fontSize: 60, color: Colors.redAccent, fontWeight: FontWeight.w700,),
                    BasicText(text: '여돌 ', fontSize: 60, color: Colors.redAccent, fontWeight: FontWeight.w700,),
                    BasicText(text: '찾기', fontSize: 50, color: Colors.black, fontWeight: FontWeight.w600,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: const BasicText(text: '2024', fontSize: 30, color: Colors.black, fontWeight: FontWeight.w600,),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              _buildPhotoArea(),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55.7),
                child: TextField(
                  style: const TextStyle(fontSize: 25, fontFamily: 'CustomFont'),
                  controller: controller,
                  onChanged: (text) {
                    onFieldSubmitted(text);
                  },
                  onSubmitted: (text) {
                    onFieldSubmitted(text);
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '이름을 입력하세요',
                    hintStyle: const TextStyle(fontFamily: 'CustomFont', fontSize: 25),
                    helperText: '최대 4자까지 입력 가능',
                    helperStyle: const TextStyle(fontFamily: 'CustomFont', fontSize: 18),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                        image: Icons.camera_alt_outlined,
                        onPressed: () {
                          getImage(ImageSource.camera);
                        }),
                    Button(
                        image: Icons.image_outlined,
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              canFind()
                  ? SquareButton1(
                color: const Color(0xffBDFCC9),
                text: '찾기',
                image: _image!,
                onPressed: controller.text.length < 5 ? onPressed : showNameCheck
              )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class BasicText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const BasicText({
    super.key, required this.text, required this.fontSize, required this.color, required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'CustomFont',
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
