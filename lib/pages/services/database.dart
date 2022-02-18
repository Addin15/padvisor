import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padvisor/pages/model/student.dart';

import '../model/announcement.dart';

class DatabaseService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  //---------------------------- HEAD OF DEPARTMENT --------------------------------//

  // CREATE ANNOUNCEMENT
  Future<bool> createAnnouncement(Announcement a) async {
    try {
      await db
          .collection('cohorts')
          .doc(a.cohort)
          .collection('announcements')
          .doc(a.title)
          .set({
        'timestamp': a.timestamp,
        'announcement': a.announcement,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  //RETRIEVE PROFILE
  Future<Students>? getUser(String? uid) async {
    DocumentSnapshot<Map<String, dynamic>> user =
        await db.collection('students').doc(uid).get();
    return Students.fromJson(user.id, user.data()!);
  }

  //SAVE STUDENT
  Future<void> saveStudent(String uid, Map<String, dynamic> data) async {
    await db.collection('students').doc(uid).update(data);
  }

  // RETRIEVE ANNOUNCEMENT
  Stream<List<Announcement>>? getAnnouncements(String? cohort) {
    return db
        .collection('cohorts')
        .doc(cohort)
        .collection('announcements')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Announcement.fromJson(doc.id, doc.data()))
            .toList());
  }

  // RETURN LIST OF COHORTS
  Future<List<String>> getCohorts() async {
    QuerySnapshot snapshots = await db.collection('cohorts').get();
    return snapshots.docs.map((doc) => doc.id).toList();
  }
  //---------------------------- HEAD OF DEPARTMENT --------------------------------//
  //---------------------------- PA COORDINATOR --------------------------------//

  Future<void> addCohort(String cohort) async {
    try {
      await db.collection('cohorts').doc(cohort).set({});
    } catch (e) {
      e.hashCode;
    }
  }

  //---------------------------- PA COORDINATOR --------------------------------//
}
