import 'package:cloud_firestore/cloud_firestore.dart';

class Students {
  String? uid;
  String? name;
  String? matricNo;
  String? weChat;
  String? whatsApp;
  String? url = '';

  Students(
      {required this.uid,
      this.matricNo,
      this.name,
      this.weChat,
      this.whatsApp,
      this.url});

  Students.fromJson(String uid, Map<String, dynamic> json)
      : name = json['name'],
        matricNo = json['matricNo'],
        weChat = json['weChat'],
        url = json['url'],
        whatsApp = json['whatsApp'];
}
