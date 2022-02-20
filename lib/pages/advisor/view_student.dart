import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:padvisor/pages/model/problems.dart';
import 'package:padvisor/pages/model/student.dart';
import 'package:padvisor/pages/services/database.dart';
import 'package:padvisor/pages/student/student_problem_progress.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluwx/fluwx.dart';

import 'advisor_view_problem.dart';

class ViewStudent extends StatefulWidget {
  const ViewStudent(
    this.student, {
    Key? key,
    this.isHod = false,
  }) : super(key: key);

  final Students student;
  final bool? isHod;

  @override
  State<ViewStudent> createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  messageButton(
      String type, IconData icon, Color iconColor, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          icon,
          size: 40,
          color: iconColor,
        ),
      ),
    );
  }

  getImage(String? url) {
    if (url!.length < 1) {
      return AssetImage('assets/logo/unknown.png');
    } else {
      return NetworkImage(url);
    }
  }

  _initFluwx() async {
    await registerWxApi(
        appId: "wxd930ea5d5a258f4f",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://your.univerallink.com/link/");
    var result = await isWeChatInstalled;
    print("is installed $result");
  }

  @override
  void initState() {
    _initFluwx();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    WeChatScene scene = WeChatScene.SESSION;
    print(widget.isHod);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.tertiaryColor,
        elevation: 0.0,
        title: Text('Student Profile'),
        centerTitle: true,
      ),
      body: StreamProvider<List<Problems>>.value(
          value: db.getProblems(widget.student.uid),
          initialData: [],
          builder: (context, snapshot) {
            List<Problems> problems = Provider.of<List<Problems>>(context);
            // print('Problems: ${problems.length}');
            // print(student.uid);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: getImage(widget.student.url),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.student.name!,
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    messageButton('Email', Icons.email, Colors.blue, () async {
                      final url =
                          'mailto:${widget.student.email}?subject=${Uri.encodeFull('')}&body=${Uri.encodeFull('')}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    }),
                    VerticalDivider(),
                    messageButton(
                        'WhatsApp', Ionicons.logo_whatsapp, Colors.green,
                        () async {
                      final url =
                          'https://wa.me/${widget.student.whatsApp}?text=';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    }),
                    VerticalDivider(),
                    messageButton(
                        'Wechat', Ionicons.logo_wechat, Colors.greenAccent,
                        () async {
                      var arguments = {
                        'to': widget.student.weChat,
                        'text': 'Welcome to user flutter wechat plugin.'
                      };
                      shareToWeChat(WeChatShareTextModel(' ', scene: scene))
                          .then((data) {
                        print("-->$data");
                      });
                    }),
                  ],
                ),
                SizedBox(height: 25),
                problems.isEmpty
                    ? Text('No problems reported')
                    : Expanded(
                        child: Column(
                          children: [
                            widget.isHod!
                                ? TextButton(
                                    onPressed: () {},
                                    child: Text('Report a problem'),
                                  )
                                : SizedBox.shrink(),
                            Text('Problems Reported'),
                            Divider(),
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  Problems problem = problems[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewProblem(problem)));
                                    },
                                    child: Container(
                                      height: 45,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(problem.typeproblem!),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  if (index == problems.length)
                                    return SizedBox.shrink();
                                  return SizedBox(height: 5);
                                },
                                itemCount: problems.length,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          }),
    );
  }
}

class ViewProblem extends StatelessWidget {
  const ViewProblem(this.problem, {Key? key}) : super(key: key);

  final Problems? problem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Problem Details'),
        backgroundColor: AppColor.tertiaryColor,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text('Problem type'),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                problem!.typeproblem!,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            Text('Problem details'),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                problem!.problem!,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: (problem!.url!.length < 1)
                  ? Text('No attachment provided')
                  : TextButton(
                      onPressed: () async {
                        if (await canLaunch(problem!.url!)) {
                          await launch(problem!.url!);
                        }
                      },
                      child: Text('Download Attachment'),
                    ),
            ),
            SizedBox(height: 30),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(getFeedback(problem)),
                  (problem!.feedback!.isEmpty && problem!.needFeedback == false)
                      ? TextButton(
                          onPressed: () {},
                          child: Text('Ask for feedback'),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFeedback(Problems? problem) {
    if (problem!.feedback!.isEmpty && problem.needFeedback == true) {
      return 'Already requested for feedback. But not yet provided.';
    } else if (problem.feedback!.isEmpty && problem.needFeedback == false) {
      return 'No feedback provided yet';
    } else {
      return problem.feedback!;
    }
  }
}
