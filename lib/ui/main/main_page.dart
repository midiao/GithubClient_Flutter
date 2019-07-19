import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:github_client/common/constants/assets.dart';
import 'package:github_client/common/constants/colors.dart';
import 'package:github_client/ui/main/home/main_events_page.dart';
import 'package:github_client/ui/main/main_page_model.dart';
import 'package:github_client/ui/main/repos/main_repo_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static final String path = 'main_page';

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final List<List<Image>> _bottomTabIcons = [
    [
      Image.asset(mainNavEventsNormal, width: 24.0, height: 24.0),
      Image.asset(mainNavEventsPressed, width: 24.0, height: 24.0),
    ],
    [
      Image.asset(mainNavReposNormal, width: 24.0, height: 24.0),
      Image.asset(mainNavReposPressed, width: 24.0, height: 24.0),
    ],
  ];

  final List<String> _bottomTabTitle = ['home', 'repos'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<MainPageModel>(context).pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MainPageModel _pageModel = Provider.of<MainPageModel>(context);
    return WillPopScope(
        child: Scaffold(
          body: PageView(
            children: <Widget>[
              MainEventsPage(),
              MainReposPage(),
            ],
            controller: _pageModel.pageController,
            onPageChanged: (index) {
              _pageModel.onTabPageChanged(index);
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              _bottomNavigationBarItem(
                  _pageModel, MainPageModel.TAB_INDEX_EVENTS),
              _bottomNavigationBarItem(
                  _pageModel, MainPageModel.TAB_INDEX_REPOS),
            ],
            backgroundColor: colorPrimary,
            currentIndex: _pageModel.currentPageIndex,
            iconSize: 24.0,
            type: BottomNavigationBarType.fixed,
            onTap: (newIndex) {
              _pageModel.onTabPageChanged(newIndex);
            },
          ),
        ),
        onWillPop: () {
          return _dialogExitApp(context);
        });
  }

  Future<bool> _dialogExitApp(BuildContext context) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }
    return Future.value(false);
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
          MainPageModel provider, int tabIndex) =>
      BottomNavigationBarItem(
          icon: _getTabIcon(provider.currentPageIndex, tabIndex),
          title: _getTabTitle(provider.currentPageIndex, tabIndex));

  Image _getTabIcon(int currentPageIndex, int tabIndex) =>
      (currentPageIndex == tabIndex)
          ? _bottomTabIcons[tabIndex][1]
          : _bottomTabIcons[tabIndex][0];

  Text _getTabTitle(int currentPageIndex, int tabIndex) {
    final String title = _bottomTabTitle[tabIndex];
    final Color textColor =
        (currentPageIndex == tabIndex) ? Colors.white : colorSecondaryTextGray;
    return Text(
      title,
      style: TextStyle(fontSize: 14.0, color: textColor),
    );
  }
}
