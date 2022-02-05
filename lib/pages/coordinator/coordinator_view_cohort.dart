import 'package:flutter/material.dart';

import '../../shared/color_constant.dart';

class ViewCohort extends StatefulWidget {
  const ViewCohort({Key? key, this.cohort}) : super(key: key);

  final String? cohort;

  @override
  _ViewCohortState createState() => _ViewCohortState();
}

class _ViewCohortState extends State<ViewCohort> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.tertiaryColor,
        centerTitle: true,
        title: Text(widget.cohort!),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
