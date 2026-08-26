// import 'package:get/get.dart';

class BBKKController {
  static final BBKKController _instance = new BBKKController._internal();

  factory BBKKController() {
    return _instance;
  }

  BBKKController._internal();

  static BBKKController get() {
    return _instance;
  }
}
