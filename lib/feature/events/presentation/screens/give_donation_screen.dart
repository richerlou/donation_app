import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_dropdown.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/events/data/enums/donation_type.dart';
import 'package:donation_management/feature/events/data/models/donation_dto.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/donation_cubit/donation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

class GiveDonationScreen extends StatefulWidget {
  const GiveDonationScreen({
    super.key,
    required this.args,
  });

  final GiveDonationScreenArgs args;

  @override
  State<GiveDonationScreen> createState() => _GiveDonationScreenState();
}

class _GiveDonationScreenState extends State<GiveDonationScreen> {
  FormGroup? _donationOfferForm;
  List<DropdownMenuItem<DonationDto>> dropdownItems =
      <DropdownMenuItem<DonationDto>>[];

  Future<void> donateItem() async {
    if (_donationOfferForm!.invalid) {
      _donationOfferForm!.markAllAsTouched();
    } else {
      DialogUtils.showConfirmationDialog(
        context,
        title: 'Confirmation',
        content: 'Are you sure you want to donate?',
        onPrimaryButtonPressed: () async {
          Navigator.pop(context);

          await context.read<DonationCubit>().addDonationOffer(
              event: widget.args.event, form: _donationOfferForm!);
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

  void _showDonationOfferSuccess() {
    CustomLoader.of(context).managePop(true);
    CustomLoader.of(context).hide();

    Navigator.pop(context);

    DialogUtils.showDefaultDialog(
      context,
      title: 'Almost there!',
      content: const Text(
        'Thank you for your kindness! Please go to the exact location of the organization\'s facility to confirm your donation. Thank you!',
      ),
      primaryButtonTitle: 'Close',
    );
  }

  @override
  void initState() {
    _donationOfferForm = FormGroup({
      'item': FormControl<DonationDto>(validators: [
        Validators.required,
      ]),
      'quantity': FormControl<int>(validators: [
        Validators.required,
        Validators.number(
            allowNegatives: true, allowNull: false, allowedDecimals: 0),
      ]),
    });

    context.read<DonationCubit>().getDonations(
          widget.args.event.eventId!,
          widget.args.donationType,
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
            'Add ${(widget.args.donationType == DonationType.service) ? 'Service' : 'Material'} Donation',
      ),
      bottomNavigationBar: CustomButton(
        buttonInsetPadding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 25.w,
        ),
        onPressed: donateItem,
        buttonTitle: 'Add Donation',
      ),
      body: BlocConsumer<DonationCubit, DonationState>(
        listener: (context, state) {
          if (state is DonationLoading) {
            CustomLoader.of(context).show();
          }

          if (state is DonationSuccess) {
            if (state.forDonationOffer) {
              _showDonationOfferSuccess();
            } else {
              dropdownItems.clear();
              dropdownItems = state.donations!;
            }
          }

          if (state is DonationError) {
            _popLoader(state.errorMessage!);
          }
        },
        builder: (context, state) {
          return ReactiveForm(
            formGroup: _donationOfferForm!,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 23.h),
                child: Column(
                  children: [
                    CustomDropdown<DonationDto>(
                      'item',
                      items: dropdownItems,
                      label: 'Select item to donate',
                      validationMessages: {
                        'required': (error) => 'Item is required',
                      },
                    ),
                    CustomTextField(
                      'quantity',
                      label: 'Quantity',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validationMessages: {
                        'required': (error) => 'Quantity is required',
                        'invalidQuantity': (error) =>
                            'You\'ve entered invalid donation quantity',
                      },
                    )
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

class GiveDonationScreenArgs {
  final DonationType donationType;
  final EventDto event;

  GiveDonationScreenArgs({
    this.donationType = DonationType.service,
    required this.event,
  });
}
