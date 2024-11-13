import 'package:career_quest/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  ProviderRef<Object?> ref;
  SharedPreferences? preferences;
  bool _initialized = false;

  LocalStorageService({
    required this.ref,
  }) {
    _getInstance();
  }

  Future _getInstance() async {
    preferences = await SharedPreferences.getInstance();
    _initialized = true;
  }

  Future<bool?> getUserRegistreationStatus() async {
    if (!_initialized) await _getInstance();
    final String userId = ref.read(userServiceProvider).getUserUid();
    final result = preferences!
        .getBool(userId + LocalStorageServiceKeys.userRegisteredKeySuffix);
    debugPrint("User registration status from local cache: $result");
    return result;
  }

  Future<bool> setUserRegistreationStatus(bool status) async {
    if (!_initialized) await _getInstance();
    final String userId = ref.read(userServiceProvider).getUserUid();
    return await preferences!.setBool(
      userId + LocalStorageServiceKeys.userRegisteredKeySuffix,
      status,
    );
  }
}

class LocalStorageServiceKeys {
  static const String userRegisteredKeySuffix = "_registered";
}
