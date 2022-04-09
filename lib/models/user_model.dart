import 'dart:convert';

class UserModel {
  final String? M_ID;
  final String? M_User;
  final String? M_Pass;
  final String? M_Name;
  final String? M_Phonenumber;
  UserModel({
    this.M_ID,
    this.M_User,
    this.M_Pass,
    this.M_Name,
    this.M_Phonenumber,
  });

  UserModel copyWith({
    String? M_ID,
    String? M_User,
    String? M_Pass,
    String? M_Name,
    String? M_Phonenumber,
  }) {
    return UserModel(
      M_ID: M_ID ?? this.M_ID,
      M_User: M_User ?? this.M_User,
      M_Pass: M_Pass ?? this.M_Pass,
      M_Name: M_Name ?? this.M_Name,
      M_Phonenumber: M_Phonenumber ?? this.M_Phonenumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'M_ID': M_ID,
      'M_User': M_User,
      'M_Pass': M_Pass,
      'M_Name': M_Name,
      'M_Phonenumber': M_Phonenumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      M_ID: map['M_ID'],
      M_User: map['M_User'],
      M_Pass: map['M_Pass'],
      M_Name: map['M_Name'],
      M_Phonenumber: map['M_Phonenumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(M_ID: $M_ID, M_User: $M_User, M_Pass: $M_Pass, M_Name: $M_Name, M_Phonenumber: $M_Phonenumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.M_ID == M_ID &&
        other.M_User == M_User &&
        other.M_Pass == M_Pass &&
        other.M_Name == M_Name &&
        other.M_Phonenumber == M_Phonenumber;
  }

  @override
  int get hashCode {
    return M_ID.hashCode ^
        M_User.hashCode ^
        M_Pass.hashCode ^
        M_Name.hashCode ^
        M_Phonenumber.hashCode;
  }
}
