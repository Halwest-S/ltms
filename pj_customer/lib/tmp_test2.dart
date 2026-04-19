// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:pj_domain/pj_domain.dart';

void main() {
  final backendJson = {
    "id": 1,
    "name": "Hazhar",
    "email": "h@test.com",
    "role": "customer",
    "is_active": true,
    "device_token": "some-token",
  };
  
  try {
    // 1. Decoded from backend
    final user = User.fromJson(backendJson);
    print("User from backend: $user");

    // 2. Encoded to JSON string (like SharedPreferences)
    final encoded = jsonEncode(user.toJson());
    print("Stored in SharedPreferences: $encoded");

    // 3. Decoded from SharedPreferences
    final decodedMap = jsonDecode(encoded);
    final restoredUser = User.fromJson(decodedMap as Map<String, dynamic>);
    print("User from SharedPreferences: $restoredUser");
  } catch (e, st) {
    print("Exception: $e\n$st");
  }
}
