import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:padvisor/pages/model/advisor_advisee.dart';

import '../model/announcement.dart';

class DatabaseService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // GET ADVISORS
  Future<List<Map<String, dynamic>>> getAdvisors() async {
    try {
      QuerySnapshot snapshot = await db.collection('advisors').get();
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc.get('name'),
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

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

  // ADD COHORT
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
