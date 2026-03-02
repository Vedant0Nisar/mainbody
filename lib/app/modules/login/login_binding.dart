import 'package:get/get.dart';
import 'login_controller.dart';
import '../../data/repositories/auth_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthRepository>()),
    );
  }
}
