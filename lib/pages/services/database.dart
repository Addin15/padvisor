import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padvisor/pages/model/advisor.dart';
import 'package:padvisor/pages/model/problems.dart';
import 'package:padvisor/pages/model/student.dart';
import 'package:padvisor/pages/student/student_dashboard.dart';

import '../model/announcement.dart';
import '../model/advisor_advisee.dart';

class DatabaseService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> getUserType(String id) async {
    return await db
        .collection('users')
        .doc(id)
        .get()
        .then((value) => value.get('type'));
  }

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
        .map((snapshot) => snapshot.docs
            .map((doc) => Problems.fromJson(doc.id, doc.data()))
            .toList());
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

  // GET STUDENTS LIST
  Stream<List<Students>> getStudents() {
    return db.collection('students').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Students.fromJson(doc.id, doc.data()))
        .toList());
  }

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

  //---------------------------- ADVISOR --------------------------------//

  Future<Advisor> advisor(String? id) async {
    DocumentSnapshot<Map<String, dynamic>> advisor =
        await db.collection('advisors').doc(id).get();
    return Advisor(name: advisor.get('name'), cohorts: advisor.get('cohorts'));
  }

  Future<void> archiveStudent(String id, bool archive) async {
    await db.collection('students').doc(id).update({
      'archive': archive,
    });
  }

  Future<List<String>> getStudentsId(String advisor) async {
    QuerySnapshot<Map<String, dynamic>> data = await db
        .collection('students')
        .where('advisor', isEqualTo: advisor)
        .get();
    return data.docs.map((e) => e.id).toList();
  }

  Future<List<Students>> getStudentsUnderAdvisor(String advisor) async {
    QuerySnapshot<Map<String, dynamic>> data = await db
        .collection('students')
        .where('advisor', isEqualTo: advisor)
        .get();
    return data.docs.map((e) => Students.fromJson(e.id, e.data())).toList();
  }

  Future<List<Problems>> getStudentsProblems(List<String> studentIds) async {
    List<Problems> problems = [];

    for (String id in studentIds) {
      DocumentSnapshot<Map<String, dynamic>> student =
          await db.collection('students').doc(id).get();

      if (student.get('archive') == false) {
        QuerySnapshot<Map<String, dynamic>> data = await db
            .collection('problems')
            .doc(id)
            .collection('studentproblems')
            .get();

        for (var doc in data.docs) {
          problems.add(
              Problems.fromJson(doc.id, doc.data(), name: student.get('name')));
        }
      }
    }

    return problems;
  }
  //---------------------------- ADVISOR --------------------------------//
}
