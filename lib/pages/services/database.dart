import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padvisor/pages/model/problems.dart';
import 'package:padvisor/pages/model/student.dart';
import 'package:padvisor/pages/student/student_dashboard.dart';

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

  //STREAM PROBLEMS
  Stream<List<Problems>>? getProblems(String? studentId) {
    return db
        .collection('problems')
        .doc(studentId)
        .collection('studentproblems')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Problems.fromJson(doc.data())).toList());
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

  // // GET STUDENTS LIST
  // Stream<> getStudents() {
  //   try {
  //     db.collection('students').snapshots().map((snapshot) => snapshot.docs.map((doc) => ))
  //   } catch (e) {
  //     e.hashCode;
  //   }
  // }

  // GET ADVISEE LIST
  Future<List<Advisee>> get advisees async {
    QuerySnapshot<Map<String, dynamic>> students =
        await db.collection('students').get();
    return students.docs
        .map((doc) => Advisee(doc.id, doc.get('name')))
        .toList();
  }

  // ADD ADVISEE INTO COHORT
  Future<void> addAdviseeIntoCohort(
      String advisee, String advisor, String cohort) async {
    try {
      await db.collection('students').doc(advisee).update({
        'advisor': advisor,
        'cohort': cohort,
      });
    } catch (e) {
      e.hashCode;
    }
  }

  // GET ADVISOR LIST
  Future<List<AdvisorAdvisee>> get advisors async {
    QuerySnapshot<Map<String, dynamic>> advisors =
        await db.collection('advisors').get();
    return advisors.docs
        .map((doc) => AdvisorAdvisee(doc.id, doc.get('name')))
        .toList();
  }

  // ADD ADVISOR INTO COHORT
  Future<void> addAdvisorInCohort(String advisor, String cohort) async {
    try {
      await db.collection('advisors').doc(advisor).update({
        'cohorts': FieldValue.arrayUnion([cohort])
      });
    } catch (e) {
      e.hashCode;
    }
  }

  // GET ADVISOR-ADVISEE
  Future<List<AdvisorAdvisee>> getAdvisorAdvisee(String cohort) async {
    try {
      QuerySnapshot<Map<String, dynamic>> advisors = await db
          .collection('advisors')
          .where('cohorts', arrayContains: cohort)
          .get();

      List<AdvisorAdvisee> advisoradvisee = advisors.docs
          .map((doc) => AdvisorAdvisee(doc.id, doc.get('name')))
          .toList();

      for (var e in advisoradvisee) {
        QuerySnapshot<Map<String, dynamic>> advisees = await db
            .collection('students')
            .where('advisor', isEqualTo: e.id)
            .where('cohort', isEqualTo: cohort)
            .get();

        List<Advisee> a =
            advisees.docs.map((a) => Advisee(a.id, a.get('name'))).toList();

        e.setAdvisees(a);
      }

      return advisoradvisee;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //---------------------------- PA COORDINATOR --------------------------------//
}
