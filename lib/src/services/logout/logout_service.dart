import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {
  final GoogleSignIn _googleSignIn;
  final SharedPreferences _preferences;

  LogoutService(this._googleSignIn, this._preferences);

  Future signOut() async {
    await _googleSignIn.signOut();
    await _preferences.clear();
  }
}
