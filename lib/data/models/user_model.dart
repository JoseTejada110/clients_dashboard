import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/data/models/account_model.dart';

List<UserModel> userFromJson(dynamic json) =>
    List<UserModel>.from(json.map((x) => UserModel.fromJson(x)));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.referredBy,
    required this.verifiedBy,
    required this.address,
    required this.status,
    required this.birthdayDate,
    required this.email,
    required this.faceImage,
    required this.identification,
    required this.identificationImage,
    required this.identificationType,
    required this.isAdmin,
    required this.name,
    required this.phoneNumber,
    required this.addressProofImage,
    required this.createdAt,
    required this.accounts,
    required this.bankAccounts,
  });

  String id;
  final DocumentReference<Map<String, dynamic>>? referredBy;
  final DocumentReference<Map<String, dynamic>>? verifiedBy;
  String status;
  String address;
  DateTime birthdayDate;
  String email;
  String faceImage;
  String identification;
  String identificationImage;
  String identificationType;
  bool isAdmin;
  String name;
  String phoneNumber;
  String addressProofImage;
  DateTime createdAt;
  List<Account> accounts;
  CollectionReference<Map<String, dynamic>>? bankAccounts;

  factory UserModel.fromJson(Map<String, dynamic> json,
          {bool isAccountsLoaded = false}) =>
      UserModel(
        id: json["id"],
        referredBy: json["referred_by"],
        verifiedBy: json["verified_by"],
        address: json["address"] ?? '',
        status: json["status"] ?? '',
        birthdayDate: (json['birthday_date'] as Timestamp).toDate(),
        email: json["email"] ?? '',
        faceImage: json["face_image"] ?? '',
        identification: json["identification"] ?? '',
        identificationImage: json["identification_image"] ?? '',
        identificationType: json["identification_type"] ?? '',
        isAdmin: json["is_admin"],
        name: json["name"] ?? '',
        phoneNumber: json["phone_number"] ?? '',
        addressProofImage: json["address_proof_image"] ?? '',
        createdAt: (json['created_at'] as Timestamp).toDate(),
        accounts:
            isAccountsLoaded ? (json['accounts'] ?? <Account>[]) : <Account>[],
        bankAccounts: json['bank_accounts'],
      );

  Map<String, dynamic> toJson({bool isToStoreInLocal = false}) => {
        "id": id,
        "address": address,
        "status": status,
        "birthday_date": isToStoreInLocal
            ? birthdayDate.toIso8601String()
            : Timestamp.fromDate(birthdayDate),
        "email": email,
        "face_image": faceImage,
        "identification": identification,
        "identification_image": identificationImage,
        "identification_type": identificationType,
        "is_admin": isAdmin,
        "name": name,
        "phone_number": phoneNumber,
        "address_proof_image": addressProofImage,
        "created_at": isToStoreInLocal
            ? createdAt.toIso8601String()
            : Timestamp.fromDate(createdAt),
      };

  Color getColorByStatus() {
    if (status == 'Verificado') return Constants.green;
    return Constants.red;
  }

  bool isVerified() => status == 'Verificado';
}
