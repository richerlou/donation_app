mixin FormMixin {
  String? textFieldChecker(dynamic data) {
    if (data == '' || data == null) {
      return null;
    }

    return data;
  }
}
