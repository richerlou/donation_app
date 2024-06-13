import 'package:reactive_forms/reactive_forms.dart';

class PriorEventDateValidator extends Validator<dynamic> {
  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final DateTime priorEventDate = DateTime.now().add(const Duration(days: 1));
    if (control.value != null && control.value is DateTime) {
      DateTime dateSelected = control.value as DateTime;
      return dateSelected.isBefore(priorEventDate)
          ? {'priorEventDate': true}
          : null;
    }
    return null;
  }
}