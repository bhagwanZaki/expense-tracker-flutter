import 'dart:convert';
import 'dart:ffi';

class expenseModel {
  int id;
  String title;
  double amount;
  String incomeOrexpense;
  String amount_date;

  expenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.incomeOrexpense,
    required this.amount_date,
  });

  

  expenseModel copyWith({
    int? id,
    String? title,
    double? amount,
    String? incomeOrexpense,
    String? amount_date,
  }) {
    return expenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      incomeOrexpense: incomeOrexpense ?? this.incomeOrexpense,
      amount_date: amount_date ?? this.amount_date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'incomeOrexpense': incomeOrexpense,
      'amount_date': amount_date,
    };
  }

  factory expenseModel.fromMap(Map<String, dynamic> map) {
    return expenseModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      amount: map['amount'],
      incomeOrexpense: map['incomeOrexpense'] ?? '',
      amount_date: map['amount_date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory expenseModel.fromJson(String source) => expenseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'expenseModel(id: $id, title: $title, amount: $amount, incomeOrexpense: $incomeOrexpense, amount_date: $amount_date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is expenseModel &&
      other.id == id &&
      other.title == title &&
      other.amount == amount &&
      other.incomeOrexpense == incomeOrexpense &&
      other.amount_date == amount_date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      amount.hashCode ^
      incomeOrexpense.hashCode ^
      amount_date.hashCode;
  }
}
