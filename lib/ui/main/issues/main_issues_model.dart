import 'package:flutter/material.dart';
import 'package:github_client/common/model/issue.dart';
import 'package:github_client/repository/dao_result.dart';
import 'package:github_client/repository/issues_repository.dart';

class MainIssuesModel extends ChangeNotifier {
  List<Issue> _issues = [];

  List<Issue> get issues => _issues;

  int _pageIndex = 0;

  String _sort = IssuesRepository.SORT_UPDATED;

  String _state = IssuesRepository.STATE_ALL;

  bool _isLoading;

  bool get isLoading => _isLoading;

  void updateProgressVisible(final bool visible) {
    if (_isLoading != visible) {
      _isLoading = visible;
      notifyListeners();
    }
  }

  void _onPageLoadSuccess(final List<Issue> newIssues) {
    _issues.addAll(newIssues);
    _pageIndex++;
    notifyListeners();
  }

  Future<DataResult> fetchIssues() async {
    updateProgressVisible(true);
    final DataResult<List<Issue>> res = await IssuesRepository.fetchIssue(
        page: _pageIndex + 1, sort: _sort, state: _state);
    updateProgressVisible(false);

    print('fetchissues result:' + res.data.toString());
    if (res.result) {
      _onPageLoadSuccess(res.data);
    } else {
      print('用户Issues加载失败');
    }
  }
}
