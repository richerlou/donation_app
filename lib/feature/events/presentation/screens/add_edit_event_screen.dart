import 'package:donation_management/core/data/services/image_picker_service.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/utils/dialog_utils.dart';
import 'package:donation_management/core/presentation/utils/snackbar_utils.dart';
import 'package:donation_management/core/presentation/widgets/custom_app_bar.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:donation_management/core/presentation/widgets/custom_date_picker_textfield.dart';
import 'package:donation_management/core/presentation/widgets/custom_dropdown.dart';
import 'package:donation_management/core/presentation/widgets/custom_image_picker_container.dart';
import 'package:donation_management/core/presentation/widgets/custom_loader.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:donation_management/feature/events/data/enums/event_type.dart';
import 'package:donation_management/feature/events/data/models/event_dto.dart';
import 'package:donation_management/feature/events/presentation/blocs/event_cubit/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditEventScreen extends StatefulWidget {
  const AddEditEventScreen({
    super.key,
    required this.args,
  });

  final AddEditEventScreenArgs args;

  @override
  _AddEditEventScreenState createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  ImagePickerService? _imagePickerService;
  FormGroup? _eventForm;
  XFile? _image;
  bool? _isFromMedia;
  bool? _hasMediaError;

  Future<void> _onSubmit(BuildContext ctx) async {
    if (_eventForm!.invalid) {
      if (_image == null && !widget.args.isEdit) {
        setState(() {
          _hasMediaError = true;
        });
      }
      _eventForm!.markAllAsTouched();
    } else {
      if (_image == null && !widget.args.isEdit) {
        setState(() {
          _hasMediaError = true;
        });
      } else {
        DialogUtils.showConfirmationDialog(
          context,
          title: 'Confirmation',
          content:
              'Are you sure you want to ${(widget.args.isEdit) ? 'update' : 'add'} this event?',
          onPrimaryButtonPressed: () async {
            Navigator.pop(context);
            if (widget.args.isEdit) {
              await ctx
                  .read<EventCubit>()
                  .updateEvent(_eventForm!, _image, widget.args.event!);
            } else {
              await ctx.read<EventCubit>().addEvent(_eventForm!, _image!);
            }
          },
        );
      }
    }
  }

  void _setImage(XFile? imagePath) {
    setState(() {
      _image = imagePath;
      if (_image != null) {
        _isFromMedia = true;
        _hasMediaError = false;
      } else {
        _isFromMedia = false;
        _image = null;
      }
    });
    Navigator.pop(context);
  }

  void _onImageContainerPressed() {
    DialogUtils.showBottomMediaSheet(
      context,
      header: 'Select Media',
      onCameraPressed: () async {
        XFile? _imagePath = await _imagePickerService!.pickImage(Media.camera);
        _setImage(_imagePath);
      },
      onGalleryPressed: () async {
        XFile? _imagePath = await _imagePickerService!.pickImage(Media.gallery);
        _setImage(_imagePath);
      },
    );
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
    _eventForm = FormGroup({
      'eventType': FormControl<int>(validators: [Validators.required]),
      'eventTitle': FormControl<String>(validators: [Validators.required]),
      'eventDescription': FormControl<String>(validators: [
        Validators.required,
      ]),
      'eventDate': FormControl<DateTime>(validators: [
        Validators.required,
      ]),
    });
    _imagePickerService = ImagePickerService();
    _isFromMedia = false;
    _hasMediaError = false;

    if (widget.args.isEdit) {
      context
          .read<EventCubit>()
          .populateEventData(widget.args.event!, _eventForm!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: (widget.args.isEdit) ? 'Update Event' : 'Add Event',
      ),
      bottomNavigationBar: CustomButton(
        buttonInsetPadding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 25.w,
        ),
        onPressed: () async => await _onSubmit(context),
        buttonTitle: (widget.args.isEdit) ? 'Update event' : 'Add event',
        titleTextStyle: AppStyle.kStyleRegular.copyWith(
          fontSize: 17.sp,
          color: AppStyle.kColorWhite,
        ),
      ),
      body: BlocConsumer<EventCubit, EventState>(
        listener: (context, state) {
          if (state is EventLoading) {
            if (!state.preventBuild) {
              CustomLoader.of(context).show();
            }
          }

          if (state is EventSuccess) {
            _popLoader(
              'Event ${(widget.args.isEdit) ? 'updated' : 'posted'} successfully!',
              closeScreen: true,
            );
          }

          if (state is EventError) {
            _popLoader(state.errorMessage!);
          }
        },
        builder: (context, state) {
          return ReactiveForm(
            formGroup: _eventForm!,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                child: Column(
                  children: [
                    CustomDropdown<int>(
                      'eventType',
                      items: [
                        DropdownMenuItem(
                          value: EventType.donationDrive.code(),
                          child: Text(EventType.donationDrive.text()),
                        ),
                        DropdownMenuItem(
                          value: EventType.volunteer.code(),
                          child: Text(EventType.volunteer.text()),
                        ),
                      ],
                      label: 'Event Type',
                      validationMessages: {
                        'required': (error) => 'Event type is required',
                      },
                    ),
                    CustomDatePickerTextField(
                      formControlName: 'eventDate',
                      label: 'Event Date',
                      validationMessages: {
                        'required': (error) => 'Event date is required',
                      },
                    ),
                    CustomTextField(
                      'eventTitle',
                      label: 'Event Title',
                      validationMessages: {
                        'required': (error) => 'Event title is required',
                      },
                    ),
                    CustomTextField(
                      'eventDescription',
                      label: 'Event Description',
                      enableLabel: false,
                      maxLines: 10,
                      validationMessages: {
                        'required': (error) => 'Event description is required',
                      },
                    ),
                    CustomImagePickerContainer(
                      fromMedia: _isFromMedia!,
                      hasMediaError:
                          (widget.args.isEdit) ? false : _hasMediaError!,
                      errorText: 'Event photo is required',
                      mediaAsset: (_image != null) ? _image! : null,
                      networkAsset:
                          (state is EventPhotoFetched && widget.args.isEdit)
                              ? state.eventPhoto
                              : null,
                      onPressed: _onImageContainerPressed,
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

class AddEditEventScreenArgs {
  final bool isEdit;
  final EventDto? event;

  AddEditEventScreenArgs({
    this.isEdit = false,
    this.event,
  });
}
