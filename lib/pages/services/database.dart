import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padvisor/pages/model/student.dart';

import '../model/announcement.dart';
import '../model/advisor_advisee.dart';

class DatabaseService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  //---------------------------- STUDENT -----------------------------------------//
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
  //---------------------------- STUDENT -----------------------------------------//
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

  // GET ADVISOR-ADVISEE
  Future<List<AdvisorAdvisee>> getAdvisorAdvisee(String cohort) async {
    try {
      // DocumentSnapshot<Map<String, dynamic>> res =
      //     await db.collection('cohorts').doc(cohort).get();
      // print(res.get('reference'));
      List<dynamic> advisoradvisee = await db
          .collection('cohorts')
          .doc(cohort)
          .get()
          .then((value) => value.get('advisors'));

      List<AdvisorAdvisee> advisorsAdvisees = [];

      for (Map<String, dynamic> val in advisoradvisee) {
        DocumentReference advisor = val.entries.elementAt(0).value;
        String advisorName =
            await advisor.get().then((value) => value.get('name'));

        AdvisorAdvisee a = AdvisorAdvisee(advisor.id, advisorName);
        List<dynamic> advisees = val.entries.elementAt(1).value;

        List<Advisee> adviseesList = [];

        for (DocumentReference b in advisees) {
          String adviseeName = await b.get().then((value) => value.get('name'));
          Advisee advisee = Advisee(b.id, adviseeName);
          adviseesList.add(advisee);
        }

        a.setAdvisees(adviseesList);
        advisorsAdvisees.add(a);
      }

      print(advisorsAdvisees.first.name);

      return advisorsAdvisees;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //---------------------------- PA COORDINATOR --------------------------------//
}
