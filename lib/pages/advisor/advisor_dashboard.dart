import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:padvisor/pages/advisor/view_student.dart';
import 'package:padvisor/pages/model/advisor.dart';
import 'package:padvisor/pages/model/announcement.dart';
import 'package:padvisor/pages/model/problems.dart';
import 'package:padvisor/pages/model/student.dart';
import 'package:padvisor/pages/services/auth.dart';
import 'package:padvisor/pages/services/database.dart';
import 'package:provider/provider.dart';

import '../../shared/color_constant.dart';

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
    AuthService auth = AuthService();
    return FutureBuilder(
        future: db.advisor('Eh2d6l5WVYR434CwqpB6hDngcAo2'),
        builder: (context, AsyncSnapshot<Advisor> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitThreeInOut(
              color: AppColor.tertiaryColor,
            );
          } else {
            Advisor? advisor = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset('assets/logo/logo_white.png'),
                ),
                elevation: 0.0,
                backgroundColor: AppColor.tertiaryColor,
                centerTitle: true,
                title: Column(
                  children: [
                    Text(advisor!.name!),
                    Text(
                      'Advisor',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        auth.signOut();
                        Navigator.pushNamed(context, 'signin');
                      },
                      icon: Icon(Icons.logout_outlined))
                ],
              ),
              body: Container(
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
                          ProblemPage(
                            db,
                            advisor,
                          ),
                          StudentList(db),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
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
  const ProblemPage(this.db, this.advisor, {Key? key}) : super(key: key);

  final DatabaseService? db;
  final Advisor? advisor;

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.db!.getStudentsId('Eh2d6l5WVYR434CwqpB6hDngcAo2'),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitThreeInOut(
              color: AppColor.tertiaryColor,
            );
          } else {
            List<String>? studentIds = snapshot.data;
            return FutureBuilder(
                future: widget.db!.getStudentsProblems(studentIds!),
                builder: (context, AsyncSnapshot<List<Problems>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitThreeInOut(
                      color: AppColor.tertiaryColor,
                    );
                  } else {
                    List<Problems>? problems = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: problems!.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 15);
                            },
                            itemBuilder: (context, index) {
                              Problems problem = problems[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewProblem(
                                                problem,
                                                isAdvisor: true,
                                              )));
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            problem.studentName!,
                                            style: TextStyle(
                                              fontSize: 22,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(problem.typeproblem!),
                                            const SizedBox(width: 8),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                          ),
                        ),
                      ],
                    );
                  }
                });
          }
        });
  }
}

class StudentList extends StatefulWidget {
  const StudentList(this.db, {Key? key}) : super(key: key);

  final DatabaseService? db;

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;

  getImage(String url) {
    if (url.length < 1) {
      return AssetImage('assets/logo/unknown.png');
    } else {
      return NetworkImage(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            widget.db!.getStudentsUnderAdvisor('Eh2d6l5WVYR434CwqpB6hDngcAo2'),
        builder: (context, AsyncSnapshot<List<Students>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitThreeInOut(
              color: AppColor.tertiaryColor,
            );
          } else {
            List<Students>? studentList = snapshot.data;
            List<Students> students = [];
            for (var value in studentList!) {
              if (value.name!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase())) {
                students.add(value);
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewArchivedStudent(widget.db, students)));
                    },
                    label: Text('Archived Students'),
                    icon: Icon(Icons.archive_outlined)),
                CupertinoSearchTextField(
                  focusNode: _searchFocus,
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        _isSearching = false;
                      } else {
                        _isSearching = true;
                      }
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        _isSearching = false;
                      } else {
                        _isSearching = true;
                      }
                    });
                  },
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: students.length,
                    separatorBuilder: (context, index) {
                      return index == students.length
                          ? const SizedBox.shrink()
                          : const Divider();
                    },
                    itemBuilder: (context, index) {
                      Students student = students[index];
                      return student.archive == true
                          ? SizedBox.shrink()
                          : InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewStudent(student)));
                              },
                              child: Container(
                                height: 55,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: getImage(student.url!),
                                  ),
                                  title: Text(student.name!),
                                  subtitle: Text(student.cohort!),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      widget.db!
                                          .archiveStudent(student.uid!, true)
                                          .whenComplete(() {
                                        setState(() {});
                                      });
                                    },
                                    icon: const Icon(Icons.archive_outlined),
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
        });
  }
}

class ViewArchivedStudent extends StatefulWidget {
  const ViewArchivedStudent(this.db, this.students, {Key? key})
      : super(key: key);

  final DatabaseService? db;
  final List<Students>? students;

  @override
  State<ViewArchivedStudent> createState() => _ViewArchivedStudentState();
}

class _ViewArchivedStudentState extends State<ViewArchivedStudent> {
  getImage(String url) {
    if (url.length < 1) {
      return AssetImage('assets/logo/unknown.png');
    } else {
      return NetworkImage(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.students!.length);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.tertiaryColor,
        title: Text('Archived Students'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.separated(
          itemCount: widget.students!.length,
          separatorBuilder: (context, index) {
            return index == widget.students!.length
                ? const SizedBox.shrink()
                : const Divider();
          },
          itemBuilder: (context, index) {
            Students student = widget.students![index];
            return student.archive == false
                ? SizedBox.shrink()
                : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewStudent(student)));
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: getImage(student.url!),
                        ),
                        title: Text(student.name!),
                        subtitle: Text(student.cohort!),
                        trailing: IconButton(
                          onPressed: () async {
                            widget.db!
                                .archiveStudent(student.uid!, false)
                                .whenComplete(() {
                              setState(() {
                                widget.students!.remove(student);
                              });
                            });
                          },
                          icon: const Icon(Icons.archive_outlined),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
