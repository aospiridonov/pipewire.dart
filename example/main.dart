import 'package:pipewire/pipewire.dart';

void main(List<String> args) async {
  Pipewire pw = Pipewire();
  print('version: ${pw.version}');
}
