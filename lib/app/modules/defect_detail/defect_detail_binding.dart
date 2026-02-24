import 'package:get/get.dart';
import 'defect_detail_controller.dart';
import '../../data/repositories/defect_repository.dart';
import '../../data/providers/mock_api_service.dart';

class DefectDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MockApiService>(() => MockApiService());
    Get.lazyPut<DefectRepository>(
        () => DefectRepository(Get.find<MockApiService>()));
    Get.lazyPut<DefectDetailController>(
        () => DefectDetailController(Get.find<DefectRepository>()));
  }
}
