import 'dart:convert';

class profileModel {
  int id;
  int user_linked_id;
  int amount;
  profileModel({
    required this.id,
    required this.user_linked_id,
    required this.amount,
  });

  profileModel copyWith({
    int? id,
    int? user_linked_id,
    int? amount,
  }) {
    return profileModel(
      id: id ?? this.id,
      user_linked_id: user_linked_id ?? this.user_linked_id,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_linked_id': user_linked_id,
      'amount': amount,
    };
  }

  factory profileModel.fromMap(Map<String, dynamic> map) {
    return profileModel(
      id: map['id']?.toInt() ?? 0,
      user_linked_id: map['user_linked_id']?.toInt() ?? 0,
      amount: map['amount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory profileModel.fromJson(String source) => profileModel.fromMap(json.decode(source));

  @override
  String toString() => 'profileModel(id: $id, user_linked_id: $user_linked_id, amount: $amount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is profileModel &&
      other.id == id &&
      other.user_linked_id == user_linked_id &&
      other.amount == amount;
  }

  @override
  int get hashCode => id.hashCode ^ user_linked_id.hashCode ^ amount.hashCode;
}
