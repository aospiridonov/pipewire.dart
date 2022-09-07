library pipewire;

import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/src/utf8.dart';

import './pipewire/generated_bindings.dart' as pw;

class Pipewire {
  late final pw.Pipewire _ffiLibBindings;

  Pipewire() {
    //final path = '/usr/lib/pipewire-0.3/libpipewire.so';
    final path = 'libpipewire-0.3.so';
    final dynamicLibrary = ffi.DynamicLibrary.open(path);
    _ffiLibBindings = pw.Pipewire(dynamicLibrary);
    ffi.Pointer<ffi.Int> argc = calloc<ffi.Int>()..value = 0;
    ffi.Pointer<ffi.Pointer<ffi.Pointer<ffi.Char>>> argv =
        calloc<ffi.Pointer<ffi.Pointer<ffi.Char>>>();
    _ffiLibBindings.pw_init(argc, argv);
    final pointerVersion =
        _ffiLibBindings.pw_get_library_version().cast<Utf8>();
    print(pointerVersion.toDartString());

    calloc.free(argc);
    calloc.free(argv);
  }
}
