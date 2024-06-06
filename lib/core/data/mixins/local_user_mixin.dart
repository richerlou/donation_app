import 'dart:convert';

import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';

mixin LocalUserMixin {
  final SecuredStorageService _securedStorageService = SecuredStorageService();

  Future<UserDto> loadLocalUser() async {
    String? localData = await _securedStorageService.readSecureData(
      _securedStorageService.localUserKey,
    );

    return UserDto.fromJson(jsonDecode(localData!));
  }
}
