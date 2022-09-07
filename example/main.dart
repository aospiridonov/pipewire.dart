import 'package:pipewire/pipewire.dart';

void main(List<String> args) async {
  Pipewire pw = Pipewire();
  print('app name: ${pw.appName}');
  print('program name: ${pw.programName}');
  print('user name: ${pw.userName}');
  print('host name: ${pw.hostName}');
  print('library version: ${pw.version}');
  print('client name: ${pw.clientName}');
}
