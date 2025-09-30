import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:otlob_app/features/auth/data/models/user_model.dart';
import 'package:otlob_app/features/home/data/models/restaurant_model.dart';

class IsarService {
  late Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [UserModelSchema, RestaurantModelSchema],
      directory: dir.path,
    );
  }

  Isar get instance => _isar;

  Future<void> close() async {
    await _isar.close();
  }
}
