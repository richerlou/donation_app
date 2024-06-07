import 'package:donation_management/core/data/constants/barangay_constants.dart';
import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_dropdown.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/authentication/registration/presentation/blocs/registration_cubit/registration_cubit.dart';
import 'package:donation_management/core/data/enums/user_role.dart';
import 'package:donation_management/feature/home/presentation/screens/home_screen.dart';
import 'package:donation_management/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    super.key,
    required this.args,
  });

  final RegistrationScreenArgs args;

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FormGroup? _registrationForm;

  bool? _obscuredTextPass;
  bool? _obscuredTextConfirmPass;
  String? _emailAddressErrorMessage;

  void _showPassword() {
    setState(() {
      _obscuredTextPass = !_obscuredTextPass!;
    });
  }

  void _showConfirmPassword() {
    setState(() {
      _obscuredTextConfirmPass = !_obscuredTextConfirmPass!;
    });
  }

  Future<void> _onSignUpPressed(BuildContext ctx) async {
    final org2RepName = _registrationForm!.control('organizationRepName2');
    final org2RepNumber = _registrationForm!.control(
      'organizationRepMobileNumber2',
    );
    final org2RepLocation = _registrationForm!.control(
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

    if (_registrationForm!.invalid) {
      _registrationForm!.markAllAsTouched();
    } else {
      await ctx
          .read<RegistrationCubit>()
          .createAccount(widget.args.userRole, _registrationForm!);
    }
  }

  @override
  void initState() {
    _registrationForm = FormGroup({
      'firstName': FormControl<String>(validators: [
        Validators.pattern('^[a-zA-Z][a-zA-z\\s]+\$'),
        Validators.required,
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
      'emailAddress': FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      'mobileNumber': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern('^(9)\\d{9}'),
          Validators.maxLength(10),
        ],
      ),
      'bio': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(50),
        Validators.maxLength(250),
      ]),
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
      'password': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(6),
      ]),
      'confirmPassword': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(6),
      ]),
    }, validators: [
      Validators.mustMatch('password', 'confirmPassword'),
    ]);

    if (widget.args.userRole == UserRole.organization) {
      _registrationForm!.control('firstName').clearValidators();
      _registrationForm!.control('firstName').updateValueAndValidity();

      _registrationForm!.control('lastName').clearValidators();
      _registrationForm!.control('lastName').updateValueAndValidity();

      _registrationForm!.control('barangay').clearValidators();
      _registrationForm!.control('barangay').updateValueAndValidity();
    } else {
      _registrationForm!.control('organizationName').clearValidators();
      _registrationForm!.control('organizationName').updateValueAndValidity();

      _registrationForm!.control('organizationType').clearValidators();
      _registrationForm!.control('organizationType').updateValueAndValidity();

      _registrationForm!.control('location').clearValidators();
      _registrationForm!.control('location').updateValueAndValidity();

      _registrationForm!.control('website').clearValidators();
      _registrationForm!.control('website').updateValueAndValidity();

      _registrationForm!.control('organizationRepName1').clearValidators();
      _registrationForm!
          .control('organizationRepName1')
          .updateValueAndValidity();

      _registrationForm!
          .control('organizationRepMobileNumber1')
          .clearValidators();
      _registrationForm!
          .control('organizationRepMobileNumber1')
          .updateValueAndValidity();

      _registrationForm!.control('organizationRepLocation1').clearValidators();
      _registrationForm!
          .control('organizationRepLocation1')
          .updateValueAndValidity();

      _registrationForm!.control('organizationRepName2').clearValidators();
      _registrationForm!
          .control('organizationRepName2')
          .updateValueAndValidity();

      _registrationForm!
          .control('organizationRepMobileNumber2')
          .clearValidators();
      _registrationForm!
          .control('organizationRepMobileNumber2')
          .updateValueAndValidity();

      _registrationForm!.control('organizationRepLocation2').clearValidators();
      _registrationForm!
          .control('organizationRepLocation2')
          .updateValueAndValidity();
    }

    _obscuredTextPass = true;
    _obscuredTextConfirmPass = true;
    _emailAddressErrorMessage = 'none';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.kColorWhite,
      appBar: AppBar(
        elevation: 0,
        iconTheme: AppStyle.kIconThemeData,
        backgroundColor: AppStyle.kColorWhite,
      ),
      bottomNavigationBar: CustomButton(
        buttonInsetPadding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 25.w,
        ),
        onPressed: () async => await _onSignUpPressed(context),
        buttonTitle: 'Sign up',
        titleTextStyle: AppStyle.kStyleRegular.copyWith(
          fontSize: 17.sp,
          color: AppStyle.kColorWhite,
        ),
      ),
      body: BlocListener<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationLoading) {
            CustomLoader.of(context).show();
          }

          if (state is RegistrationSuccess) {
            SnackbarUtils.removeCurrentSnackbar(context: context);

            CustomLoader.of(context).managePop(true);
            CustomLoader.of(context).hide();

            if (state.isOrgRegistration) {
              Navigator.pop(context);
              Navigator.pop(context);

              SnackbarUtils.showSnackbar(
                context: context,
                title:
                    'Registration success! Please wait for our admin to approve your account.',
              );
            } else {
              context.read<AccountCubit>().loadUser();

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.homeScreen,
                (route) => false,
                arguments: HomeScreenArgs(
                  user: state.user,
                  userRole: widget.args.userRole,
                ),
              );
            }
          }

          if (state is RegistrationError) {
            SnackbarUtils.removeCurrentSnackbar(context: context);

            CustomLoader.of(context).managePop(true);
            CustomLoader.of(context).hide();

            if (state.hasEmailError!) {
              _emailAddressErrorMessage = state.errorMessage;
              _registrationForm!.control('emailAddress').setErrors(
                {'emailExists': true},
              );
            }

            SnackbarUtils.showSnackbar(
              context: context,
              title: state.errorMessage!,
            );
          }
        },
        child: ReactiveForm(
          formGroup: _registrationForm!,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'brand_logo',
                      child: Assets.images.lgBrand.image(height: 90.h),
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      'Let\'s get started!',
                      textAlign: TextAlign.center,
                      style: AppStyle.kStyleHeader,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Create an account and start help each others lives.',
                      textAlign: TextAlign.center,
                      style: AppStyle.kStyleRegular,
                    ),
                    SizedBox(height: 25.h),
                    Column(
                      children: [
                        (widget.args.userRole == UserRole.individual)
                            ? CustomTextField(
                                'firstName',
                                label: 'First Name',
                                validationMessages: {
                                  'required': (error) =>
                                      'First name is required',
                                  'pattern': (error) =>
                                      'This field does not accept numbers and symbols.',
                                },
                              )
                            : const SizedBox.shrink(),
                        (widget.args.userRole == UserRole.individual)
                            ? CustomTextField(
                                'middleName',
                                label: 'Middle Name (Optional)',
                                validationMessages: {
                                  'pattern': (error) =>
                                      'This field does not accept numbers and symbols.',
                                },
                              )
                            : const SizedBox.shrink(),
                        (widget.args.userRole == UserRole.individual)
                            ? CustomTextField(
                                'lastName',
                                label: 'Last Name',
                                validationMessages: {
                                  'required': (error) =>
                                      'Last name is required',
                                  'pattern': (error) =>
                                      'This field does not accept numbers and symbols.',
                                },
                              )
                            : const SizedBox.shrink(),
                        (widget.args.userRole == UserRole.individual)
                            ? CustomDropdown<String>(
                                'barangay',
                                items: BarangayConstrants.barangayListItems(),
                                label: 'Address (Barangay)',
                                validationMessages: {
                                  'required': (error) => 'Address is required',
                                },
                              )
                            : const SizedBox.shrink(),
                        (widget.args.userRole == UserRole.organization)
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
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          validationMessages: {
                            'required': (error) => 'Email address is required',
                            'email': (error) =>
                                'Please enter a valid email address',
                            'emailExists': (error) =>
                                _emailAddressErrorMessage!,
                          },
                        ),
                        (widget.args.userRole == UserRole.organization)
                            ? CustomTextField(
                                'location',
                                label: 'Address',
                                validationMessages: {
                                  'required': (error) => 'Address is required',
                                },
                              )
                            : const SizedBox.shrink(),
                        (widget.args.userRole == UserRole.organization)
                            ? CustomTextField(
                                'organizationType',
                                label: 'Type of Organization',
                                validationMessages: {
                                  'required': (error) =>
                                      'Type of organization is required',
                                },
                              )
                            : const SizedBox.shrink(),
                        (widget.args.userRole == UserRole.organization)
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
                          label:
                              'Put a short description about ${(widget.args.userRole == UserRole.organization) ? 'your organization' : 'yourself'}',
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
                        CustomTextField(
                          'password',
                          label: 'Password',
                          obscureText: _obscuredTextPass!,
                          suffixIcon: IconButton(
                            onPressed: _showPassword,
                            icon: Icon(
                              (_obscuredTextPass!)
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppStyle.kPrimaryColor,
                            ),
                          ),
                          validationMessages: {
                            'required': (error) => 'Password is required',
                            'minLength': (error) =>
                                'Password must be at least six characters long.',
                          },
                        ),
                        CustomTextField(
                          'confirmPassword',
                          formInsetPadding: EdgeInsets.only(bottom: 25.h),
                          label: 'Confirm Password',
                          obscureText: _obscuredTextConfirmPass!,
                          suffixIcon: IconButton(
                            onPressed: _showConfirmPassword,
                            icon: Icon(
                              (_obscuredTextConfirmPass!)
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppStyle.kPrimaryColor,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          validationMessages: {
                            'required': (error) => 'Password doesn\'t match',
                            'mustMatch': (error) => 'Password doesn\'t match',
                            'minLength': (error) =>
                                'Password must be at least six characters long.',
                          },
                        ),
                        (widget.args.userRole == UserRole.organization)
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
                                      'required': (error) =>
                                          'Address is required',
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
                                      'required': (error) =>
                                          'Address is required',
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get ifHasRep2 {
    final org2RepName = _registrationForm!.control('organizationRepName2');

    final org2RepNumber =
        _registrationForm!.control('organizationRepMobileNumber2');

    final org2RepLocation =
        _registrationForm!.control('organizationRepLocation2');

    return (org2RepName.value != null && org2RepName.value != '') ||
        (org2RepNumber.value != null && org2RepNumber.value != '') ||
        (org2RepLocation.value != null && org2RepLocation.value != '');
  }
}

class RegistrationScreenArgs {
  final UserRole userRole;

  RegistrationScreenArgs({
    this.userRole = UserRole.individual,
  });
}
