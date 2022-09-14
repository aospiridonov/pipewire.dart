import 'dart:ffi';

import 'package:pipewire/src/camera.dart';

void main(List<String> args) async {
  final camera = Camera();
  camera.init();
  camera.onProcess();
}

void test() {}
