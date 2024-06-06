import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/data/services/image_picker_service.dart';
import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_avatar.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/profile/data/mixins/profile_mixin.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/blocs/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.args,
  });

  final EditProfileScreenArgs args;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with ProfileMixin {
  ImagePickerService? _imagePickerService;
  FormGroup? _editProfileForm;

  XFile? _image;
  bool? _isFromMedia;

  Future<void> _onUpdateAccountPressed() async {
    if (_editProfileForm!.invalid) {
      _editProfileForm!.markAllAsTouched();
    } else {
      DialogUtils.showConfirmationDialog(
        context,
        title: 'Confirmation',
        content: 'Are you sure you want to update your profile?',
        onPrimaryButtonPressed: () async {
          Navigator.pop(context);

          await context.read<EditProfileCubit>().updateProfile(
                form: _editProfileForm!,
                profilePhoto: _image,
              );
        },
      );
    }
  }

  void _avatarOnPressed() {
    DialogUtils.showBottomMediaSheet(
      context,
      header: 'Select Media',
      onCameraPressed: () async {
        XFile? imagePath = await _imagePickerService!.pickImage(Media.camera);
        _setImage(imagePath);
      },
      onGalleryPressed: () async {
        XFile? imagePath0 = await _imagePickerService!.pickImage(Media.gallery);
        _setImage(imagePath0);
      },
    );
  }

  void _setImage(XFile? imagePath) {
    setState(() {
      _image = imagePath;

      if (_image != null) {
        _isFromMedia = true;
      } else {
        _isFromMedia = false;
        _image = null;
      }
    });

    Navigator.pop(context);
  }

  void _onSuccess(EditProfileSuccess state) {
    SnackbarUtils.removeCurrentSnackbar(context: context);

    if (state.handleSnackbar) {
      CustomLoader.of(context).managePop(true);
      CustomLoader.of(context).hide();

      SnackbarUtils.showSnackbar(
        context: context,
        title: 'Profile updated successfully!',
      );

      Navigator.pop(context);

      context.read<AccountCubit>().loadUser();
    }
  }

  void _onError(EditProfileError state) {
    SnackbarUtils.removeCurrentSnackbar(context: context);

    CustomLoader.of(context).managePop(true);
    CustomLoader.of(context).hide();

    SnackbarUtils.showSnackbar(
      context: context,
      title: state.errorMessage!,
    );
  }

  @override
  void initState() {
    _imagePickerService = ImagePickerService();
    _editProfileForm = FormGroup({
      'firstName': FormControl<String>(validators: [Validators.required]),
      'middleName': FormControl<String>(),
      'lastName': FormControl<String>(validators: [Validators.required]),
      'organizationName': FormControl<String>(validators: [
        Validators.required,
      ]),
      'bio': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(100),
        Validators.maxLength(250),
      ]),
      'emailAddress': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'mobileNumber': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern('^(9)\\d{9}'),
          Validators.maxLength(10),
        ],
      ),
    });

    if (widget.args.user.getUserRole == UserRole.organization) {
      _editProfileForm!.control('firstName').clearValidators();
      _editProfileForm!.control('firstName').updateValueAndValidity();

      _editProfileForm!.control('lastName').clearValidators();
      _editProfileForm!.control('lastName').updateValueAndValidity();
    } else {
      _editProfileForm!.control('organizationName').clearValidators();
      _editProfileForm!.control('organizationName').updateValueAndValidity();
    }

    _isFromMedia = false;

    context.read<EditProfileCubit>().populateUserData(_editProfileForm!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Profile'),
      bottomNavigationBar: CustomButton(
        buttonInsetPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 47.0,
        ),
        onPressed: () async => await _onUpdateAccountPressed(),
        buttonTitle: 'Update profile',
        titleTextStyle: AppStyle.kStyleRegular.copyWith(
          fontSize: 17.0,
          color: AppStyle.kColorWhite,
        ),
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileLoading) {
            CustomLoader.of(context).show();
          }

          if (state is EditProfileSuccess) {
            _onSuccess(state);
          }

          if (state is EditProfileError) {
            _onError(state);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 23.0,
                right: 23.0,
                top: 25.0,
              ),
              child: ReactiveForm(
                formGroup: _editProfileForm!,
                child: Column(
                  children: [
                    CustomAvatar(
                      size: 140.0,
                      heroTag: 'profilePhoto',
                      isEditable: true,
                      isFromMedia: _isFromMedia!,
                      name: buildProfileName(state),
                      mediaAsset: _image,
                      networkAsset: buildProfilePicture(state),
                      avatarOnPressed: _avatarOnPressed,
                    ),
                    const SizedBox(height: 30.0),
                    (widget.args.user.getUserRole == UserRole.individual ||
                            widget.args.user.getUserRole == UserRole.admin)
                        ? CustomTextField(
                            'firstName',
                            label: 'First Name',
                            validationMessages: {
                              'required': (error) => 'First name is required',
                            },
                          )
                        : const SizedBox.shrink(),
                    (widget.args.user.getUserRole == UserRole.individual ||
                            widget.args.user.getUserRole == UserRole.admin)
                        ? const CustomTextField(
                            'middleName',
                            label: 'Middle Name (Optional)',
                          )
                        : const SizedBox.shrink(),
                    (widget.args.user.getUserRole == UserRole.individual ||
                            widget.args.user.getUserRole == UserRole.admin)
                        ? CustomTextField(
                            'lastName',
                            label: 'Last Name',
                            validationMessages: {
                              'required': (error) => 'Last name is required',
                            },
                          )
                        : const SizedBox.shrink(),
                    (widget.args.user.getUserRole == UserRole.organization)
                        ? CustomTextField(
                            'organizationName',
                            label: 'Organization Name',
                            validationMessages: {
                              'required': (error) =>
                                  'Organization name is required',
                            },
                          )
                        : const SizedBox.shrink(),
                    CustomTextField(
                      'emailAddress',
                      filled: true,
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      validationMessages: {
                        'required': (error) => 'Email address is required',
                        'email': (error) =>
                            'Please enter a valid email address',
                      },
                    ),
                    CustomTextField(
                      'mobileNumber',
                      label: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      prefixWidget: const Text('+63'),
                      validationMessages: {
                        'required': (error) => 'Mobile number is required',
                        'pattern': (error) =>
                            'Please enter a valid mobile number',
                        'maxLength': (error) =>
                            'Please enter a valid mobile number',
                      },
                    ),
                    CustomTextField(
                      'bio',
                      label: 'Put a short description about yourself',
                      enableLabel: false,
                      maxLines: 10,
                      maxLength: 250,
                      validationMessages: {
                        'required': (error) => 'Short bio is required',
                        'minLength': (error) =>
                            'Bio must be at least 100 characters long and must not exceed to 250 characters.',
                        'maxLength': (error) =>
                            'Bio must be at least 100 characters long and must not exceed to 250 characters.',
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditProfileScreenArgs {
  final UserDto user;
  EditProfileScreenArgs({required this.user});
}
