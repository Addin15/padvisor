import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padvisor/pages/student/student_add_report.dart';
import 'package:padvisor/pages/student/student_annoucement.dart';
import 'package:padvisor/pages/student/student_feedback.dart';
import 'package:padvisor/pages/student/student_profile.dart';
import 'package:padvisor/pages/student/student_upload_doc.dart';
import 'package:padvisor/shared/color_constant.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/logo/logo_white.png'),
        ),
        elevation: 0.0,
        backgroundColor: AppColor.primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentProfile()));
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              onTap: (index) {
                _tabController!.animateTo(index);
              },
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: AppColor.primaryColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(icon: Icon(Icons.star_outline), text: 'Feedback'),
                Tab(
                    icon: Icon(Icons.report_problem_outlined),
                    text: 'Problems'),
                Tab(
                    icon: Icon(Icons.announcement_outlined),
                    text: 'Annoucement'),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    Feedback(),
                    Problems(),
                    Annoucement(),
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

class Annoucement extends StatefulWidget {
  const Annoucement({Key? key}) : super(key: key);

  @override
  State<Annoucement> createState() => _Annoucement();
}

class _Annoucement extends State<Annoucement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'adin bajingan',
                                style: TextStyle(
                                    color: AppColor.tertiaryColor,
                                    fontSize: 18.0,
                                    fontFamily: "Reem Kufi"),
                              ),
                            ),
                            Text(
                                DateFormat('dd/MM/yyyy').format(
                                  DateTime.now(),
                                ),
                                style: TextStyle(
                                    color: AppColor.tertiaryColor,
                                    fontSize: 14.0,
                                    fontFamily: "Reem Kufi")),
                          ],
                        ),
                        children: [
                          Text('details'),
                        ],
                      ));
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
                itemCount: 2))
      ],
    );
  }
}

class Problems extends StatefulWidget {
  const Problems({Key? key}) : super(key: key);

  @override
  State<Problems> createState() => _Problems();
}

class _Problems extends State<Problems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadDoc()));
                  },
                  child: Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor.primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Expanded(
                            child: Text(
                              'Low Attendance',
                              style: TextStyle(
                                  color: AppColor.tertiaryColor,
                                  fontSize: 18.0,
                                  fontFamily: "Reem Kufi"),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.yellow[900],
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 3.0,
                                  ),
                                  child: Text(
                                    'Pending',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 15);
              },
              itemCount: 3),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddReport()),
              );
            },
            backgroundColor: AppColor.primaryColor,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class Feedback extends StatefulWidget {
  const Feedback({Key? key}) : super(key: key);

  @override
  State<Feedback> createState() => _Feedback();
}

class _Feedback extends State<Feedback> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentFeedback()));
                    },
                    child: Container(
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Expanded(
                              child: Text(
                                'Low Grades',
                                style: TextStyle(
                                    color: AppColor.tertiaryColor,
                                    fontSize: 18.0,
                                    fontFamily: "Reem Kufi"),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 3.0,
                                    ),
                                    child: Text(
                                      'Submited',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
                itemCount: 2))
      ],
    );
  }
}
