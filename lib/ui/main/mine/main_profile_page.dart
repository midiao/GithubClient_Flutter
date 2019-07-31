import 'package:flutter/material.dart';
import 'package:github_client/common/constants/assets.dart';
import 'package:github_client/common/constants/colors.dart';
import 'package:github_client/common/providers/global_user_model.dart';
import 'package:provider/provider.dart';

class MainProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colorPrimary,
      child: Stack(
        alignment: Alignment.center,
        textDirection: TextDirection.ltr,
        fit: StackFit.loose,
        children: <Widget>[_userInfoLayer()],
      ),
    );
  }

  Widget _userInfoLayer() {
    return Consumer<GlobalUserModel>(
      builder: (context, GlobalUserModel _userModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image(
                image: NetworkImage(_userModel.user.avatarUrl),
                width: 70.0,
                height: 70.0,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  _userModel.user.login ?? "unknown",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                _userModel.user.bio ?? "no description",
                style: TextStyle(fontSize: 14.0, color: colorSecondaryTextGray),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage(mineLocationIcon),
                    width: 15.0,
                    height: 15.0,
                  ),
                  Text(
                    _userModel.user.location ?? 'no address',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: colorSecondaryTextGray,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
