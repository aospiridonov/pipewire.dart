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

  pw.spa_type_info get typeInfo {
    final value = _ffiLibBindings.pw_type_info().ref;
    final name = value.name;
    final lname = name.cast<Utf8>().toDartString();
    print('name: $lname');
    return value;
  }

  ffi.Pointer<pw.pw_main_loop> mainLoopNew() {
    //FIX: props
    ffi.Pointer<pw.spa_dict> props =
        ffi.Pointer.fromAddress(0).cast<pw.spa_dict>();
    return _ffiLibBindings.pw_main_loop_new(props);
  }

  ffi.Pointer<pw.pw_loop> mainLoopGetLoop(
      ffi.Pointer<pw.pw_main_loop> mainLoop) {
    return _ffiLibBindings.pw_main_loop_get_loop(mainLoop);
  }

  ffi.Pointer<pw.pw_properties> propertiesNew() {
    return _ffiLibBindings.pw_properties_new(''.toNativeUtf8().cast());
  }

  ffi.Pointer<pw.pw_properties> propertiesNewDict(
      [Map<String, String> dict = const <String, String>{}]) {
    ffi.Pointer<pw.spa_dict> spaDict = calloc<pw.spa_dict>();
    ffi.Pointer<pw.spa_dict_item> items = malloc.allocate<pw.spa_dict_item>(
        ffi.sizeOf<pw.spa_dict_item>() * dict.length);
    int i = 0;
    for (final entry in dict.entries) {
      final item = items.elementAt(i++);
      item.ref.key = entry.key.toNativeUtf8().cast<ffi.Char>();
      item.ref.value = entry.value.toNativeUtf8().cast<ffi.Char>();
    }
    spaDict.ref.items = items;
    spaDict.ref.n_items = dict.length;
    final result = _ffiLibBindings.pw_properties_new_dict(spaDict);
    malloc.free(items);
    malloc.free(spaDict);
    return result;
  }

  ffi.Pointer<pw.pw_stream_events> streamEvents() {
    return calloc<pw.pw_stream_events>();
  }

  ffi.Pointer<pw.pw_stream> propertiesNewSample(
      ffi.Pointer<pw.pw_loop> loop,
      String name,
      ffi.Pointer<pw.pw_properties> props,
      ffi.Pointer<pw.pw_stream_events> events,
      ffi.Pointer<ffi.Void> data) {
    return _ffiLibBindings.pw_stream_new_simple(
      loop,
      name.toNativeUtf8().cast(),
      props,
      events,
      data,
    );
  }
}
