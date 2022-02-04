import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  String? title;
  Timestamp? timestamp;
  String? cohort;
  String? announcement;

  Announcement({
    this.title,
    this.timestamp,
    this.cohort,
    this.announcement,
  });

  Announcement.fromJson(String id, Map<String, dynamic> json)
      : title = id,
        announcement = json['announcement'],
        timestamp = json['timestamp'];
}
