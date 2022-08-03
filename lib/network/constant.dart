class Constant {
  static const int cacheDurationHours = 24;

  static const int successCode = 200;
  static const List<int> clientError = [400, 499];
  static const List<int> serverError = [500, 599];

  static const int readTimeout = 6000;
  static const int writeTimeout = 7000;

  static const String baseUrl = "http://api.susumaktam.com";
  static const String login = "/login";

}
