import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
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
      'firstName': FormControl<String>(validators: [Validators.required]),
      'middleName': FormControl<String>(),
      'lastName': FormControl<String>(validators: [Validators.required]),
      'organizationName':
          FormControl<String>(validators: [Validators.required]),
      'emailAddress': FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      'mobileNumber': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^(9)\d{9}'),
          Validators.maxLength(10),
        ],
      ),
      'bio': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(100),
        Validators.maxLength(250),
      ]),
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
    } else {
      _registrationForm!.control('organizationName').clearValidators();
      _registrationForm!.control('organizationName').updateValueAndValidity();
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
                        if (widget.args.userRole == UserRole.individual)
                          CustomTextField(
                            'firstName',
                            label: 'First Name',
                            validationMessages: {
                              'required': (error) => 'First name is required',
                            },
                          ),
                        if (widget.args.userRole == UserRole.individual)
                          const CustomTextField(
                            'middleName',
                            label: 'Middle Name (Optional)',
                          ),
                        if (widget.args.userRole == UserRole.individual)
                          CustomTextField(
                            'lastName',
                            label: 'Last Name',
                            validationMessages: {
                              'required': (error) => 'Last name is required',
                            },
                          ),
                        if (widget.args.userRole == UserRole.organization)
                          CustomTextField(
                            'organizationName',
                            label: 'Organization Name',
                            validationMessages: {
                              'required': (error) =>
                                  'Organization name is required',
                            },
                          ),
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
                                'Bio must be at least 100 characters long and must not exceed to 250 characters.',
                            'maxLength': (error) =>
                                'Bio must be at least 100 characters long and must not exceed to 250 characters.',
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationScreenArgs {
  final UserRole userRole;

  RegistrationScreenArgs({
    this.userRole = UserRole.individual,
  });
}
