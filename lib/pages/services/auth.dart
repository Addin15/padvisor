import 'package:firebase_auth/firebase_auth.dart';
import 'package:padvisor/pages/model/student.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Students? _userFromFirebase(User? user) {
    return user != null ? Students(uid: user.uid) : null;
  }

  get userId => _auth.currentUser!.uid;

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  signOut() {
    _auth.signOut();
  }
}
