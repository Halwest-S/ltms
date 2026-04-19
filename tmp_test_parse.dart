import 'dart:convert';

enum UserRole {
  customer,
  driver,
  staff,
  superAdmin,
}

Map<String, dynamic> _$$UserImplFromJson(Map<String, dynamic> json) {
  // Mocking the generated fromJson
  return {
    'id': (json['id'] as num).toInt(),
    'name': json['name'] as String,
    'email': json['email'] as String,
    'role': json['role'], // simple mock
    'deviceToken': json['device_token'] as String?,
    'language': json['language'] as String? ?? 'en',
    'theme': json['theme'] as String? ?? 'light',
    'isActive': json['is_active'] as bool? ?? true,
    'isOwner': json['isOwner'] as bool? ?? false,
  };
}

void main() {
  final userJsonFromBackend = {
    'id': 1,
    'name': 'Test',
    'email': 'test@example.com',
    'role': 'customer',
    'is_active': true,
    'is_owner': false, // note the snake_case here!
  };

  print("Decoding from backend:");
  final parsed = _$$UserImplFromJson(userJsonFromBackend);
  print(parsed);

  final userJsonForPrefs = {
      'id': parsed['id'],
      'name': parsed['name'],
      'email': parsed['email'],
      'role': parsed['role'],
      'device_token': parsed['deviceToken'],
      'language': parsed['language'],
      'theme': parsed['theme'],
      'is_active': parsed['isActive'],
      'isOwner': parsed['isOwner'],
  };

  final prefsString = jsonEncode(userJsonForPrefs);
  print("\nSaved to prefs:");
  print(prefsString);

  print("\nDecoding from prefs:");
  final decodedPrefs = jsonDecode(prefsString);
  if (decodedPrefs is Map<String, dynamic>) {
    try {
      final parsedBack = _$$UserImplFromJson(decodedPrefs);
      print("Parsed successfully: $parsedBack");
    } catch(e) {
      print("Error: $e");
    }
  } else {
    print("Not a map string dynamic");
  }
}
