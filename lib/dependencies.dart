import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meh_chat/src/services/login/login.dart';
import 'package:meh_chat/src/services/logout/logout_service.dart';
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future initKiwi() async {
  Container().registerFactory((c) => GoogleSignIn());
  Container().registerFactory((c) => FirebaseAuth.instance);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Container().registerFactory((c) => preferences);
  Container()
      .registerFactory((c) => UserHandler(c.resolve<SharedPreferences>()));
  Container().registerFactory(
      (c) => LoginService(c.resolve(), c.resolve(), c.resolve()));
  Container().registerFactory(
      (c) => LogoutService(c.resolve(), c.resolve<SharedPreferences>()));
}
