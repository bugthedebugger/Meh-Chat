import 'package:meh_chat/src/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHandler {
  final SharedPreferences _preferences;

  UserHandler(this._preferences);

  void create(User user) {
    _preferences.setString('name', user.name);
    _preferences.setString('email', user.email);
    _preferences.setString('uid', user.uid);
    _preferences.setString('avatar', user.avatar);
    _preferences.setString('reference', user.reference);
  }

  User getUser() {
    String email = _preferences.getString('email');
    String name = _preferences.getString('name');
    String uid = _preferences.getString('uid');
    String avatar = _preferences.getString('avatar');
    String reference = _preferences.getString('reference');

    return User.fromJson({
      'email': email,
      'name': name,
      'uid': uid,
      'avatar': avatar,
      'reference': reference,
    });
  }

  void clear() {
    _preferences.clear();
  }
}
