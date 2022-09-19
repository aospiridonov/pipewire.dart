import 'package:pipewire/src/pipewire/generated_bindings.dart' as pw;
import 'package:pipewire/src/spa/generated_bindings.dart' as spa;

import 'pipewire.dart';
import 'spa.dart';

import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;

class _Data {
  ffi.Pointer<pw.pw_main_loop>? loop = null;
  ffi.Pointer<pw.pw_stream>? stream = null;
  spa.spa_video_format? format = null;
}

class Camera {
  late final Pipewire _pw;
  late final Spa _spa;
  late final _Data _data;
  late final ffi.Pointer<pw.pw_properties> _props;

  Camera() {
    _pw = Pipewire();
    _spa = Spa();
    _data = _Data();
    print('app name: ${_pw.appName}');
    print('library version: ${_pw.version}');
  }

  static void onProcess(ffi.Pointer<ffi.Void> userdata) {
    print('onProcess');
  }

  void onProcess2(ffi.Pointer<ffi.Void> userdata) {
    print('onProcess2');
  }

  static void onParamChanged(
      ffi.Pointer<ffi.Void> userdata, int id, ffi.Pointer<pw.spa_pod> param) {
    print('onParamChanged');
  }

  void init() {
    _pw.init();
    _data.loop = _pw.mainLoopNew();
    _props = _pw.propertiesNewDict({
      pw.PW_KEY_MEDIA_TYPE: "Video",
      pw.PW_KEY_MEDIA_CATEGORY: "Capture",
      pw.PW_KEY_MEDIA_ROLE: "Camera",
    });
    final loop = _pw.mainLoopGetLoop(_data.loop!);
    final events = _pw.streamEvents();
    print('streamEvents');

    events.ref.param_changed =
        ffi.Pointer.fromFunction<NativeParamChanged>(onParamChanged);

    events.ref.process = ffi.Pointer.fromFunction<NativeProcess>(onProcess);

    //TODO: Closures and tear-offs are not supported because they can capture context.
    //events.ref.process = ffi.Pointer.fromFunction<NativeProcess>(onProcess2);

    _pw.propertiesNewSample(
      loop,
      'video-capture',
      _props,
      events,
      ffi.Pointer.fromAddress(0),
    );
    print('propertiesNewSample');
  }

  void _freeData() {
    if (_data.loop != null) {
      calloc.free(_data.loop!);
    }
    if (_data.stream != null) {
      calloc.free(_data.stream!);
    }
    /*
    if (_data.format != null) {
      calloc.free(_data.format);
    }
    */
  }

  void close() {
    _freeData();
    calloc.free(_props);
  }
}

typedef NativeParamChanged = ffi.Void Function(
    ffi.Pointer<ffi.Void>, ffi.Uint32, ffi.Pointer<pw.spa_pod>);
typedef NativeProcess = ffi.Void Function(ffi.Pointer<ffi.Void>);
typedef Process = void Function(ffi.Pointer<ffi.Void>);
