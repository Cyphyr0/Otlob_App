import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }
}
