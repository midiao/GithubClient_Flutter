import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:github_client/common/model/issue.dart';
import 'package:github_client/common/widget/global_hide_footer.dart';
import 'package:github_client/common/widget/global_progress_bar.dart';
import 'package:github_client/ui/main/issues/main_issues_model.dart';
import 'package:provider/provider.dart';

import 'main_issues_item.dart';

class MainIssuesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainIssuesPageState();
  }
}

class _MainIssuesPageState extends State<MainIssuesPage>
    with AutomaticKeepAliveClientMixin {
  MainIssuesModel _mainIssuesModel = new MainIssuesModel();

  final GlobalKey<RefreshFooterState> _footerKey =
      GlobalKey<RefreshFooterState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainIssuesModel.fetchIssues();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _mainIssuesModel,
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Issues'),
            automaticallyImplyLeading: false,
          ),
          body: _issuePageBody(),
        ),
      ),
    );
  }

  Widget _issuePageBody() {
    return Consumer<MainIssuesModel>(
      builder: (context, MainIssuesModel model, child) {
        final List<Issue> issues = model.issues;
        if (issues.isEmpty) {
          return Center(
            child: ProgressBar(
              visibility: _mainIssuesModel.isLoading ?? false,
            ),
          );
        }
        return Container(
            child: EasyRefresh(
          refreshFooter: GlobalHideFooter(_footerKey),
          child: ListView.builder(
            itemBuilder: (_, index) => MainIssuesItem(
                  issue: issues[index],
                ),
            itemCount: issues.length,
          ),
        ));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
