import 'package:flutter/material.dart';
import 'package:github_client/common/providers/global_user_model.dart';
import 'package:provider/provider.dart';
import 'package:github_client/common/constants/assets.dart';
import 'package:github_client/common/constants/colors.dart';

class LoginPage extends StatefulWidget {
  static final String path = 'login_page';

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  GlobalUserModel _globalUserModel;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _globalUserModel = Provider.of<GlobalUserModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            'Sign in',
            textAlign: TextAlign.start,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 38.0, 16.0, 8.0),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[_loginTitle()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginTitle() => Row(
        children: <Widget>[
          Image(
            image: AssetImage(imageGithubCat),
            width: 65.0,
            height: 65.0,
            fit: BoxFit.fitWidth,
          ),
          Container(
            margin: EdgeInsets.only(left: 32.0),
            child: Text(
              'Sign into Githug',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.normal,
                  color: colorPrimaryText),
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
          )
        ],
      );
}
