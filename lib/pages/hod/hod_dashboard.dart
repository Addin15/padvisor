import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:padvisor/pages/hod/create_announcement.dart';

import '../../shared/color_constant.dart';

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
                  Announcement(),
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
    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                Text('Cohort: '),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField(
                    value: '2019/2020',
                    items: [
                      DropdownMenuItem(
                        child: Text('2019/2020'),
                        value: '2019/2020',
                      ),
                      DropdownMenuItem(
                        child: Text('2020/2021'),
                        value: 2020 / 2021,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 20,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text('Announcement'),
                    children: [
                      Text('Details'),
                      Text('Details'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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
