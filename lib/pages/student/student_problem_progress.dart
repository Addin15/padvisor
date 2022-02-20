import 'package:flutter/material.dart';
import 'package:padvisor/pages/services/database.dart';
import 'package:padvisor/pages/student/student_feedback.dart';
import 'package:padvisor/pages/student/student_upload_doc.dart';
import 'package:padvisor/shared/color_constant.dart';

import '../sign_in.dart';

class StudentProblem extends StatefulWidget {
  final problem;
  final typeproblem;

  StudentProblem(this.typeproblem, this.problem, {Key? key}) : super(key: key);

  @override
  _StudentProblemState createState() => _StudentProblemState();
}

class _StudentProblemState extends State<StudentProblem> {
  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
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
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        widget.typeproblem,
                        style: TextStyle(
                          fontFamily: "Reem Kufi",
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(80),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              offset: const Offset(0.0, 15.0),
                              color: AppColor.primaryColor,
                            )
                          ],
                        ),
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.problem,
                              hintStyle: TextStyle(
                                color: AppColor.primaryColor,
                              )),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UploadDoc()));
                            },
                            child: Text(
                              'Upload Report',
                              style: TextStyle(
                                  color: AppColor.primaryColor, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const StudentFeedback()));
                            },
                            child: Text(
                              'Give Feedback',
                              style: TextStyle(
                                  color: AppColor.primaryColor, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
