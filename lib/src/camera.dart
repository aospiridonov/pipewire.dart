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
    _pw.propertiesNewSample(
      loop,
      'video-capture',
      _props,
      events,
      ffi.Pointer.fromAddress(0),
    );
    print('propertiesNewSample');
  }

  void onProcess() {}

  void onParamChanged() {}

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
