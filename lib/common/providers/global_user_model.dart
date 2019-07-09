import 'package:flutter/foundation.dart';
import 'package:github_client/common/model/user.dart';

class GlobalUserModel with ChangeNotifier {
  User _user;

  User get user => _user;

  void saveUserInfo(final User user) {
    this._user = user;
    notifyListeners();
  }
}
