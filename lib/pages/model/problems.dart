import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Problems {
  String? url;
  String? studentName;
  String? problem;
  String? typeproblem;
  String? status;
  bool? needFeedback;
  String? feedback;
  String? id;
  String? studentId;

  Problems(
      {this.typeproblem,
      this.studentName,
      this.problem,
      this.status,
      this.url,
      this.needFeedback,
      this.feedback,
      this.id,
      this.studentId});

  Problems.fromJson(String problemId, String stdId, Map<String, dynamic> json,
      {String? name = ''})
      : studentName = name,
        id = problemId,
        studentId = stdId,
        typeproblem = json['typeproblem'],
        problem = json['problem'],
        status = json['status'],
        url = json['url'],
        feedback = json['feedback'],
        needFeedback = json['needFeedback'];
}
