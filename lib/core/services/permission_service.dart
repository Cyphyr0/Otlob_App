import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }
}
