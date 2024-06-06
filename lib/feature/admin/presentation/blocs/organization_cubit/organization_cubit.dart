import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';

part 'organization_state.dart';

class OrganizationCubit extends Cubit<OrganizationState> {
  OrganizationCubit(
    this._userRepository,
  ) : super(OrganizationInitial());

  final UserRepositoryImpl _userRepository;

  Stream<QuerySnapshot>? getOrganizations() =>
      _userRepository.getOrganizations();

  Future<void> approveOrganization({
    required UserDto data,
  }) async {
    emit(OrganizationLoading());

    print(data.userId);
    print(data.toJson());

    try {
      await _userRepository.updateUser(
        data.userId!,
        updateProfileData: data,
      );

      emit(OrganizationSubmitSuccess(
        user: data,
      ));
    } catch (err) {
      if (err is SocketException) {
        emit(const OrganizationError(
          errorMessage: 'Please check your internet connection.',
        ));
      } else {
        emit(const OrganizationError(
          errorMessage: 'Oops! Something went wrong.',
        ));
      }
    }
  }
}
