import 'package:firebase_auth/firebase_auth.dart';
import 'package:padvisor/pages/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users? _userFromFirebase(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  //sign in with email & password

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

  //sign out

}
