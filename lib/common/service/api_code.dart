class ApiCode {
  static const NETWORK_ERROR = -1;
  static const NETWORK_TIMEOUT = -2;
  static const NETWORK_JSON_EXCEPTION = -3;
  static const SUCCESS = 200;

  static errorhandleFunction(code, message, noTip) {
    return message;
  }
}
