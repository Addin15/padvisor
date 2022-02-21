import 'package:flutter/material.dart';
import 'package:padvisor/pages/services/auth.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentFeedback extends StatefulWidget {
  final String id;

  const StudentFeedback(this.id, {Key? key}) : super(key: key);

  @override
  _StudentFeedbackState createState() => _StudentFeedbackState();
}

class _StudentFeedbackState extends State<StudentFeedback> {
  var rating = 0.0;
  AuthService authService = AuthService();
  TextEditingController feedbackController = TextEditingController();

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
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'Are you satisfied with these solution provided by your advisor',
                      style: TextStyle(
                        fontFamily: "Reem Kufi",
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 22),
                    SmoothStarRating(
                        allowHalfRating: false,
                        onRatingChanged: (v) {
                          rating = v;
                          setState(() {});
                        },
                        starCount: 5,
                        rating: rating,
                        size: 40.0,
                        color: Colors.yellow,
                        borderColor: Colors.white,
                        spacing: 0.0),
                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.all(10),
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
                        controller: feedbackController,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Additional Comment',
                            hintStyle: TextStyle(
                              color: AppColor.primaryColor,
                            )),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('problems')
                                .doc(authService.userId)
                                .collection('studentproblems')
                                .doc(widget.id)
                                .update({
                              'rating': rating,
                              'feedback': feedbackController.text,
                              'needFeedback': false,
                              'status': 'feedback submitted'
                            });
                            Navigator.pop(context);
                          },
                          label: Text(
                            'Submit',
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          icon: Icon(Icons.arrow_forward_ios_outlined,
                              color: AppColor.primaryColor),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 170);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
