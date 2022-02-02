import 'package:flutter/material.dart';

import '../../shared/color_constant.dart';

class AdvisorViewProblem extends StatelessWidget {
  const AdvisorViewProblem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.tertiaryColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Text(
              'Student Name',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Student Matric',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Student Problem',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColor.tertiaryColor,
                  width: 2,
                ),
              ),
              child: Text(
                'Problem details....\n\n\n',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(50),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text(
                    'No attachment yet...',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  TextButton(onPressed: () {}, child: Text('Ask for evidence'))
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.primaryColor,
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Message',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Ask for Feedback',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
