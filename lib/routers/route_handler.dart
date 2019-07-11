import 'package:fluro/fluro.dart';
import 'package:github_client/ui/login/login_page.dart';
import 'package:github_client/ui/main/main_page.dart';

final Handler loginHandler = Handler(
  handlerFunc: (context, params) => LoginPage(),
);
final Handler mainHandler = Handler(
  handlerFunc: (context, params) => MainPage(),
);
