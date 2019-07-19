import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:github_client/common/model/event.dart';
import 'package:github_client/common/providers/global_user_model.dart';
import 'package:github_client/common/widget/global_hide_footer.dart';
import 'package:github_client/common/widget/global_progress_bar.dart';
import 'package:github_client/ui/main/home/main_events_item.dart';
import 'package:github_client/ui/main/home/main_events_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MainEventsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainEventsPageState();
  }
}

class _MainEventsPageState extends State<MainEventsPage>
    with AutomaticKeepAliveClientMixin {
  MainEventsModel _mainEventsModel = MainEventsModel();
  GlobalUserModel _globalUserModel;
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _globalUserModel = Provider.of<GlobalUserModel>(context);
    _mainEventsModel.fetchEvents(_globalUserModel.user.login);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: _mainEventsModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          automaticallyImplyLeading: false,
        ),
        body: _eventList(),
      ),
    );
  }

  Widget _eventList() {
    return Consumer<MainEventsModel>(
        builder: (context, MainEventsModel model, child) {
      if (model.eventPagedList.length > 0) {
        return _initExistDataList(model.eventPagedList);
      } else {
        return Center(
          child: ProgressBar(
            visibility: _mainEventsModel.isLoading ?? false,
          ),
        );
      }
    });
  }

  Widget _initExistDataList(final List<Event> renders) {
    return EasyRefresh(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return MainEventItem(
            event: renders[index],
            observer: (EventItemAction action) {
              if (action.isActorAction) {
                Fluttertoast.showToast(
                    msg: '用户：' + action.url,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM);
              } else {
                Fluttertoast.showToast(
                    msg: '被点击的Repo：' + action.url,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM);
              }
            },
          );
        },
        itemCount: renders.length,
      ),
      refreshFooter: GlobalHideFooter(_footerKey),
      autoLoad: true,
      loadMore: () async {
        await _mainEventsModel.fetchEvents(_globalUserModel.user.login);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
