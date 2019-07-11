import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_client/common/constants/api.dart';
import 'package:github_client/common/constants/config.dart';
import 'package:github_client/common/constants/ignore.dart';
import 'package:github_client/common/model/user.dart';
import 'package:github_client/common/providers/global_user_model.dart';
import 'package:github_client/common/service/service_manager.dart';
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
    return login(globalUserModel);
  }

  Future<DataResult> login(final GlobalUserModel globalUserModel) async {
    if (progressVisible == true) {
      return new DataResult(null, false);
    }
    final String type = _username + ":" + _password;
    var btyes = utf8.encode(type);
    var base64str = base64.encode(btyes);
    if (Config.DEBUG) {
      print("base64Str login " + base64str);
    }
    await SpUtils.save(Config.USER_NAME_KEY, _username);
    await SpUtils.save(Config.USER_BASIC_CODE, base64str);
    final Map requestParams = {
      "scopes": ['user', 'repo'],
      "note": "admin_script",
      "client_id": Ignore.clientId,
      "client_secret": Ignore.clientSecret
    };
    serviceManager.clearAuthorization();
    updateProgressVisible(true);
    var res = await serviceManager.netFetch(Api.authorization,
        json.encode(requestParams), null, new Options(method: "post"));
    var resultData;
    if (res != null && res.result) {
      await SpUtils.save(Config.PW_KEY, _password);
      resultData = await getUserInfo(null, globalUserModel);
      if (Config.DEBUG) {
        print("user result " + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
    }
    updateProgressVisible(false);
    return new DataResult(resultData, res.result);
  }

  getUserInfo(final String username, final GlobalUserModel globalUserModel,
      {final bool needDb = false}) async {
    next() async {
      var res = await serviceManager.netFetch(Api.userInfo, null, null, null);
      if (res != null && res.result) {
        final User user = User.fromJson(res.data);
        if (needDb) {
          SpUtils.save(Config.USER_INFO, json.encode(user.toJson()));
        }
        globalUserModel.saveUserInfo(user);
        return DataResult(user, true);
      } else {
        return DataResult(res.data, false);
      }
    }

    return await next();
  }
}
