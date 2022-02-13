import 'dart:convert';

class authModel {
  int id;
  String username;
  String email;
 

  authModel({
    required this.id,
    required this.username,
    required this.email,
  });

  authModel copyWith({
    int? id,
    String? username,
    String? email,
  }) {
    return authModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  factory authModel.fromMap(Map<String, dynamic> map) {
    return authModel(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      email: map['email'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory authModel.fromJson(String source) => authModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'authModel(id: $id, username: $username, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is authModel &&
      other.id == id &&
      other.username == username &&
      other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      email.hashCode;
  }
}
