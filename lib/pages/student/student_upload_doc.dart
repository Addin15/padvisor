import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:padvisor/pages/api/firebase_api.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/pages/student/student_feedback.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:path/path.dart';

class UploadDoc extends StatefulWidget {
  const UploadDoc({Key? key}) : super(key: key);

  @override
  _UploadDocState createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  UploadTask? task;
  File? file;
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
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
                          width: 300, height: 100),
                      padding: EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result == null) return;

                          final path = result.files.single.path!;
                          setState(() {
                            file = File(path);
                          });
                        },
                        child: Text(
                          'Select File',
                          style: TextStyle(
                            fontFamily: "Reem Kufi",
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: AppColor.tertiaryColor,
                            fixedSize: const Size(400, 400),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Text(
                      fileName,
                      style: TextStyle(
                        fontFamily: "Reem Kufi",
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      constraints: const BoxConstraints.tightFor(
                          width: 300, height: 100),
                      padding: EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.cloud_upload_outlined),
                        onPressed: () async {
                          uploadFile();
                        },
                        label: Text(
                          'Upload File',
                          style: TextStyle(
                            fontFamily: "Reem Kufi",
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: AppColor.tertiaryColor,
                            fixedSize: const Size(400, 400),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    task != null ? buildUploadStatus(task!) : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/evidence/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100);
            return Text(
              '$percentage%',
              style: TextStyle(
                fontFamily: "Reem Kufi",
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            );
          } else {
            return Container();
          }
        },
      );
}
