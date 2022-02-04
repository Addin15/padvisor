import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/pages/student/student_feedback.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:path_provider/path_provider.dart';

class UploadDoc extends StatefulWidget {
  const UploadDoc({Key? key}) : super(key: key);

  @override
  _UploadDocState createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            'assets/logo/logo_white.png',
            width: 30,
            height: 30,
          ),
        ),
        elevation: 0.0,
        backgroundColor: AppColor.primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                width: double.infinity,
                height: 350.0,
                color: AppColor.primaryColor,
              ),
            ),
            Center(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Container(
                      constraints: const BoxConstraints.tightFor(
                          width: 400, height: 400),
                      padding: EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result == null) return;

                          final file = result.files.first;
                          openFile(file);

                          print('Name ${file.name}');
                          print('Bytes ${file.bytes}');
                          print('Size ${file.size}');
                          print('Extension ${file.extension}');
                          print('Path ${file.path}');
                        },
                        child: Text(
                          'Pick File',
                          style: TextStyle(
                            fontFamily: "Reem Kufi",
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: AppColor.tertiaryColor,
                            fixedSize: const Size(300, 100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}
