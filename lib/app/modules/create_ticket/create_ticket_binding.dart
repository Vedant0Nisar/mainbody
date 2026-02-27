import 'package:get/get.dart';
import 'create_ticket_controller.dart';
import '../../data/repositories/defect_repository.dart';

class CreateTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateTicketController>(
      () => CreateTicketController(Get.find<DefectRepository>()),
    );
  }
}
