import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class FieldValueConverter implements JsonConverter<FieldValue?, List<String>?> {
  const FieldValueConverter();

  @override
  FieldValue? fromJson(List<String>? data) {
    return FieldValue.arrayUnion(data!);
  }

  @override
  List<String>? toJson(FieldValue? object) {
    throw UnimplementedError();
  }
}
