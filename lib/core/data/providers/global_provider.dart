import 'package:donation_management/core/data/services/firebase_messaging_service.dart';
import 'package:donation_management/core/data/services/firebase_service.dart';
import 'package:donation_management/core/data/services/secured_storage_service.dart';
import 'package:donation_management/core/domain/authentication_repository.dart';
import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/core/presentation/blocs/application_cubit/application_cubit.dart';
import 'package:donation_management/feature/admin/presentation/blocs/organization_cubit/organization_cubit.dart';
import 'package:donation_management/feature/authentication/login/presentation/blocs/login_cubit/login_cubit.dart';
import 'package:donation_management/feature/authentication/registration/presentation/blocs/registration_cubit/registration_cubit.dart';
import 'package:donation_management/feature/events/domain/donation_repository.dart';
import 'package:donation_management/feature/events/domain/event_repository.dart';
import 'package:donation_management/feature/events/presentation/blocs/donation_cubit/donation_cubit.dart';
import 'package:donation_management/feature/events/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:donation_management/feature/messages/domain/repositories/messages_repository.dart';
import 'package:donation_management/feature/messages/presentation/blocs/message_cubit/message_cubit.dart';
import 'package:donation_management/core/domain/user_repository.dart';
import 'package:donation_management/feature/profile/presentation/blocs/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:donation_management/feature/profile/presentation/blocs/password_cubit/password_cubit.dart';
import 'package:donation_management/feature/profile/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalProvider {
  GlobalProvider._();

  /// Singleton to ensure only one class instance is created
  static final GlobalProvider _instance = GlobalProvider._();
  factory GlobalProvider() => _instance;

  static final FirebaseService _firebaseService = FirebaseService();
  static final FirebaseMessagingService _firebaseMessagingService =
      FirebaseMessagingService();
  static final SecuredStorageService securedStorageService =
      SecuredStorageService();

  static final AuthenticationRepositoryImpl authenticationRepository =
      AuthenticationRepositoryImpl(_firebaseService);
  static final UserRepositoryImpl userRepository =
      UserRepositoryImpl(_firebaseService);
  static final EventRepositoryImpl eventRepository =
      EventRepositoryImpl(_firebaseService);
  static final MessageRepositoryImpl messageRepository =
      MessageRepositoryImpl(_firebaseService);
  static final DonationRepositoryImpl donationRepository =
      DonationRepositoryImpl(_firebaseService);

  /// Put your global blocs here
  static List<BlocProvider> providers = [
    BlocProvider<ApplicationCubit>(
      create: (context) => ApplicationCubit(
        _firebaseService,
        securedStorageService,
        userRepository,
        _firebaseMessagingService,
      )..checkIfUserLoggedIn(),
    ),
    BlocProvider<AccountCubit>(
      create: (context) => AccountCubit(
        authenticationRepository,
        securedStorageService,
        userRepository,
      ),
    ),
    BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        authenticationRepository,
        userRepository,
        securedStorageService,
        _firebaseMessagingService,
      ),
    ),
    BlocProvider<RegistrationCubit>(
      create: (context) => RegistrationCubit(
        authenticationRepository,
        userRepository,
        securedStorageService,
        _firebaseMessagingService,
      ),
    ),
    BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(
        userRepository,
        securedStorageService,
      ),
    ),
    BlocProvider<EditProfileCubit>(
      create: (context) => EditProfileCubit(
        userRepository,
        securedStorageService,
      ),
    ),
    BlocProvider<EventCubit>(
      create: (context) => EventCubit(
        eventRepository,
        userRepository,
      ),
    ),
    BlocProvider<MessageCubit>(
      create: (context) => MessageCubit(
        messageRepository,
        userRepository,
      ),
    ),
    BlocProvider<PasswordCubit>(
      create: (context) => PasswordCubit(authenticationRepository),
    ),
    BlocProvider<DonationCubit>(
      create: (context) => DonationCubit(donationRepository, userRepository),
    ),
        BlocProvider<OrganizationCubit>(
      create: (context) => OrganizationCubit(userRepository),
    ),
  ];
}
