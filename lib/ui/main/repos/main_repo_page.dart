import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_client/common/model/repo.dart';
import 'package:github_client/common/providers/global_user_model.dart';
import 'package:github_client/common/widget/global_hide_footer.dart';
import 'package:github_client/common/widget/global_progress_bar.dart';
import 'package:github_client/ui/main/repos/main_repo_item.dart';
import 'package:github_client/ui/main/repos/main_repo_model.dart';
import 'package:provider/provider.dart';

class MainReposPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainReposPageState();
  }
}

class _MainReposPageState extends State<MainReposPage>
    with AutomaticKeepAliveClientMixin {
  GlobalUserModel _globalUserModel;
  MainRepoModel _mainRepoModel = MainRepoModel();
  final GlobalKey<RefreshFooterState> _footerKey =
      GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _mainRepoModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Repos'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (newValue) {
                _mainRepoModel.fetchRepos(_globalUserModel.user.login,
                    sort: newValue);
              },
              itemBuilder: (context) => <PopupMenuItem<String>>[
                PopupMenuItem(
                  child: Text('Sort by Update'),
                  value: 'updated',
                ),
                PopupMenuItem(
                  child: Text('Sort by Created'),
                  value: 'created',
                ),
                PopupMenuItem(
                  child: Text('Sort by FullName'),
                  value: 'full_name',
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _globalUserModel = Provider.of<GlobalUserModel>(context);
    _mainRepoModel.fetchRepos(_globalUserModel.user.login);
  }

  Widget _repoList() {
    return Consumer<MainRepoModel>(
      builder: (context, MainRepoModel model, child) {
        if (model.repoPageList.length > 0) {
          return _initExistDataList(model.repoPageList);
        } else {
          return Center(
            child: ProgressBar(
              visibility: _mainRepoModel.isLoading ?? false,
            ),
          );
        }
      },
    );
  }

  Widget _initExistDataList(final List<Repo> renders) {
    return EasyRefresh(
      refreshFooter: GlobalHideFooter(_footerKey),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return MainRepoPageItem(
            repo: renders[index],
            observer: (MainRepoAction action) {
              Fluttertoast.showToast(
                  msg: '被点击的Repo：${action.repoUrl}',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM);
            },
          );
        },
        itemCount: renders.length,
      ),
      autoLoad: true,
      loadMore: () async {
        await _mainRepoModel.fetchRepos(_globalUserModel.user.login);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
