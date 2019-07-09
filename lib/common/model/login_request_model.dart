import 'package:github_client/common/constants/ignore.dart';

class LoginRequestModel {
  List<String> scopes;
  String note;
  String clientId;
  String clientSecret;

  LoginRequestModel._internal(
      this.scopes, this.note, this.clientId, this.clientSecret);

  factory LoginRequestModel() {
    return LoginRequestModel._internal(
        ['user', 'repo', 'gist', 'notifications'],
        Ignore.clientId,
        Ignore.clientId,
        Ignore.clientSecret);
  }
}
