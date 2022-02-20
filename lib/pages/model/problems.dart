import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Problems {
  String? url;
  String? problem;
  String? typeproblem;
  String? status;

  Problems({
    this.typeproblem,
    this.problem,
    this.status,
    this.url,
  });

  Problems.fromJson(Map<String, dynamic> json)
      : typeproblem = json['typeproblem'],
        problem = json['problem'],
        status = json['status'],
        url = json['url'];
}
