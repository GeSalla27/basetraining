import 'package:flutter/material.dart';

class UserModal {
  final String id;
  final String idAuth;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;
  final UserModal instructor;
  final String fcmToken;

  const UserModal(
      {this.id,
      this.idAuth,
      @required this.name,
      @required this.email,
      @required this.password,
      @required this.phone,
      this.role,
      this.instructor,
      this.fcmToken});

  UserModal.fromMap(Map snapshot, String id)
      : id = id ?? '',
        idAuth = snapshot['idAuth'] ?? '',
        name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        password = snapshot['password'] ?? '',
        phone = snapshot['phone'] ?? '',
        role = snapshot['role'] ?? '',
        instructor = snapshot['instructor'] == null
            ? null
            : UserModal.fromMap(
                snapshot['instructor'], snapshot['instructor']['id']),
        fcmToken = snapshot['fcmToken'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'idAuth': idAuth,
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role,
        'instructor': instructor == null ? null : instructor.toJson(),
        'fcmToken': fcmToken
      };

  @override
  String toString() {
    return super.toString();
  }
}
