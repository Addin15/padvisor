import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:padvisor/pages/model/advisor.dart';
import 'package:padvisor/pages/model/announcement.dart';
import 'package:padvisor/pages/services/auth.dart';
import 'package:padvisor/pages/services/database.dart';
import 'package:provider/provider.dart';

import '../../shared/color_constant.dart';
import 'advisor_view_problem.dart';

class AdvisorDashboard extends StatefulWidget {
  const AdvisorDashboard({Key? key}) : super(key: key);

  @override
  State<AdvisorDashboard> createState() => _AdvisorDashboardState();
}

class _AdvisorDashboardState extends State<AdvisorDashboard>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/logo/logo_white.png'),
        ),
        elevation: 0.0,
        backgroundColor: AppColor.tertiaryColor,
      ),
      body: FutureBuilder(
          future: db.advisor('Eh2d6l5WVYR434CwqpB6hDngcAo2'),
          builder: (context, AsyncSnapshot<Advisor> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SpinKitThreeInOut(
                color: AppColor.tertiaryColor,
              );
            } else {
              Advisor? advisor = snapshot.data;
              return Container(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      onTap: (index) {
                        _tabController!.animateTo(index);
                      },
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        color: AppColor.tertiaryColor,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Tab(text: 'Announcement'),
                        Tab(text: 'Problems'),
                        Tab(text: 'Students'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ViewAnnouncement(
                            db,
                            advisor,
                          ),
                          ProblemPage(),
                          StudentList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

class ViewAnnouncement extends StatefulWidget {
  const ViewAnnouncement(this.db, this.advisor, {Key? key}) : super(key: key);

  final DatabaseService? db;
  final Advisor? advisor;

  @override
  _ViewAnnouncementState createState() => _ViewAnnouncementState();
}

class _ViewAnnouncementState extends State<ViewAnnouncement> {
  String selectedValue = '';

  @override
  Widget build(BuildContext context) {
    List<String> cohorts = [];
    for (var value in widget.advisor!.cohorts!) {
      cohorts.add(value.toString());
    }

    if (cohorts.isEmpty) {
      return Center(
        child: Text('Not assigned to any cohort'),
      );
    } else {
      return Column(
        children: [
          DropdownButton(
            value: selectedValue.isEmpty ? cohorts.first : selectedValue,
            items: [
              ...cohorts.map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList()
            ],
            onChanged: (String? value) {
              setState(() {
                selectedValue = value.toString();
              });
            },
          ),
          Expanded(
            child: StreamProvider<List<Announcement>>.value(
                value: widget.db!.getAnnouncements(
                    selectedValue.isEmpty ? cohorts.first : selectedValue),
                initialData: [],
                builder: (context, child) {
                  List<Announcement> announcements =
                      Provider.of<List<Announcement>>(context);
                  return ListView.separated(
                    itemCount: announcements.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      Announcement announcement = announcements[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.tertiaryColor.withAlpha(100),
                          border: Border.all(
                            color: AppColor.tertiaryColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(announcement.timestamp!.toDate()),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              announcement.title!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(announcement.announcement!),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      );
    }
  }
}

class ProblemPage extends StatefulWidget {
  const ProblemPage({Key? key}) : super(key: key);

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: 3,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 15);
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdvisorViewProblem()));
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
                            'Student Name',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('Low Attendance'),
                            const SizedBox(width: 8),
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
          ),
        ),
      ],
    );
  }
}

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CupertinoSearchTextField(),
        Expanded(
          child: ListView.separated(
            itemCount: 4,
            separatorBuilder: (context, index) {
              return index == 4 ? const SizedBox.shrink() : const Divider();
            },
            itemBuilder: (context, index) {
              return Container(
                height: 55,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ListTile(
                  leading: const CircleAvatar(),
                  title: const Text('Student Name'),
                  subtitle: const Text('Student Year'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_outlined),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
