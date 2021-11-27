import 'package:get/get.dart';

// // matching various patterns for kinds of data

class Validator {
  String? email(String value) {
    String pattern = r'^[a-zA-Zа-яА-ЯЁё0-9.]+@[a-zA-Zа-яА-ЯЁё0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return '';
    } else {
      return null;
    }
  }

  String? password(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value?.trim() ?? "")) {
      return "Password must be at least 6 characters";
    } else {
      return null;
    }
  }

  String? name(String value) {
    String pattern =
        r"^[a-zA-Zа-яА-ЯЁё0-9 -_]+(([. _ -][a-zA-Zа-яА-ЯЁё0-9 -_])?[a-zA-Zа-яА-ЯЁё0-9 -_]*)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return '';
    } else {
      return null;
    }
  }

  String? number(String value) {
    String pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return '';
    } else {
      return null;
    }
  }

  String? amount(String value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return '';
    } else {
      return null;
    }
  }

  String? notEmpty(String value) {
    String pattern = r'^\S\а-яА-ЯЁё+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return '';
    } else {
      return null;
    }
  }
}
