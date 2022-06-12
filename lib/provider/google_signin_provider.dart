import 'package:backup_your_phone/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninProvider extends ChangeNotifier {
  final googleSignin = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignin.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (err) {
      ToastMassageShort(msg: err.toString());
      print("@@@@@@@@@@@@@@@@@@@$err");
    }

    notifyListeners();
  }

  Future googleLogout() async {
    try {
      await googleSignin.disconnect();
      await FirebaseAuth.instance.signOut();
    } catch (err) {
      ToastMassageShort(msg: err.toString());
    }
  }
}
