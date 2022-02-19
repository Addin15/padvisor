import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:padvisor/pages/hod/create_announcement.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../shared/color_constant.dart';
import '../services/database.dart';
import '../model/announcement.dart';

class HodDashboard extends StatefulWidget {
  const HodDashboard({Key? key}) : super(key: key);

  @override
  State<HodDashboard> createState() => _HodDashboardState();
}

class _HodDashboardState extends State<HodDashboard>
    with TickerProviderStateMixin {
  TabController? _tabController;

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
                Tab(text: 'Students'),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ViewAnnouncement(),
                  StudentList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewAnnouncement extends StatefulWidget {
  const ViewAnnouncement({Key? key}) : super(key: key);

  @override
  _ViewAnnouncementState createState() => _ViewAnnouncementState();
}

class _ViewAnnouncementState extends State<ViewAnnouncement> {
  DatabaseService db = DatabaseService();
  String? _selectedCohort = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
            future: db.getCohorts(),
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
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text('Cohort: '),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButtonFormField(
                              onChanged: (value) {
                                setState(() {
                                  _selectedCohort = value.toString();
                                });
                              },
                              value: _selectedCohort!.isEmpty
                                  ? cohorts!.elementAt(0)
                                  : _selectedCohort,
                              items: [
                                ...cohorts!
                                    .map((cohort) => DropdownMenuItem(
                                          child: Text(cohort),
                                          value: cohort,
                                        ))
                                    .toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: StreamProvider<List<Announcement>>.value(
                          value: db.getAnnouncements(_selectedCohort!.isEmpty
                              ? cohorts.elementAt(0)
                              : _selectedCohort),
                          initialData: const [],
                          builder: (context, _) {
                            List<Announcement> announcements =
                                Provider.of<List<Announcement>>(context);

                            return ListView.separated(
                              itemCount: announcements.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                return ExpansionTile(
                                  title: Text(
                                      announcements.elementAt(index).title!),
                                  children: [
                                    Text(announcements
                                        .elementAt(index)
                                        .announcement!),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text('No cohorts found'),
                  );
                }
              }
            }),
        Positioned(
          bottom: 20,
          right: 0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateAnnouncement()));
            },
            backgroundColor: AppColor.tertiaryColor,
            child: Icon(
              Icons.add_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
