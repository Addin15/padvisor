import 'package:flutter/material.dart';

import '../../shared/color_constant.dart';
import '../../shared/constant_styles.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({Key? key}) : super(key: key);

  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.tertiaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.done),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Cohort: '),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField(
                    value: '2019/2020',
                    items: [
                      DropdownMenuItem(
                          child: Text('2019/2020'), value: '2019/2020'),
                      DropdownMenuItem(
                          child: Text('2020/2021'), value: '2020/2021'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Title:'),
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: WidgetStyleConstant.textFormField(),
                focusedBorder: WidgetStyleConstant.textFormField(),
              ),
            ),
            const SizedBox(height: 10),
            Text('Description'),
            const SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: WidgetStyleConstant.textFormField(),
                focusedBorder: WidgetStyleConstant.textFormField(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
