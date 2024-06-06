import 'package:donation_management/core/presentation/blocs/account_cubit/account_cubit.dart';
import 'package:donation_management/core/presentation/utils/app_router.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/authentication/login/presentation/blocs/login_cubit/login_cubit.dart';
import 'package:donation_management/feature/home/presentation/screens/home_screen.dart';
import 'package:donation_management/generated/assets.gen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FormGroup? _loginForm;

  bool? _obscuredText;

  Future<void> _onLoginPressed(BuildContext ctx) async {
    if (_loginForm!.invalid) {
      _loginForm!.markAllAsTouched();
    } else {
      String email = _loginForm!.control('emailAddress').value;
      String password = _loginForm!.control('password').value;

      await ctx
          .read<LoginCubit>()
          .loginAccount(emailAddress: email, password: password);
    }
  }

  void _showPassword() {
    setState(() {
      _obscuredText = !_obscuredText!;
    });
  }

  Future<void> _onSuccess(LoginSuccess state) async {
    CustomLoader.of(context).managePop(true);
    CustomLoader.of(context).hide();

    await context.read<AccountCubit>().loadUser();

    Navigator.pushReplacementNamed(
      context,
      AppRouter.homeScreen,
      arguments: HomeScreenArgs(
        user: state.user,
        userRole: state.user.getUserRole,
      ),
    );
  }

  void _onError(LoginError state) {
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
    _loginForm = fb.group({
      'emailAddress': [Validators.required, Validators.email],
      'password': Validators.required,
    });

    _obscuredText = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.kColorWhite,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginLoading) {
            CustomLoader.of(context).show();
          }

          if (state is LoginSuccess) {
            await _onSuccess(state);
          }

          if (state is LoginError) {
            _onError(state);
          }
        },
        child: ReactiveForm(
          formGroup: _loginForm!,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 47.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'brand_logo',
                      child: Assets.images.lgBrand.image(height: 90.h),
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      'Welcome to Davao Charitably',
                      textAlign: TextAlign.center,
                      style: AppStyle.kStyleHeader,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: AppStyle.kStyleRegular,
                    ),
                    SizedBox(height: 25.h),
                    Column(
                      children: [
                        CustomTextField(
                          'emailAddress',
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          validationMessages: {
                            'required': (error) => 'Email address is required',
                            'email': (error) =>
                                'Please enter a valid email address',
                          },
                        ),
                        CustomTextField(
                          'password',
                          formInsetPadding: EdgeInsets.zero,
                          label: 'Password',
                          obscureText: _obscuredText!,
                          suffixIcon: IconButton(
                            onPressed: _showPassword,
                            icon: Icon(
                              (_obscuredText!)
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppStyle.kPrimaryColor,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          validationMessages: {
                            'required': (error) => 'Password is required',
                          },
                        ),
                        SizedBox(height: 53.h),
                        CustomButton(
                          onPressed: () => _onLoginPressed(context),
                          buttonTitle: 'Sign in',
                        ),
                        SizedBox(height: 18.h),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppStyle.kStyleRegular,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Don\'t have an account yet?',
                              ),
                              TextSpan(
                                text: ' Sign up',
                                style: AppStyle.kStyleBold.copyWith(
                                  color: AppStyle.kPrimaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.userCheckerScreen,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
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
}
