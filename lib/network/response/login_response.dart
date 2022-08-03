
class LoginResponse {
  LoginResponse({
    this.token,
    this.tokenType,
    this.expiresIn,
    this.role,
  });

  String? token;
  String? tokenType;
  double? expiresIn;
  Role? role;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"].toDouble(),
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "role": role?.toJson(),
      };
}

class Role {
  Role({
    this.id,
    this.roleName,
    this.createdAt,
  });

  int? id;
  String? roleName;
  DateTime? createdAt;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        roleName: json["role_name"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_name": roleName,
      };
}
