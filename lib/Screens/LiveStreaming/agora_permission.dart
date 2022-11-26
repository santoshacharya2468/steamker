import 'package:permission_handler/permission_handler.dart';

Future<void> handleCameraAndMic(callType) async {
  if (callType == 'Audio') {
    await Permission.microphone.request();
  } else if (callType == 'Video') {
    await Permission.camera.request();
    await Permission.microphone.request();
  }
}
