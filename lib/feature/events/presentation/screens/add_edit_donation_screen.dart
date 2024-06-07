import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/events/presentation/blocs/donation_cubit/donation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditDonationScreen extends StatefulWidget {
  const AddEditDonationScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  final AddEditDonationScreenArgs args;

  @override
  State<AddEditDonationScreen> createState() => _AddEditDonationScreenState();
}

class _AddEditDonationScreenState extends State<AddEditDonationScreen> {
  FormGroup? _donationForm;

  Future<void> _onSubmitPressed() async {
    if (_donationForm!.invalid) {
      _donationForm!.markAllAsTouched();
    } else {
      DialogUtils.showConfirmationDialog(
        context,
        title: 'Confirmation',
        content:
            'Are you sure you want to add this ${(widget.args.forMaterial) ? 'material' : 'service'}?',
        onPrimaryButtonPressed: () async {
          Navigator.pop(context);

          await context.read<DonationCubit>().addDonation(
              _donationForm!, widget.args.eventId, widget.args.forMaterial);
        },
      );
    }
  }

  void _popLoader(String message, {bool closeScreen = false}) {
    SnackbarUtils.removeCurrentSnackbar(context: context);

    CustomLoader.of(context).managePop(true);
    CustomLoader.of(context).hide();

    SnackbarUtils.showSnackbar(
      context: context,
      title: message,
    );

    if (closeScreen) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _donationForm = FormGroup({
      'donationName': FormControl<String>(validators: [
        Validators.required,
      ]),
      'donationTargetQuantity': FormControl<int>(validators: [
        Validators.required,
        Validators.number(
            allowNegatives: true, allowNull: false, allowedDecimals: 0),
      ]),
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: (widget.args.forMaterial) ? 'Add Materials' : 'Add Services',
      ),
      bottomNavigationBar: CustomButton(
        buttonInsetPadding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 23.w,
        ),
        onPressed: () async => await _onSubmitPressed(),
        buttonTitle:
            'Add ${(widget.args.forMaterial) ? 'material' : 'service'}',
      ),
      body: BlocListener<DonationCubit, DonationState>(
        listener: (context, state) {
          if (state is DonationLoading) {
            CustomLoader.of(context).show();
          }

          if (state is DonationSuccess) {
            _popLoader(
              '${(widget.args.forMaterial) ? 'Material' : 'Service'} added successfully!',
              closeScreen: true,
            );
          }

          if (state is DonationError) {
            _popLoader(state.errorMessage!);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 23.w, right: 23.w, top: 25.h),
            child: ReactiveForm(
              formGroup: _donationForm!,
              child: Column(
                children: [
                  CustomTextField(
                    'donationName',
                    label: 'Donation Item',
                    validationMessages: {
                      'required': (error) => 'Donation item is required',
                    },
                  ),
                  CustomTextField(
                    'donationTargetQuantity',
                    label: 'Target Quantity',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validationMessages: {
                      'required': (error) => 'Target quantity is required',
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

class AddEditDonationScreenArgs {
  final bool forMaterial;
  final String eventId;

  AddEditDonationScreenArgs(this.eventId, {this.forMaterial = false});
}
