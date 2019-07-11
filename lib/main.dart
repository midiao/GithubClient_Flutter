import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:github_client/routers/routes.dart';
import 'package:github_client/routers/application.dart';
import 'package:github_client/common/constants/config.dart';
import 'common/constants/colors.dart';
import 'common/providers/global_user_model.dart';
import 'ui/login/login_page.dart';
import 'ui/login/login_page_model.dart';
import 'package:provider/provider.dart';

void main() {
  var globalUserInfoModel = GlobalUserModel();
  var loginModel = LoginPageModel();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: globalUserInfoModel),
      ChangeNotifierProvider.value(value: loginModel)
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return MaterialApp(
      title: 'Flutter-Github',
      onGenerateRoute: Application.router.generator,
      debugShowCheckedModeBanner: Config.DEBUG,
      theme: ThemeData(
          primaryColor: colorPrimary,
          primaryColorDark: colorPrimaryDark,
          accentColor: colorAccent),
      home: LoginPage(),
    );
  }
}
