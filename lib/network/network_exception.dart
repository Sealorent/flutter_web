class ClientErrorException implements Exception {
  String message;
  int code;

  ClientErrorException(this.message, this.code);
}