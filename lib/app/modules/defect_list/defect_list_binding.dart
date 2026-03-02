import 'package:get/get.dart';
import 'defect_list_controller.dart';
import '../../data/repositories/defect_repository.dart';
import '../../data/repositories/main_body_repository.dart';

class DefectListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainBodyRepository>(() => MainBodyRepository());
    Get.lazyPut<DefectRepository>(
        () => DefectRepository(Get.find<MainBodyRepository>()));
    Get.lazyPut<DefectListController>(() => DefectListController());
  }
}
