import 'package:flutter/material.dart';
import 'package:github_client/common/constants/assets.dart';
import 'package:github_client/common/constants/colors.dart';
import 'package:github_client/common/providers/global_user_model.dart';
import 'package:github_client/common/widget/global_progress_bar.dart';
import 'package:github_client/repository/dao_result.dart';
import 'package:github_client/routers/application.dart';
import 'package:github_client/ui/login/login_page_model.dart';
import 'package:github_client/ui/main/main_page.dart';
import 'package:provider/provider.dart';

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
                  children: <Widget>[
                    _loginTitle(),
                    _usernameInput(context),
                    _passwordInput(context),
                    _signInButton(context)
                  ],
                ),
              ),
              Consumer<LoginPageModel>(
                  builder: (context, LoginPageModel _loginModel, child) =>
                      ProgressBar(
                        visibility: _loginModel.progressVisible ?? false,
                      ))
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

  Widget _usernameInput(BuildContext context) {
    return Consumer<LoginPageModel>(
        builder: (BuildContext context, LoginPageModel model, child) =>
            Container(
              margin: EdgeInsets.only(top: 24.0),
              child: TextField(
                controller: userNameController,
                keyboardType: TextInputType.text,
                onChanged: (String newValue) =>
                    model.onUserNameChanged(newValue),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    labelText: 'UserName or email address'),
              ),
            ));
  }

  Widget _passwordInput(BuildContext context) {
    return Consumer<LoginPageModel>(
      builder: (context, LoginPageModel model, child) {
        return Container(
          margin: EdgeInsets.only(top: 8.0),
          child: TextField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            onChanged: (String newValue) => model.onPasswordChanged(newValue),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                labelText: 'Password'),
          ),
        );
      },
    );
  }

  Widget _signInButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 32.0),
      width: double.infinity,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.0, maxWidth: double.infinity),
        child: FlatButton(
          onPressed: () => _onLoginButtonClicked(),
          child: Text(
            'Sign in',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
          color: colorSecondaryDark,
          highlightColor: colorPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0))),
        ),
      ),
    );
  }

  void _onLoginButtonClicked() {
    final LoginPageModel _loginModel = Provider.of<LoginPageModel>(context);
    final String username = _loginModel.username;
    final String password = _loginModel.password;

    if (username == null || username.length == 0) {
      return;
    }
    if (password == null || password.length == 0) {
      return;
    }
    _loginModel.login(_globalUserModel).then((res) => _onLoginSuccess(res));
  }

  void _onLoginSuccess(DataResult res) {
    final LoginPageModel _loginModel = Provider.of<LoginPageModel>(context);
    if (res != null && res.result) {
      _loginModel.updateTextField("", userNameController);
      _loginModel.updateTextField("", passwordController);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        Application.router.navigateTo(context, MainPage.path);
        return true;
      });
    }
  }
}
