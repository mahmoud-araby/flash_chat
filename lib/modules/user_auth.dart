import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/modules/user_module.dart';

UserAuth userAuth = UserAuth();

class UserAuth {
  final _auth = FirebaseAuth.instance;
  User _user = User();
  bool isBusy = false;
  FirebaseUser loggedUser;

  Function(String) get email => (String email) => _user.email = email;
  String get getEmail => _user.email;
  Function(String) get password =>
      (String Password) => _user.Password = Password;

  Future<bool> userRegister() async {
    isBusy = true;
    bool ret = false;
    AuthResult result;
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: _user.email, password: _user.email);
      if (result != null) {
        ret = true;
      }
    } catch (e) {
      print(e);
    }
    isBusy = false;
    return ret;
  }

  Future<bool> userLogin() async {
    isBusy = true;
    bool ret = false;
    AuthResult result;
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: _user.email, password: _user.email);
      if (result != null) {
        ret = true;
      }
    } catch (e) {
      print(e);
    }
    isBusy = true;
    return ret;
  }

  getUser() async {
    try {
      loggedUser = await _auth.currentUser();
      print(loggedUser.email);
    } catch (e) {}
  }
}
