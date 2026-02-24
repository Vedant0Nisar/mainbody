import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../data/repositories/defect_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/providers/mock_api_service.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MockApiService>(() => MockApiService());
    Get.lazyPut<DefectRepository>(
        () => DefectRepository(Get.find<MockApiService>()));
    Get.lazyPut<AuthRepository>(
        () => AuthRepository(Get.find<MockApiService>()));
    Get.lazyPut<DashboardController>(() => DashboardController(
          Get.find<DefectRepository>(),
          Get.find<AuthRepository>(),
        ));
  }
}
