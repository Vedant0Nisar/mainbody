import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/main_body_repository.dart';
import '../../models/defect_model.dart';

class DefectDetailController extends GetxController {
  final MainBodyRepository _apiRepository = MainBodyRepository();

  late Rx<DefectModel> defect;
  final RxBool rxIsInit = false.obs;

  final RxBool isLoading = false.obs;
  final RxBool isActionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is DefectModel) {
      defect = Rx<DefectModel>(Get.arguments as DefectModel);
      rxIsInit.value = true;
      _loadFullDetails();
    } else {
      Get.back();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Defect details not found',
            snackPosition: SnackPosition.TOP);
      });
    }
  }

  Future<void> _loadFullDetails() async {
    isLoading.value = true;
    try {
      final data = await _apiRepository.getTicketDetails(defect.value.id);
      defect.value = DefectModel.fromJson(data);
    } catch (e) {
      // It's okay if it fails, we keep the basic model
    } finally {
      isLoading.value = false;
    }
  }
}
