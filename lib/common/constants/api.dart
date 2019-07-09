import 'package:github_client/common/constants/config.dart';

class Api {
  static const String host = "https://api.github.com";

  static const String authorization = "$host/authorizations";

  static const String userInfo = "$host/user";

  static String userEvents(final String username) =>
      '$host/users/$username/received_events';

  static String userRepos(final String username) =>
      '$host/users/$username/repos';

  static const String userIssues = '$host/issues';

  static getPageParams(tab, page, [pageSize = Config.PAGE_SIZE]) {
    if (page != null) {
      if (pageSize != null) {
        return "${tab}page=$page&per_page$pageSize";
      } else {
        return "${tab}page=$page";
      }
    } else {
      return "";
    }
  }
}
