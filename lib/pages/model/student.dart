import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padvisor/pages/coordinator/coordinator_dashboard.dart';

class Students {
  String? uid;
  String? name;
  String? matricNo;
  String? weChat;
  String? whatsApp;
  String? url = '';
  String? cohort = '';
  String? advisor = '';
  String? email = '';

  Students(
      {required this.uid,
      this.matricNo,
      this.name,
      this.weChat,
      this.whatsApp,
      this.advisor,
      this.cohort,
      this.url,
      this.email});

  Students.fromJson(String id, Map<String, dynamic> json)
      : uid = id,
        name = json['name'],
        matricNo = json['matricNo'],
        weChat = json['weChat'],
        url = json['url'],
        whatsApp = json['whatsApp'],
        cohort = json['cohort'],
        advisor = json['advisor'],
        email = json['email'];
}
