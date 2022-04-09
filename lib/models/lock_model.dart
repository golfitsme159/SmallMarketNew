import 'dart:convert';

class LockModel {
  final String L_ID;
  final String L_Name;
  final String Price;
  final String Z_Name;
  final String T_Name;
  LockModel({
    required this.L_ID,
    required this.L_Name,
    required this.Price,
    required this.Z_Name,
    required this.T_Name,
  });

  LockModel copyWith({
    String? L_ID,
    String? L_Name,
    String? Price,
    String? Z_Name,
    String? T_Name,
  }) {
    return LockModel(
      L_ID: L_ID ?? this.L_ID,
      L_Name: L_Name ?? this.L_Name,
      Price: Price ?? this.Price,
      Z_Name: Z_Name ?? this.Z_Name,
      T_Name: T_Name ?? this.T_Name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'L_ID': L_ID,
      'L_Name': L_Name,
      'Price': Price,
      'Z_Name': Z_Name,
      'T_Name': T_Name,
    };
  }

  factory LockModel.fromMap(Map<String, dynamic> map) {
    return LockModel(
      L_ID: map['L_ID'] ?? '',
      L_Name: map['L_Name'] ?? '',
      Price: map['Price'] ?? '',
      Z_Name: map['Z_Name'] ?? '',
      T_Name: map['T_Name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LockModel.fromJson(String source) =>
      LockModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LockModel(L_ID: $L_ID, L_Name: $L_Name, Price: $Price, Z_Name: $Z_Name, T_Name: $T_Name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LockModel &&
        other.L_ID == L_ID &&
        other.L_Name == L_Name &&
        other.Price == Price &&
        other.Z_Name == Z_Name &&
        other.T_Name == T_Name;
  }

  @override
  int get hashCode {
    return L_ID.hashCode ^
        L_Name.hashCode ^
        Price.hashCode ^
        Z_Name.hashCode ^
        T_Name.hashCode;
  }
}
