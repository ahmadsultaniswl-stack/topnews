import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get instance => Get.put(AuthService());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> firebaseUser = Rx<User?>(null);


  // this is for google sign in
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }





  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      firebaseUser.value = user;
    });
  }

  bool get isLoggedIn => firebaseUser.value != null;
  User? get currentUser => firebaseUser.value;
  bool get isEmailVerified => firebaseUser.value?.emailVerified ?? false;

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
    firebaseUser.value = _auth.currentUser;
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    } catch (e) {
      throw 'failed to send verification email';
    }
  }

  // this function is use for check valid email

  Future<bool> checkEmailExists(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .get();

    return result.docs.isNotEmpty;
  }

  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        throw 'User not created';
      }
      String id = user.uid;
      await FirebaseFirestore.instance.collection("users").doc(id).set({
        "first name": firstName,
        "last name": lastName,
        "email": email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await user.updateDisplayName('$firstName $lastName');
      await user.sendEmailVerification();
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Auth error occurred';
    } catch (e) {
      throw 'Unexpected error occurred, please try again later';
    }
  }

  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        throw FirebaseAuthException(
          code: 'verify-email',
          message: 'please verify your email first',
        );
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw 'an unexpected error occurred please try again later';
    }
  }


  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'error signing out please try again later';
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) throw Exception("User not logged in");

      String email = user.email!;

      /// RE-AUTHENTICATION
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      /// UPDATE PASSWORD
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw 'unexpected error occurred please try again later';
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw "User not logged in";
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    } catch (e) {
      throw 'something went wrong';
    }
  }

  String handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        return 'Password is incorrect';
      case 'user-not-found':
        return 'No account found with this email';
      case 'invalid-credential':
        return 'email or password wrong';
      case 'invalid-email':
        return 'The email address is not valid';
      case 'email-already-in-use':
        return 'Account already exists with this email address';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'The password is too weak, please choose a stronger password';
      case 'user-disabled':
        return 'This account is disabled';
      case 'too-many-requests':
        return 'Too many attempts, please try again later';
      case 'network-request-failed':
        return 'Network error, please check your internet connection';
      case 'verify-email':
        return 'Please verify your email before logging in';
      default:
        return e.message ?? 'An unexpected error occurred';
    }
  }
}




















