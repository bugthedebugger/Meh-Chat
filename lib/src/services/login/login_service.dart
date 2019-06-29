import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';

class LoginService {
  final GoogleSignIn _googleSiginIn;
  final FirebaseAuth _auth;
  final UserHandler _userHandler;

  LoginService(this._googleSiginIn, this._auth, this._userHandler);

  Future<User> login() async {
    if (await checkLogin()) {
      User user = _userHandler.getUser();
      print("Logged In");
      return user;
    }

    print("Logging In");
    FirebaseUser firebaseUser = await _handleSignIn();
    if (firebaseUser != null) {
      User user = User(
        firebaseUser.displayName,
        firebaseUser.email,
        firebaseUser.uid,
        firebaseUser.photoUrl,
      );

      _userHandler.create(user);
      return user;
    }
    return null;
  }

  Future<bool> checkLogin() async {
    return await _googleSiginIn.isSignedIn();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSiginIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);

    return user;
  }
}
