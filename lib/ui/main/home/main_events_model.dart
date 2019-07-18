import 'package:flutter/material.dart';
import 'package:github_client/common/constants/api.dart';
import 'package:github_client/common/constants/config.dart';
import 'package:github_client/common/model/event.dart';
import 'package:github_client/repository/dao_result.dart';
import 'package:github_client/common/service/service_manager.dart';

class MainEventsModel extends ChangeNotifier {
  List<Event> _eventPageList = [];
  int _pageIndex = 0;
  bool _isLoading;

  List<Event> get eventPagedList => _eventPageList;

  bool get isLoading => _isLoading;

  void updateProgressVisible(final bool visible) {
    if (_isLoading != visible) {
      _isLoading = visible;
      notifyListeners();
    }
  }

  void _onPagedLoadSuccess(final List<Event> newEvents) {
    _eventPageList.addAll(newEvents);
    _pageIndex++;
    notifyListeners();
  }

  Future<DataResult> fetchEvents(final String username) async {
    if (_isLoading == true) {
      return DataResult.failure();
    }
    updateProgressVisible(true);
    var res = await serviceManager.netFetch(
        Api.userEvents(username) + Api.getPageParams('?', _pageIndex + 1),
        null,
        null,
        null);
    var resultData;
    if (res != null && res.result) {
      final List<Event> events = getEventList(res.data);
      _onPagedLoadSuccess(events);
      resultData = DataResult.success(events);
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
