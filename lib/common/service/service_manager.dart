import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:github_client/common/service/api_code.dart';
import 'package:github_client/common/service/result_data.dart';

import 'interceptors/header_interceptor.dart';
import 'interceptors/response_interceptor.dart';
import 'interceptors/token_interceptor.dart';

final ServiceManager serviceManager = ServiceManager();

class ServiceManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  final Dio _dio = Dio();
  final TokenInterceptor _tokenInterceptor = TokenInterceptor();

  ServiceManager() {
    _dio.interceptors.add(new HeaderInterceptors());
    _dio.interceptors.add(new LogInterceptor());
    _dio.interceptors.add(new ResponseInterceptors());
    _dio.interceptors.add(_tokenInterceptor);
  }

  netFetch(final url, final params, final Map<String, dynamic> header,
      Options option,
      {final bool noTip = false}) async {
    Map<String, dynamic> headers = new HashMap();
    if (headers != null) {
      headers.addAll(headers);
    }
    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }
    Response response;
    try {
      response = await _dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      return _resultError(response.data, noTip);
    }
    return response.data;
  }

  _resultError(final DioError e, final bool noTip) {
    Response errorResponse;
    if (e.response != null) {
      errorResponse = e.response;
    } else {
      errorResponse = new Response(statusCode: 666);
    }
    return new ResultData(
        ApiCode.errorhandleFunction(errorResponse.statusCode, e.message, noTip),
        false,
        errorResponse.statusCode);
  }

  clearAuthorization() {
    _tokenInterceptor.clearAuthorization();
  }

  getAuthorization() async {
    return _tokenInterceptor.getAuthorization();
  }
}
