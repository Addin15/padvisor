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

  // getAdvisorAdvisee() async {
  //   Map<String, List<String>> res = await db.getAdvisorAdvisee(widget.cohort!);
  //   setState(() {
  //     advisoradvisee = res;
  //   });
  // }

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
                  db.getAdvisorAdvisee('2015-2016');
                },
                child: Text('test')),
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

                      print(advisoradvisee!.length);

                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: advisoradvisee.length,
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
                                  onPressed: () {},
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
}
