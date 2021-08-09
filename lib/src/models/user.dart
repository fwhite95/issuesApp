import 'package:flutter/material.dart';

class UserModel {
  const UserModel({
    required this.displayName,
    required this.email,
    required this.uid,
  });

  final String displayName;
  final String email;
  final String uid;
}