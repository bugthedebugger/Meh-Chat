import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    User firebaseUser = await _handleSignIn();
    if (firebaseUser != null) {
      _userHandler.create(firebaseUser);
      return firebaseUser;
    }
    return null;
  }

  Future<bool> checkLogin() async {
    return await _googleSiginIn.isSignedIn();
  }

  Future<User> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSiginIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    User mehUser;

    Firestore firestore = Firestore.instance;
    QuerySnapshot firestoreUserData = await firestore
        .collection('user-data')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();

    if (firestoreUserData.documents.length == 0) {
      await firestore.collection('user-data').document().setData({
        'uid': user.uid,
        'email': user.email,
        'avatar': user.photoUrl,
        'status': false,
        'name': user.displayName,
      });

      firestoreUserData = await firestore
          .collection('user-data')
          .where('uid', isEqualTo: user.uid)
          .getDocuments();

      mehUser = User(
        user.displayName,
        user.email,
        user.uid,
        user.photoUrl,
        firestoreUserData.documents.first.reference.documentID,
      );
    } else {
      mehUser = User(
        user.displayName,
        user.email,
        user.uid,
        user.photoUrl,
        firestoreUserData.documents.first.reference.documentID,
      );
    }

    return mehUser;
  }
}
