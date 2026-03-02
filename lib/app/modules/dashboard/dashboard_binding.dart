import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../data/repositories/main_body_repository.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Make sure MainBodyRepository is available, or use the ApiService if needed
    Get.lazyPut<MainBodyRepository>(() => MainBodyRepository());
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
  }
}
