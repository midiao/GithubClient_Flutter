import 'package:flutter/material.dart';
import 'package:github_client/common/constants/api.dart';
import 'package:github_client/common/constants/config.dart';
import 'package:github_client/common/model/issue.dart';
import 'package:github_client/common/service/service_manager.dart';
import 'package:github_client/repository/dao_result.dart';

class IssuesRepository {
  IssuesRepository._();

  static const String SORT_CREATED = 'created';
  static const String SORT_UPDATED = 'updated';
  static const String SORT_COMMENTS = 'comments';
  static const String STATE_OPEN = 'open';
  static const String STATE_CLOSED = 'closed';
  static const String STATE_ALL = 'all';

  static Future<DataResult<List<Issue>>> fetchIssue(
      {String sort = SORT_CREATED,
      String state = STATE_ALL,
      @required int page,
      int perPage = Config.PAGE_SIZE}) async {
    _verifyIssueApiParams(sort, state);
    final String url = Api.userIssues +
        Api.getPageParams('?', page, perPage) +
        '&sort=$sort&state=$state';
    var res = await serviceManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Issue> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return DataResult.failure();
      }
      for (int i = 0; i < data.length; i++) {
        list.add(Issue.fromJson(data[i]));
      }
      return DataResult.success(list);
    } else {
      return DataResult.failure();
    }
  }

  static void _verifyIssueApiParams(final String sort, final String state) {
    if (![SORT_CREATED, SORT_UPDATED, SORT_COMMENTS].contains(sort)) {
      throw Exception('错误的sort参数，请使用SORT_CREATED、SORT_UPDATED、SORT_COMMENTS');
    }
    if (![STATE_OPEN, STATE_CLOSED, STATE_ALL].contains(state)) {
      throw Exception(
          '错误的 state 参数，请使用SORT_CREATED、SORT_UPDATED、SORT_COMMENTS');
    }
  }
}
