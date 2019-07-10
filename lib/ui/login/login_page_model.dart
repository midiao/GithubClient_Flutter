import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_client/common/constants/api.dart';
import 'package:github_client/common/constants/config.dart';
import 'package:github_client/common/constants/ignore.dart';
import 'package:github_client/common/model/user.dart';
import 'package:github_client/common/providers/global_user_model.dart';
import 'package:github_client/repository/dao_result.dart';
import 'package:github_client/repository/sputils.dart';

class LoginPageModel with ChangeNotifier {
  bool _progressVisible;
  bool _tryAutoLogin = true;
  String _username;
  String _password;

  bool get progressVisible => _progressVisible;

  String get username => _username;

  String get password => _password;

  void updateProgressVisible(final bool visible) {
    if (_progressVisible != visible) {
      _progressVisible = visible;
      notifyListeners();
    }
  }

  void onUserNameChanged(final String newValue) {
    if (_username != newValue) {
      _username = newValue;
      notifyListeners();
    }
  }

  void onPasswordChanged(final String newValue) {
    if (_password != newValue) {
      _password = newValue;
      notifyListeners();
    }
  }

  void updateTextField(
      final String newValue, final TextEditingController controller) {
    controller.text = newValue;
  }

  Future<DataResult> tryAutoLogin(
    final TextEditingController usernameController,
    final TextEditingController passwordController,
    final GlobalUserModel globalUserModel,
  ) async {
    if (!_tryAutoLogin) {
      return null;
    }
    _tryAutoLogin = false;

    final String usernameTemp = await SpUtils.get(Config.USER_NAME_KEY) ?? '';
    final String passwordTemp = await SpUtils.get(Config.PW_KEY) ?? '';

    if (usernameTemp == '' || passwordTemp == '') {
      return DataResult.failure();
    }

    _username = usernameTemp;
    _password = passwordTemp;
    updateTextField(_username, usernameController);
    updateTextField(_password, passwordController);
  }
}
