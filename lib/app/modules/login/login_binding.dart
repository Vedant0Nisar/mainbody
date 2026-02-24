import 'package:get/get.dart';
import 'login_controller.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/providers/mock_api_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MockApiService>(() => MockApiService());
    Get.lazyPut<AuthRepository>(
        () => AuthRepository(Get.find<MockApiService>()));
    Get.lazyPut<LoginController>(
        () => LoginController(Get.find<AuthRepository>()));
  }
}
