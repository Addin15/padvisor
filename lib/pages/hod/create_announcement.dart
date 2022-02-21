import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:padvisor/pages/services/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../shared/color_constant.dart';
import '../../shared/constant_styles.dart';
import '../model/announcement.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({Key? key}) : super(key: key);

  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final TextEditingController? _titleController = TextEditingController();
  final TextEditingController? _announcementController =
      TextEditingController();

  String? _selectedCohort = '';

  DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.getCohorts(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: SpinKitThreeInOut(
                color: AppColor.tertiaryColor,
              ),
            );
          } else {
            List<String>? cohorts = snapshot.data;

            if (cohorts!.isNotEmpty) {
              _selectedCohort = cohorts.first;
            }

            return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: AppColor.tertiaryColor,
                title: Text('Create Announcement'),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () async {
                      Announcement announcement = Announcement(
                        title: _titleController!.text,
                        announcement: _announcementController!.text,
                        timestamp: Timestamp.now(),
                        cohort: _selectedCohort,
                      );
                      await db.createAnnouncement(announcement);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.done),
                  )
                ],
              ),
              body: snapshot.data!.isEmpty
                  ? Center(
                      child: Text('No cohorts found'),
                    )
                  : Container(
                      padding:
                          const EdgeInsets.only(right: 30, left: 30, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Cohort: '),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCohort = value.toString();
                                    });
                                  },
                                  value: _selectedCohort!.isEmpty
                                      ? cohorts.elementAt(0)
                                      : _selectedCohort,
                                  items: [
                                    ...cohorts
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
                          const SizedBox(height: 10),
                          Text('Title:'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              enabledBorder:
                                  WidgetStyleConstant.textFormField(),
                              focusedBorder:
                                  WidgetStyleConstant.textFormField(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('Announcement'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _announcementController,
                            decoration: InputDecoration(
                              enabledBorder:
                                  WidgetStyleConstant.textFormField(),
                              focusedBorder:
                                  WidgetStyleConstant.textFormField(),
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
