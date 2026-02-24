import 'package:get/get.dart';
import 'defect_list_controller.dart';
import '../../data/repositories/defect_repository.dart';
import '../../data/providers/mock_api_service.dart';

class DefectListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MockApiService>(() => MockApiService());
    Get.lazyPut<DefectRepository>(
        () => DefectRepository(Get.find<MockApiService>()));
    Get.lazyPut<DefectListController>(
        () => DefectListController(Get.find<DefectRepository>()));
  }
}
