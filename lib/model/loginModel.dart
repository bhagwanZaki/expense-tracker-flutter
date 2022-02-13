import 'dart:convert';

import 'package:expense_tracker_app/model/authModel.dart';
import 'package:expense_tracker_app/model/profileModel.dart';

class loginModel {
  authModel user;
  String token;
  profileModel profile;
  bool profileExists;

  loginModel({
    required this.user,
    required this.token,
    required this.profile,
    required this.profileExists,
  });

  loginModel copyWith({
    authModel? user,
    String? token,
    profileModel? profile,
    bool? profileExists,
  }) {
    return loginModel(
      user: user ?? this.user,
      token: token ?? this.token,
      profile: profile ?? this.profile,
      profileExists: profileExists ?? this.profileExists,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'token': token,
      'profile': profile.toMap(),
      'profileExists': profileExists,
    };
  }

  factory loginModel.fromMap(Map<String, dynamic> map) {
    return loginModel(
      user: authModel.fromMap(map['user']),
      token: map['token'] ?? '',
      profile: profileModel.fromMap(map['profile'][0]),
      profileExists: map['profileExists'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory loginModel.fromJson(String source) => loginModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'loginModel(user: $user, token: $token, profile: $profile, profileExists: $profileExists)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is loginModel &&
      other.user == user &&
      other.token == token &&
      other.profile == profile &&
      other.profileExists == profileExists;
  }

  @override
  int get hashCode {
    return user.hashCode ^
      token.hashCode ^
      profile.hashCode ^
      profileExists.hashCode;
  }
}
