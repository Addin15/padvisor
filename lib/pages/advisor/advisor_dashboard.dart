import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                Tab(text: 'Problems'),
                Tab(text: 'Students'),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Announcement(),
                  ProblemPage(),
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

class Announcement extends StatefulWidget {
  const Announcement({Key? key}) : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          value: '2018/2019',
          items: [
            DropdownMenuItem(
              child: Text('2018/2019'),
              value: '2018/2019',
            ),
            DropdownMenuItem(
              child: Text('2019/2020'),
              value: '2019/2020',
            ),
            DropdownMenuItem(
              child: Text('2020/2021'),
              value: '2020/2021',
            ),
          ],
          onChanged: (String? value) {},
        ),
        Expanded(
          child: ListView.separated(
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColor.tertiaryColor.withAlpha(100),
                  border: Border.all(
                    color: AppColor.tertiaryColor,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text('Date'),
                    Text('Title'),
                    Text('Details'),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
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
