import 'package:firebase_auth/firebase_auth.dart';
import 'package:stagebook/utilities.dart/constants.dart';

class AuthService {
  //connecting the firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

//check if the user is logged in or out to show the right screen
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

//signup function
  Future<void> signup(
      String name, String companyId, String email, String password) async {
    try {
      //get the token
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        //create new document with user id
        usersRef.document(authResult.user.uid).setData({
          'fullName': name,
          'companyId': companyId,
          'email': email,
        });
      }
    } catch (e) {
      throw (e);
    }
  }

//logn function
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw (e);
    }
  }

//sign out function
  Future<void> logout() {
    Future.wait([
      _auth.signOut(),
    ]);
  }
}
