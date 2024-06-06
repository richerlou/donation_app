part of 'account_cubit.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountSuccess extends AccountState {
  final bool forSignOut;
  final UserDto? user;

  const AccountSuccess({this.forSignOut = false, this.user});

  @override
  List<Object> get props => [forSignOut, user!];
}

class AccountError extends AccountState {
  final bool forSignOut;
  final String? errorMessage;

  const AccountError({this.forSignOut = false, this.errorMessage});

  @override
  List<Object> get props => [forSignOut, errorMessage!];
}
