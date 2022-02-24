import 'dart:convert';

import 'authModel.dart';

class registerModel {
  authModel user;
  String token;
  registerModel({
    required this.user,
    required this.token,
  });

  registerModel copyWith({
    authModel? user,
    String? token,
  }) {
    return registerModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'token': token,
    };
  }

  factory registerModel.fromMap(Map<String, dynamic> map) {
    return registerModel(
      user: authModel.fromMap(map['user']),
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory registerModel.fromJson(String source) => registerModel.fromMap(json.decode(source));

  @override
  String toString() => 'registerModel(user: $user, token: $token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is registerModel &&
      other.user == user &&
      other.token == token;
  }

  @override
  int get hashCode => user.hashCode ^ token.hashCode;
}
