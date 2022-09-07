library pipewire;

import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;
import './pipewire/generated_bindings.dart' as pw;

class Pipewire {
  late final pw.Pipewire _ffiLibBindings;

  Pipewire() {
    final path = 'libpipewire-0.3.so';
    final dynamicLibrary = ffi.DynamicLibrary.open(path);
    _ffiLibBindings = pw.Pipewire(dynamicLibrary);
  }

  /// Initialize PipeWire with `aruments`. This function can be called multiple times.
  void init([List<String> aruments = const <String>[]]) {
    //FIX: add use aruments
    ffi.Pointer<ffi.Int> argc = calloc<ffi.Int>()..value = 0;
    ffi.Pointer<ffi.Pointer<ffi.Pointer<ffi.Char>>> argv =
        calloc<ffi.Pointer<ffi.Pointer<ffi.Char>>>();
    _ffiLibBindings.pw_init(argc, argv);
    calloc.free(argc);
    calloc.free(argv);
  }

  /// Deinitialize the PipeWire system and free up all resources allocated by `init`.
  void deinit() {
    _ffiLibBindings.pw_deinit();
  }

  String get appName {
    final appName = _ffiLibBindings.pw_get_application_name();
    if (appName.address != 0) {
      return appName.cast<Utf8>().toDartString();
    }
    return '';
  }

// Initializing PipeWire and loading SPA modules.

  /// Get the program name.
  String get programName =>
      _ffiLibBindings.pw_get_prgname().cast<Utf8>().toDartString();

  /// Get the user name
  String get userName =>
      _ffiLibBindings.pw_get_user_name().cast<Utf8>().toDartString();

  /// Get the host name.
  String get hostName =>
      _ffiLibBindings.pw_get_host_name().cast<Utf8>().toDartString();

  /// Get the client name.
  String get clientName =>
      _ffiLibBindings.pw_get_client_name().cast<Utf8>().toDartString();

  bool get inValgrind => _ffiLibBindings.pw_in_valgrind();

  bool checkOption(String option, String value) {
    return _ffiLibBindings.pw_check_option(
        option.toNativeUtf8().cast<ffi.Char>(),
        value.toNativeUtf8().cast<ffi.Char>());
  }

  /// Reverse the direction:
  /// 0 is input,
  /// 1 is output.
  int reverseDirection(int direction) {
    return _ffiLibBindings.pw_direction_reverse(direction);
  }

  int setDomain(String domain) {
    return _ffiLibBindings
        .pw_set_domain(domain.toNativeUtf8().cast<ffi.Char>());
  }

  String get domain =>
      _ffiLibBindings.pw_get_domain().cast<Utf8>().toDartString();

  // FIX: add pw_get_support, pw_load_spa_handle, pw_unload_spa_handle

  /// Get the currently running version.
  String get version =>
      _ffiLibBindings.pw_get_library_version().cast<Utf8>().toDartString();

  // FIX: pw_gettext, pw_ngettext

// FIX: cant visible pw_type_info
/*
  pw.spa_type_info get typeInfo {
    return pw.pw_type_info();
  }
  */
}
