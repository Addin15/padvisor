import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:padvisor/pages/model/announcement.dart';
import 'package:padvisor/pages/model/problems.dart';
import 'package:padvisor/pages/model/student.dart';
import 'package:padvisor/pages/services/auth.dart';
import 'package:padvisor/pages/services/database.dart';
import 'package:padvisor/pages/student/student_add_report.dart';
import 'package:padvisor/pages/student/student_problem_progress.dart';
import 'package:padvisor/pages/student/student_profile.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:provider/provider.dart';

import '../sign_in.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  DatabaseService db = DatabaseService();
  AuthService auth = AuthService();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushReplacementNamed(context, 'signin');
              },
              icon: const Icon(Icons.logout_outlined)),
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
              tabs: [
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
                  children: [
                    ViewProblems(db: db),
                    ViewAnnoucement(db: db),
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

class ViewAnnoucement extends StatefulWidget {
  const ViewAnnoucement({Key? key, this.db}) : super(key: key);
  final DatabaseService? db;

  @override
  State<ViewAnnoucement> createState() => _ViewAnnoucement();
}

class _ViewAnnoucement extends State<ViewAnnoucement> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.db!.getUser(AuthService().userId),
        builder: (context, AsyncSnapshot<Students> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitThreeInOut(
              color: AppColor.tertiaryColor,
            );
          } else {
            Students? student = snapshot.data;
            if (student!.cohort!.isEmpty) {
              return Center(child: Text('No cohort assigned yet'));
            }
            return StreamProvider<List<Announcement>>.value(
                value: widget.db!.getAnnouncements(student.cohort),
                initialData: [],
                builder: (context, child) {
                  List<Announcement> annoucements =
                      Provider.of<List<Announcement>>(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                Announcement annoucement = annoucements[index];
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
                                              annoucement.title!,
                                              style: TextStyle(
                                                  color: AppColor.tertiaryColor,
                                                  fontSize: 18.0,
                                                  fontFamily: "Reem Kufi"),
                                            ),
                                          ),
                                          Text(
                                              DateFormat('dd-MM-yyyy').format(
                                                  annoucement.timestamp!
                                                      .toDate()),
                                              style: TextStyle(
                                                  color: AppColor.tertiaryColor,
                                                  fontSize: 14.0,
                                                  fontFamily: "Reem Kufi")),
                                        ],
                                      ),
                                      children: [
                                        Text(annoucement.announcement!),
                                      ],
                                    ));
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 15);
                              },
                              itemCount: annoucements.length))
                    ],
                  );
                });
          }
        });
  }
}

class ViewProblems extends StatefulWidget {
  const ViewProblems({Key? key, this.db}) : super(key: key);
  final DatabaseService? db;

  @override
  State<ViewProblems> createState() => _ViewProblems();
}

class _ViewProblems extends State<ViewProblems> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Problems>>.value(
        value: widget.db!.getProblems(AuthService().userId),
        initialData: const [],
        builder: (context, child) {
          List<Problems> problems = Provider.of<List<Problems>>(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                                      StudentProblem(problem)));
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
                                Expanded(
                                  child: Text(
                                    problem.typeproblem!,
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
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 3.0,
                                        ),
                                        child: Text(
                                          problem.status!,
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
                    itemCount: problems.length),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddReport()),
                    );
                  },
                  backgroundColor: AppColor.primaryColor,
                  child: Icon(Icons.add),
                ),
              ),
            ],
          );
        });
  }
}
