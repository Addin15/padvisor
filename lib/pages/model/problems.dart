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

  Problems(
      {this.typeproblem,
      this.studentName,
      this.problem,
      this.status,
      this.url,
      this.needFeedback,
      this.feedback,
      this.id});

  Problems.fromJson(String problemId, Map<String, dynamic> json,
      {String? name = ''})
      : studentName = name,
        id = problemId,
        typeproblem = json['typeproblem'],
        problem = json['problem'],
        status = json['status'],
        url = json['url'],
        feedback = json['feedback'],
        needFeedback = json['needFeedback'];
}
