import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class StringUtils {
  StringUtils._();

  /// Singleton to ensure only one class instance is created
  static final StringUtils _instance = StringUtils._();
  factory StringUtils() => _instance;

  static const Uuid _uuid = Uuid();

  static String getFormattedDate({
    DateTime? dateTime,
    String dateFormat = 'MMMM dd, yyyy',
  }) =>
      DateFormat(dateFormat).format(dateTime ?? DateTime.now());

  static String generateId() => _uuid.v4();

  static String parseAmount(num? value) =>
      NumberFormat("#,##0.00", "en_US").format(value).toString();

  static const Pattern decimalNumberPattern = r'^\d{0,9}(?:[.,]\d{1,3})?$';
}
