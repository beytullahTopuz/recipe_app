import 'package:firebase_auth/firebase_auth.dart';
import 'package:recepiesapp/core/models/user.dart';

class AuthorizationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String aktifKullaniciId;

  UserModel _createUser(User u) {
    return u == null ? null : UserModel.firabasedenUret(u);
  }

  Stream<UserModel> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_createUser);
  }

  Future<UserModel> registerWithEmaiil(String email, String password) async {
    var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _createUser(userCredential.user);
  }

  Future<UserModel> loginWithEmail(String email, String password) async {
    var userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return _createUser(userCredential.user);
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<void> deleteUser(User user) async {
    user.delete();
  }

  Future<void> resetPassword(String eposta) async {
    await _firebaseAuth.sendPasswordResetEmail(email: eposta);
  }
}
