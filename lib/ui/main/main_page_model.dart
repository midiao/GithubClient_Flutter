import 'package:flutter/material.dart';

class MainPageModel with ChangeNotifier {
  static const int TAB_INDEX_EVENTS = 0;
  static const int TAB_INDEX_REPOS = 1;
  static const int TAB_INDEX_ISSUES = 2;
  static const int TAB_INDEX_PROFILE = 3;
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;
  final PageController pageController = PageController();

  void onTabPageChanged(int newIndex) {
    _verifyIndexLegal(newIndex);
    if (_currentPageIndex != newIndex) {
      _currentPageIndex = newIndex;
      pageController.jumpToPage(newIndex);
      notifyListeners();
    }
  }

  void _verifyIndexLegal(int index) {
    var legals = [
      TAB_INDEX_EVENTS,
      TAB_INDEX_REPOS,
      TAB_INDEX_ISSUES,
      TAB_INDEX_PROFILE
    ];
    if (!legals.contains(index)) {
      throw Exception('newIndex error, should be $legals, but is $index.');
    }
  }
}
