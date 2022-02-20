import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:padvisor/pages/services/auth.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/pages/student/student_feedback.dart';
import 'package:padvisor/shared/color_constant.dart';

class AddReport extends StatefulWidget {
  const AddReport({Key? key}) : super(key: key);

  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  String dropdownvalue = 'Low Attendance';
  TextEditingController _problem = new TextEditingController();
  String url = '';
  String status = 'submitted';

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
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        'What is your problem?',
                        style: TextStyle(
                          fontFamily: "Reem Kufi",
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      DropdownButton<String>(
                        dropdownColor: AppColor.primaryColor,
                        value: dropdownvalue,
                        items: <String>[
                          'Low Attendance',
                          'Low Grades',
                          'Attitude Problem',
                          'Other'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontFamily: "Reem Kufi",
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownvalue = value!;
                          });
                        },
                      ),
                      SizedBox(height: 40),
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
                          controller: _problem,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write your problem here...',
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
                              Map<String, dynamic> data = {
                                "typeproblem": dropdownvalue,
                                "problem": _problem.text,
                                "url": url,
                                "status": status,
                                "feedback": '',
                                "needFeedback": false,
                              };
                              FirebaseFirestore.instance
                                  .collection('problems')
                                  .doc(AuthService().userId)
                                  .collection('studentproblems')
                                  .doc(Timestamp.now().toString())
                                  .set(data);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Report Problem',
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
