import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:padvisor/pages/coordinator/coordinator_view_cohort.dart';
import 'package:provider/provider.dart';

import '../../shared/color_constant.dart';
import '../../shared/constant_styles.dart';
import '../hod/hod_dashboard.dart';
import '../services/database.dart';

class CoordinatorDashboard extends StatefulWidget {
  const CoordinatorDashboard({Key? key}) : super(key: key);

  @override
  _CoordinatorDashboardState createState() => _CoordinatorDashboardState();
}

class _CoordinatorDashboardState extends State<CoordinatorDashboard>
    with TickerProviderStateMixin {
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
                Tab(text: 'Cohorts'),
                Tab(text: 'Students'),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ViewAnnouncement(db),
                  Cohorts(db),
                  StudentList(db),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Cohorts extends StatefulWidget {
  const Cohorts(this.db, {Key? key}) : super(key: key);
  final DatabaseService db;

  @override
  _CohortsState createState() => _CohortsState();
}

class _CohortsState extends State<Cohorts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () {
            TextEditingController _cohortController = TextEditingController();
            GlobalKey<FormState> _formKey = GlobalKey<FormState>();
            showDialog(
                context: context,
                builder: (context) => Form(
                      key: _formKey,
                      child: AlertDialog(
                        title: Text('Add Cohort'),
                        content: TextFormField(
                          controller: _cohortController,
                          validator: (value) => value!.isEmpty
                              ? 'Cohort name can\'t be empty'
                              : null,
                          decoration: InputDecoration(
                            hintText: 'yyyy-yyyy',
                            enabledBorder: WidgetStyleConstant.textFormField(),
                            focusedBorder: WidgetStyleConstant.textFormField(),
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: AppColor.tertiaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.tertiaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await widget.db
                                        .addCohort(_cohortController.text);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 40),
                                  decoration: BoxDecoration(
                                    color: AppColor.tertiaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Done',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )).whenComplete(() {
              setState(() {});
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            decoration: BoxDecoration(
              color: AppColor.tertiaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Add Cohort',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: FutureBuilder(
              future: widget.db.getCohorts(),
              builder: (context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    // backgroundColor: Colors.white,
                    body: SpinKitThreeInOut(
                      color: AppColor.tertiaryColor,
                    ),
                  );
                } else {
                  if (snapshot.data!.isNotEmpty) {
                    List<String>? cohorts = snapshot.data;
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: cohorts!.length,
                      itemBuilder: (context, index) {
                        String cohort = cohorts.elementAt(index);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewCohort(cohort: cohort)));
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.tertiaryColor, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(cohort),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No cohorts found'),
                    );
                  }
                }
              }),
        )
      ],
    );
  }
}

class StudentList extends StatelessWidget {
  const StudentList(this.db, {Key? key}) : super(key: key);

  final DatabaseService db;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.advisees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitThreeInOut(
              color: AppColor.tertiaryColor,
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CupertinoSearchTextField(),
                Expanded(
                  child: ListView.separated(
                    itemCount: 4,
                    separatorBuilder: (context, index) {
                      return index == 4 ? SizedBox.shrink() : Divider();
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        height: 55,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: ListTile(
                          leading: CircleAvatar(),
                          title: Text('Student Name'),
                          subtitle: Text('Student Year'),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert_outlined),
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
