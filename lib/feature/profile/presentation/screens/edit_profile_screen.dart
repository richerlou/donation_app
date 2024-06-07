import 'package:donation_management/core/data/constants/barangay_constants.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/core/data/services/image_picker_service.dart';
import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_avatar.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_dropdown.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/profile/data/mixins/profile_mixin.dart';
import 'package:donation_management/feature/profile/data/models/user_dto.dart';
import 'package:donation_management/feature/profile/presentation/blocs/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final org2RepName = _editProfileForm!.control('organizationRepName2');
    final org2RepNumber = _editProfileForm!.control(
      'organizationRepMobileNumber2',
    );
    final org2RepLocation = _editProfileForm!.control(
      'organizationRepLocation2',
    );

    if (ifHasRep2) {
      if (org2RepName.value == null || org2RepName.value == '') {
        org2RepName.setErrors({'required': true});
      }

      if (org2RepNumber.value == null || org2RepNumber.value == '') {
        org2RepNumber.setErrors({'required': true});
      }

      if (org2RepLocation.value == null || org2RepLocation.value == '') {
        org2RepLocation.setErrors({'required': true});
      }
    } else {
      org2RepName.removeError('required');
      org2RepNumber.removeError('required');
      org2RepLocation.removeError('required');
    }

    if (_editProfileForm!.invalid) {
      _editProfileForm!.markAllAsTouched();
    } else {
      DialogUtils.showConfirmationDialog(
        context,
        title: 'Confirmation',
        content: 'Are you sure you want to update your profile?',
        onPrimaryButtonPressed: () async {
          Navigator.pop(context);

          await context
              .read<EditProfileCubit>()
              .updateProfile(form: _editProfileForm!, profilePhoto: _image);
        },
      );
    }
  }

  void _avatarOnPressed() {
    DialogUtils.showBottomMediaSheet(
      context,
      header: 'Select Media',
      onCameraPressed: () async {
        XFile? _imagePath = await _imagePickerService!.pickImage(
          media: Media.camera,
        );
        _setImage(_imagePath);
      },
      onGalleryPressed: () async {
        XFile? _imagePath = await _imagePickerService!.pickImage(
          media: Media.gallery,
        );
        _setImage(_imagePath);
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
      'firstName': FormControl<String>(validators: [
        Validators.required,
        Validators.pattern('^[a-zA-Z][a-zA-z\\s]+\$'),
      ]),
      'middleName': FormControl<String>(validators: [
        Validators.pattern('^[a-zA-Z][a-zA-z\\s]+\$'),
      ]),
      'lastName': FormControl<String>(validators: [
        Validators.required,
        Validators.pattern('^[a-zA-Z][a-zA-z\\s]+\$'),
      ]),
      'barangay': FormControl<String>(validators: [Validators.required]),
      'organizationName': FormControl<String>(validators: [
        Validators.required,
        Validators.pattern('^[a-zA-Z][a-zA-z\\s]+\$'),
      ]),
      'bio': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(50),
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
      'location': FormControl<String>(validators: [Validators.required]),
      'organizationType': FormControl<String>(
        validators: [Validators.required],
      ),
      'website': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(
            r'(www\.)([,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?',
          ),
        ],
      ),
      'organizationRepName1': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern('^[a-zA-Z][a-zA-z\\s]+\$'),
        ],
      ),
      'organizationRepMobileNumber1': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern('^(9)\\d{9}'),
          Validators.maxLength(10),
        ],
      ),
      'organizationRepLocation1': FormControl<String>(
        validators: [Validators.required],
      ),
      'organizationRepName2': FormControl<String>(
        validators: [
          Validators.pattern('^[a-zA-Z][a-zA-z\\s]+\$'),
        ],
      ),
      'organizationRepMobileNumber2': FormControl<String>(
        validators: [
          Validators.pattern('^(9)\\d{9}'),
          Validators.maxLength(10),
        ],
      ),
      'organizationRepLocation2': FormControl<String>(),
    });

    if (widget.args.user.getUserRole == UserRole.organization) {
      _editProfileForm!.control('firstName').clearValidators();
      _editProfileForm!.control('firstName').updateValueAndValidity();

      _editProfileForm!.control('lastName').clearValidators();
      _editProfileForm!.control('lastName').updateValueAndValidity();

      _editProfileForm!.control('barangay').clearValidators();
      _editProfileForm!.control('barangay').updateValueAndValidity();
    } else {
      _editProfileForm!.control('organizationName').clearValidators();
      _editProfileForm!.control('organizationName').updateValueAndValidity();

      _editProfileForm!.control('organizationType').clearValidators();
      _editProfileForm!.control('organizationType').updateValueAndValidity();

      _editProfileForm!.control('location').clearValidators();
      _editProfileForm!.control('location').updateValueAndValidity();

      _editProfileForm!.control('website').clearValidators();
      _editProfileForm!.control('website').updateValueAndValidity();

      _editProfileForm!.control('organizationRepName1').clearValidators();
      _editProfileForm!
          .control('organizationRepName1')
          .updateValueAndValidity();

      _editProfileForm!
          .control('organizationRepMobileNumber1')
          .clearValidators();
      _editProfileForm!
          .control('organizationRepMobileNumber1')
          .updateValueAndValidity();

      _editProfileForm!.control('organizationRepLocation1').clearValidators();
      _editProfileForm!
          .control('organizationRepLocation1')
          .updateValueAndValidity();

      _editProfileForm!.control('organizationRepName2').clearValidators();
      _editProfileForm!
          .control('organizationRepName2')
          .updateValueAndValidity();

      _editProfileForm!
          .control('organizationRepMobileNumber2')
          .clearValidators();
      _editProfileForm!
          .control('organizationRepMobileNumber2')
          .updateValueAndValidity();

      _editProfileForm!.control('organizationRepLocation2').clearValidators();
      _editProfileForm!
          .control('organizationRepLocation2')
          .updateValueAndValidity();
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
                    (widget.args.user.getUserRole == UserRole.individual)
                        ? CustomTextField(
                            'firstName',
                            label: 'First Name',
                            validationMessages: {
                              'required': (error) => 'First name is required',
                              'pattern': (error) =>
                                  'This field does not accept numbers and symbols.',
                            },
                          )
                        : const SizedBox.shrink(),
                    (widget.args.user.getUserRole == UserRole.individual)
                        ? CustomTextField(
                            'middleName',
                            label: 'Middle Name (Optional)',
                            validationMessages: {
                              'pattern': (error) =>
                                  'This field does not accept numbers and symbols.',
                            },
                          )
                        : const SizedBox.shrink(),
                    (widget.args.user.getUserRole == UserRole.individual)
                        ? CustomTextField(
                            'lastName',
                            label: 'Last Name',
                            validationMessages: {
                              'required': (error) => 'Last name is required',
                              'pattern': (error) =>
                                  'This field does not accept numbers and symbols.',
                            },
                          )
                        : const SizedBox.shrink(),
                    (widget.args.user.getUserRole == UserRole.individual)
                        ? CustomDropdown<String>(
                            'barangay',
                            items: BarangayConstrants.barangayListItems(),
                            label: 'Address (Barangay)',
                            validationMessages: {
                              'required': (error) => 'Address is required',
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
                              'pattern': (error) =>
                                  'This field does not accept numbers and symbols.',
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
                    (widget.args.user.getUserRole == UserRole.organization)
                        ? CustomTextField(
                            'location',
                            label: 'Address',
                            validationMessages: {
                              'required': (error) => 'Address is required',
                            },
                          )
                        : const SizedBox.shrink(),
                    (widget.args.user.getUserRole == UserRole.organization)
                        ? CustomTextField(
                            'website',
                            label: 'Organization Website',
                            validationMessages: {
                              'required': (error) =>
                                  'Organization website is required',
                              'pattern': (error) =>
                                  'Please enter a valid website url',
                            },
                          )
                        : const SizedBox.shrink(),
                    (widget.args.user.getUserRole == UserRole.organization)
                        ? CustomTextField(
                            'organizationType',
                            label: 'Type of Organization',
                            validationMessages: {
                              'required': (error) =>
                                  'Type of organization is required',
                            },
                          )
                        : const SizedBox.shrink(),
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
                            'Bio must be at least 50 characters long and must not exceed to 250 characters.',
                        'maxLength': (error) =>
                            'Bio must be at least 50 characters long and must not exceed to 250 characters.',
                      },
                    ),
                    (widget.args.user.getUserRole == UserRole.organization)
                        ? Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Representatives',
                                  textAlign: TextAlign.center,
                                  style: AppStyle.kStyleBold.copyWith(
                                    fontSize: 18.sp,
                                    color: AppStyle.kPrimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              CustomTextField(
                                'organizationRepName1',
                                label: 'Representative\'s Name 1',
                                validationMessages: {
                                  'required': (error) => 'Name is required',
                                  'pattern': (error) =>
                                      'This field does not accept numbers and symbols.',
                                },
                              ),
                              CustomTextField(
                                'organizationRepLocation1',
                                label: 'Representative\'s Address 1',
                                validationMessages: {
                                  'required': (error) => 'Address is required',
                                },
                              ),
                              CustomTextField(
                                'organizationRepMobileNumber1',
                                label: 'Representative\'s Mobile Number 1',
                                keyboardType: TextInputType.phone,
                                prefixWidget: const Text('+63'),
                                validationMessages: {
                                  'required': (error) =>
                                      'Mobile number is required',
                                  'pattern': (error) =>
                                      'Please enter a valid mobile number',
                                  'maxLength': (error) =>
                                      'Please enter a valid mobile number',
                                },
                              ),
                              CustomTextField(
                                'organizationRepName2',
                                label: 'Representative\'s Name 2',
                                validationMessages: {
                                  'required': (error) => 'Name is required',
                                  'pattern': (error) =>
                                      'This field does not accept numbers and symbols.',
                                },
                              ),
                              CustomTextField(
                                'organizationRepLocation2',
                                label: 'Representative\'s Address 2',
                                validationMessages: {
                                  'required': (error) => 'Address is required',
                                },
                              ),
                              CustomTextField(
                                'organizationRepMobileNumber2',
                                label: 'Representative\'s Mobile Number 2',
                                keyboardType: TextInputType.phone,
                                prefixWidget: const Text('+63'),
                                validationMessages: {
                                  'required': (error) =>
                                      'Mobile number is required',
                                  'pattern': (error) =>
                                      'Please enter a valid mobile number',
                                  'maxLength': (error) =>
                                      'Please enter a valid mobile number',
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool get ifHasRep2 {
    final org2RepName = _editProfileForm!.control(
      'organizationRepName2',
    );

    final org2RepNumber = _editProfileForm!.control(
      'organizationRepMobileNumber2',
    );

    final org2RepLocation = _editProfileForm!.control(
      'organizationRepLocation2',
    );

    return (org2RepName.value != null && org2RepName.value != '') ||
        (org2RepNumber.value != null && org2RepNumber.value != '') ||
        (org2RepLocation.value != null && org2RepLocation.value != '');
  }
}

class EditProfileScreenArgs {
  final UserDto user;
  EditProfileScreenArgs({required this.user});
}
