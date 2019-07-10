import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:github_client/routers/route_handler.dart';
import 'package:github_client/ui/login/login_page.dart';

class Routes {
  static String root = '/';
  static String detailPage = '/detail';

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('Error ===> ROUTE WAS NOT FOUND');
    });

    router
      ..define(LoginPage.path, handler: loginHandler);
  }
}
