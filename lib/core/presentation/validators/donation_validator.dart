import 'package:reactive_forms/reactive_forms.dart';

class DonationcValidator {
  /// Validate's input if the max quantity for services ``100`` exceeds.
  static Map<String, dynamic>? servicesMaxItems(
    AbstractControl<dynamic> control,
  ) {
    return (control.isNotNull && control.value is int && control.value > 100)
        ? {'servicesMaxItems': true}
        : null;
  }

  /// Validate's input if the max quantity for materials ``1000`` exceeds.
  static Map<String, dynamic>? materialsMaxItems(
    AbstractControl<dynamic> control,
  ) {
    return (control.isNotNull && control.value is int && control.value > 1000)
        ? {'materialsMaxItems': true}
        : null;
  }

  // Validate's if the input of quantity not exceeds to the
  //max quantity provided.
  static ValidatorFunction mustNotExceed(
    String controlName,
    String maxControlName,
  ) {
    return (AbstractControl<dynamic> control) {
      final form = control as FormGroup;

      final AbstractControl formControl = form.control(controlName);
      final AbstractControl maxFormControl = form.control(maxControlName);

      if (formControl.isNotNull && maxFormControl.isNotNull) {
        if (formControl.value > maxFormControl.value) {
          formControl.setErrors({'mustNotExceed': true});

          // Force messages to show up as soon as possible
          formControl.markAsTouched();
        } else {
          formControl.removeError('mustNotExceed');
        }
      }

      return null;
    };
  }
}
