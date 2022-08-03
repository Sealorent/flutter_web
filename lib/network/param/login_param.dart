class LoginParam {
  String username;
  String password;

  LoginParam(this.username, this.password);

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}
