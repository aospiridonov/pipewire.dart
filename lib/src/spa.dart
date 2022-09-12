library spa;

import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;
import './spa/generated_bindings.dart' as spa;
import './pipewire/generated_bindings.dart' as pw;

class Data {
  ffi.Pointer<pw.pw_main_loop>? loop = null;
  ffi.Pointer<pw.pw_stream>? stream = null;
  spa.spa_video_format? format = null;
}

class Spa {
  late final spa.SPA _ffiLibBindings;

  Spa() {
    final path = 'libpipewire-0.3.so';
    final dynamicLibrary = ffi.DynamicLibrary.open(path);
    _ffiLibBindings = spa.SPA(dynamicLibrary);
  }
  void spa_pod_builder() {
    ffi.Pointer<spa.spa_pod_builder> builder = calloc<spa.spa_pod_builder>();
    ffi.Pointer<ffi.Void> buffer = calloc<ffi.Void>();
    builder.ref.data = buffer;
    builder.ref.size = 1024;
  }

  void test() {}
}

