import 'package:flutter/material.dart';
import 'package:github_client/common/constants/api.dart';
import 'package:github_client/common/constants/config.dart';
import 'package:github_client/common/model/repo.dart';
import 'package:github_client/common/service/service_manager.dart';
import 'package:github_client/repository/dao_result.dart';

class MainRepoModel extends ChangeNotifier {
  List<Repo> _repoPageList = [];
  int _pageIndex = 0;
  bool _isLoading;
  String _sort = 'updated';

  List<Repo> get repoPageList => _repoPageList;

  bool get isLoading => _isLoading;

  void updateProgressVisible(final bool visible) {
    if (_isLoading != visible) {
      _isLoading = visible;
      notifyListeners();
    }
  }

  void _onPagedLoadSuccess(final List<Repo> newRepos) {
    _repoPageList.addAll(newRepos);
    _pageIndex++;
    notifyListeners();
  }

  void _onSortParamChanged(final String sort) {
    _sort = sort;
    _clearList();
  }

  void _clearList() {
    _repoPageList.clear();
    _pageIndex = 0;
    notifyListeners();
  }

  Future<DataResult> fetchRepos(final String username,
      {final String sort}) async {
    if (_isLoading == true) {
      return DataResult.failure();
    }
    if (sort != null && sort != _sort) {
      _onSortParamChanged(sort);
    }
    updateProgressVisible(true);
    var res = await serviceManager.netFetch(
        Api.userRepos(username) +
            Api.getPageParams('?', _pageIndex + 1) +
            '&sort=$_sort',
        null,
        null,
        null);
    var resultData;
    if (res != null && res.result) {
      final List<Repo> repos = getRepoList(res.data);
      _onPagedLoadSuccess(repos);
      resultData = DataResult.success(repos);
      if (Config.DEBUG) {
        print("resultData events result " + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
    }
    updateProgressVisible(false);
    return resultData;
  }
}
