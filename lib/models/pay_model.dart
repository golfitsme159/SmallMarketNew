import 'dart:convert';

class PayModel {
  final String Pay_ID;
  final String PS_Name;
  final String Pay_Date;
  final String Slip_Filename;
  final String RE_ID;
  final String RE_FirstDate;
  final String RE_EndDate;
  final String L_Name;
  final String M_Name;
  final String Price;
  final String T_Name;
  final String Z_Name;
  PayModel({
    required this.Pay_ID,
    required this.PS_Name,
    required this.Pay_Date,
    required this.Slip_Filename,
    required this.RE_ID,
    required this.RE_FirstDate,
    required this.RE_EndDate,
    required this.L_Name,
    required this.M_Name,
    required this.Price,
    required this.T_Name,
    required this.Z_Name,
  });

  PayModel copyWith({
    String? Pay_ID,
    String? PS_Name,
    String? Pay_Date,
    String? Slip_Filename,
    String? RE_ID,
    String? RE_FirstDate,
    String? RE_EndDate,
    String? L_Name,
    String? M_Name,
    String? Price,
    String? T_Name,
    String? Z_Name,
  }) {
    return PayModel(
      Pay_ID: Pay_ID ?? this.Pay_ID,
      PS_Name: PS_Name ?? this.PS_Name,
      Pay_Date: Pay_Date ?? this.Pay_Date,
      Slip_Filename: Slip_Filename ?? this.Slip_Filename,
      RE_ID: RE_ID ?? this.RE_ID,
      RE_FirstDate: RE_FirstDate ?? this.RE_FirstDate,
      RE_EndDate: RE_EndDate ?? this.RE_EndDate,
      L_Name: L_Name ?? this.L_Name,
      M_Name: M_Name ?? this.M_Name,
      Price: Price ?? this.Price,
      T_Name: T_Name ?? this.T_Name,
      Z_Name: Z_Name ?? this.Z_Name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Pay_ID': Pay_ID,
      'PS_Name': PS_Name,
      'Pay_Date': Pay_Date,
      'Slip_Filename': Slip_Filename,
      'RE_ID': RE_ID,
      'RE_FirstDate': RE_FirstDate,
      'RE_EndDate': RE_EndDate,
      'L_Name': L_Name,
      'M_Name': M_Name,
      'Price': Price,
      'T_Name': T_Name,
      'Z_Name': Z_Name,
    };
  }

  factory PayModel.fromMap(Map<String, dynamic> map) {
    return PayModel(
      Pay_ID: map['Pay_ID'] ?? '',
      PS_Name: map['PS_Name'] ?? '',
      Pay_Date: map['Pay_Date'] ?? '',
      Slip_Filename: map['Slip_Filename'] ?? '',
      RE_ID: map['RE_ID'] ?? '',
      RE_FirstDate: map['RE_FirstDate'] ?? '',
      RE_EndDate: map['RE_EndDate'] ?? '',
      L_Name: map['L_Name'] ?? '',
      M_Name: map['M_Name'] ?? '',
      Price: map['Price'] ?? '',
      T_Name: map['T_Name'] ?? '',
      Z_Name: map['Z_Name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PayModel.fromJson(String source) =>
      PayModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PayModel(Pay_ID: $Pay_ID, PS_Name: $PS_Name, Pay_Date: $Pay_Date, Slip_Filename: $Slip_Filename, RE_ID: $RE_ID, RE_FirstDate: $RE_FirstDate, RE_EndDate: $RE_EndDate, L_Name: $L_Name, M_Name: $M_Name, Price: $Price, T_Name: $T_Name, Z_Name: $Z_Name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PayModel &&
        other.Pay_ID == Pay_ID &&
        other.PS_Name == PS_Name &&
        other.Pay_Date == Pay_Date &&
        other.Slip_Filename == Slip_Filename &&
        other.RE_ID == RE_ID &&
        other.RE_FirstDate == RE_FirstDate &&
        other.RE_EndDate == RE_EndDate &&
        other.L_Name == L_Name &&
        other.M_Name == M_Name &&
        other.Price == Price &&
        other.T_Name == T_Name &&
        other.Z_Name == Z_Name;
  }

  @override
  int get hashCode {
    return Pay_ID.hashCode ^
        PS_Name.hashCode ^
        Pay_Date.hashCode ^
        Slip_Filename.hashCode ^
        RE_ID.hashCode ^
        RE_FirstDate.hashCode ^
        RE_EndDate.hashCode ^
        L_Name.hashCode ^
        M_Name.hashCode ^
        Price.hashCode ^
        T_Name.hashCode ^
        Z_Name.hashCode;
  }
}
