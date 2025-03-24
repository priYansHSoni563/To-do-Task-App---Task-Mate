import 'package:flutter/material.dart';

// ignore: camel_case_extensions
extension intExtension on int? {
  int validate({int value = 0}) {
    return this ?? value;
  }
  Widget get h => SizedBox(
    height: this?.toDouble(),
  );
  Widget get w => SizedBox(
    width: this?.toDouble(),
  );
}
