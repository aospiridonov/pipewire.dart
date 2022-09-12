import 'dart:ffi';

import 'package:pipewire/pipewire.dart';
import 'package:pipewire/src/spa/generated_bindings.dart';

void main(List<String> args) async {
  Pipewire pw = Pipewire();
  print('app name: ${pw.appName}');
  print('library version: ${pw.version}');
  // Spa spa = Spa();
  test();
}

void test() {
  Pipewire pw = Pipewire();
  //Spa spa = Spa();
  final data = Data();
  data.loop = pw.mainLoopNew();
  print('mainLoopNew');
  final props = pw.propertiesNew();
  print('propertiesNew');
  final loop = pw.mainLoopGetLoop(data.loop!);
  print('mainLoopGetLoop');
  final events = pw.streamEvents();
  print('streamEvents');
  pw.propertiesNewSample(
      loop, 'video-capture', props, events, Pointer.fromAddress(0));
}
