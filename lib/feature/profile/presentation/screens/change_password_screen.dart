import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/profile/presentation/blocs/password_cubit/password_cubit.dart';
import 'package:donation_management/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FormGroup _changePasswordForm = FormGroup({
    'oldPassword': FormControl<String>(validators: [Validators.required]),
    'newPassword': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(6),
    ]),
    'confirmNewPassword': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(6),
    ]),
  }, validators: [
    Validators.mustMatch('newPassword', 'confirmNewPassword'),
  ]);

  bool? _obscuredTextOldPass;
  bool? _obscuredTextNewPass;
  bool? _obscuredTextConfirmNewPass;
  String? _oldPasswordErrorMessage;

  void _showOldPassword() {
    setState(() {
      _obscuredTextOldPass = !_obscuredTextOldPass!;
    });
  }

  void _showNewPassword() {
    setState(() {
      _obscuredTextNewPass = !_obscuredTextNewPass!;
    });
  }

  void _showConfirmNewPassword() {
    setState(() {
      _obscuredTextConfirmNewPass = !_obscuredTextConfirmNewPass!;
    });
  }

  Future<void> _onChangePasswordButtonPressed(BuildContext ctx) async {
    if (_changePasswordForm.invalid) {
      _changePasswordForm.markAllAsTouched();
    } else {
      DialogUtils.showConfirmationDialog(
        context,
        title: 'Confirmation',
        content: 'Are you sure you want to change you password?',
        onPrimaryButtonPressed: () async {
          Navigator.pop(context);
          await ctx.read<PasswordCubit>().changePassword(_changePasswordForm);
        },
      );
    }
  }

  @override
  void initState() {
    _obscuredTextOldPass = true;
    _obscuredTextNewPass = true;
    _obscuredTextConfirmNewPass = true;
    _oldPasswordErrorMessage = 'None';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          size: 28.sp,
          color: Colors.white,
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            fontSize: 22.sp,
            fontFamily: FontFamily.dMSans,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: CustomButton(
        buttonInsetPadding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 25.w,
        ),
        onPressed: () => _onChangePasswordButtonPressed(context),
        buttonTitle: 'Change password',
      ),
      body: BlocListener<PasswordCubit, PasswordState>(
        listener: (context, state) {
          SnackbarUtils.removeCurrentSnackbar(context: context);

          if (state is ChangePasswordLoading) {
            CustomLoader.of(context).show();
          }

          if (state is ChangePasswordSuccess) {
            CustomLoader.of(context).managePop(true);
            CustomLoader.of(context).hide();
            Navigator.pop(context);

            SnackbarUtils.showSnackbar(
              context: context,
              title: 'Password changed successfully!',
            );
          }

          if (state is ChangePasswordError) {
            CustomLoader.of(context).managePop(true);
            CustomLoader.of(context).hide();

            if (state.hasCurrentPasswordError!) {
              _oldPasswordErrorMessage = state.errorMessage;
              _changePasswordForm.control('oldPassword').setErrors(
                {'oldPasswordInvalid': true},
              );
            } else {
              SnackbarUtils.showSnackbar(
                context: context,
                title: state.errorMessage!,
              );
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 33.h),
            child: ReactiveForm(
              formGroup: _changePasswordForm,
              child: Column(
                children: [
                  CustomTextField(
                    'oldPassword',
                    label: 'Current Password',
                    obscureText: _obscuredTextOldPass!,
                    suffixIcon: IconButton(
                      onPressed: _showOldPassword,
                      icon: Icon(
                        (_obscuredTextOldPass!)
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    validationMessages: {
                      'required': (error) => 'Current password is required',
                      'oldPasswordInvalid': (error) =>
                          _oldPasswordErrorMessage!,
                    },
                  ),
                  CustomTextField(
                    'newPassword',
                    label: 'New Password',
                    obscureText: _obscuredTextNewPass!,
                    suffixIcon: IconButton(
                      onPressed: _showNewPassword,
                      icon: Icon(
                        (_obscuredTextNewPass!)
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    validationMessages: {
                      'required': (error) => 'Password is required',
                      'minLength': (error) =>
                          'Password must be at least six characters long.',
                    },
                  ),
                  CustomTextField(
                    'confirmNewPassword',
                    formInsetPadding: EdgeInsets.only(bottom: 25.h),
                    label: 'Confirm New Password',
                    obscureText: _obscuredTextConfirmNewPass!,
                    suffixIcon: IconButton(
                      onPressed: _showConfirmNewPassword,
                      icon: Icon(
                        (_obscuredTextConfirmNewPass!)
                            ? Icons.visibility
                            : Icons.visibility_off,
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
            ),
          ),
        ),
      ),
    );
  }
}
