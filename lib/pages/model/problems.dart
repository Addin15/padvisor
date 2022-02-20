import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Problems {
  String? url;
  String? problem;
  String? typeproblem;
  String? status;
  bool? needFeedback;
  String? feedback;

  Problems({
    this.typeproblem,
    this.problem,
    this.status,
    this.url,
    this.needFeedback,
    this.feedback,
  });

  Problems.fromJson(Map<String, dynamic> json)
      : typeproblem = json['typeproblem'],
        problem = json['problem'],
        status = json['status'],
        url = json['url'],
        feedback = json['feedback'],
        needFeedback = json['needFeedback'];
}
