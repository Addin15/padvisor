import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:padvisor/pages/model/advisor_advisee.dart';
import 'package:provider/provider.dart';

import '../../shared/color_constant.dart';
import '../services/database.dart';

class ViewCohort extends StatefulWidget {
  const ViewCohort({Key? key, this.cohort}) : super(key: key);

  final String? cohort;

  @override
  _ViewCohortState createState() => _ViewCohortState();
}

class _ViewCohortState extends State<ViewCohort> {
  DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.tertiaryColor,
        centerTitle: true,
        title: Text(widget.cohort!),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Advisor',
              style: TextStyle(color: AppColor.tertiaryColor, fontSize: 22),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => addAdvisor());
              },
              child: Text('Add Advisor'),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder(
                  future: db.getAdvisorAdvisee(widget.cohort!),
                  builder:
                      (context, AsyncSnapshot<List<AdvisorAdvisee>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SpinKitThreeInOut(
                        color: AppColor.tertiaryColor,
                      );
                    } else {
                      List<AdvisorAdvisee>? advisoradvisee = snapshot.data;

                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: advisoradvisee!.length,
                        itemBuilder: (context, index) {
                          AdvisorAdvisee advisor =
                              advisoradvisee.elementAt(index);
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: AppColor.tertiaryColor, width: 2),
                            ),
                            child: ExpansionTile(
                              title: Text(advisor.name!),
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                Divider(),
                                ...advisor.advisees!.map((advisee) {
                                  return Column(
                                    children: [
                                      Text(
                                        advisee.name!,
                                        textAlign: TextAlign.left,
                                      ),
                                      Divider(),
                                    ],
                                  );
                                }).toList(),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                            context: context,
                                            builder: (context) =>
                                                addAdvisee(advisor.id!))
                                        .whenComplete(() {
                                      setState(() {});
                                    });
                                  },
                                  child: Text('Add Advisee'),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  addAdvisor() {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Text('Select Advisor'),
            SizedBox(height: 30),
            FutureBuilder(
              future: db.advisors,
              builder: (context, AsyncSnapshot<List<AdvisorAdvisee>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitThreeInOut(
                    color: AppColor.tertiaryColor,
                  );
                } else {
                  List<AdvisorAdvisee>? advisors = snapshot.data;
                  return Expanded(
                    child: ListView.separated(
                        itemCount: advisors!.length,
                        separatorBuilder: (context, index) {
                          if (index == advisors.length)
                            return SizedBox.shrink();
                          return SizedBox(height: 5);
                        },
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await db.addAdvisorInCohort(
                                  advisors[index].id!, widget.cohort!);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(advisors[index].name!),
                            ),
                          );
                        }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  addAdvisee(String advisor) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Text('Select Advisee'),
            SizedBox(height: 30),
            FutureBuilder(
              future: db.advisees,
              builder: (context, AsyncSnapshot<List<Advisee>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitThreeInOut(
                    color: AppColor.tertiaryColor,
                  );
                } else {
                  List<Advisee>? advisees = snapshot.data;
                  return Expanded(
                    child: ListView.separated(
                        itemCount: advisees!.length,
                        separatorBuilder: (context, index) {
                          if (index == advisees.length)
                            return SizedBox.shrink();
                          return SizedBox(height: 5);
                        },
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await db.addAdviseeIntoCohort(
                                  advisees[index].id!, advisor, widget.cohort!);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(advisees[index].name!),
                            ),
                          );
                        }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
