import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/defect_repository.dart';
import '../../models/defect_model.dart';
import '../../models/contractor_model.dart';
import '../../models/status_enum.dart';

class DefectDetailController extends GetxController {
  final DefectRepository _defectRepository;

  DefectDetailController(this._defectRepository);

  late Rx<DefectModel> defect;
  final RxBool rxIsInit = false.obs;

  final RxList<ContractorModel> contractors = <ContractorModel>[].obs;
  final Rx<ContractorModel?> selectedContractor = Rx<ContractorModel?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isActionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is DefectModel) {
      defect = Rx<DefectModel>(Get.arguments as DefectModel);
      rxIsInit.value = true;
      if (defect.value.status == TicketStatus.newTicket ||
          defect.value.status == TicketStatus.rework) {
        loadContractors();
      }
    } else {
      Get.back();
      // Wait for layout to finish before showing snackbar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Defect details not found');
      });
    }
  }

  Future<void> loadContractors() async {
    isLoading.value = true;
    try {
      final list = await _defectRepository.fetchContractors();
      contractors.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load contractors');
    } finally {
      isLoading.value = false;
    }
  }

  void assignContractor() async {
    if (selectedContractor.value == null) {
      Get.snackbar('Warning', 'Please select a contractor first');
      return;
    }

    isActionLoading.value = true;
    try {
      final success = await _defectRepository.assignContractor(
          defect.value.id, selectedContractor.value!);
      if (success) {
        defect.update((val) {
          if (val != null) {
            val.status = TicketStatus.assigned;
            val.contractor = selectedContractor.value;
          }
        });
        Get.snackbar('Success', 'Contractor assigned successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign contractor');
    } finally {
      isActionLoading.value = false;
    }
  }

  void approveRepair() async {
    isActionLoading.value = true;
    try {
      final success = await _defectRepository.approveRepair(defect.value.id);
      if (success) {
        defect.update((val) {
          if (val != null) {
            val.status = TicketStatus.closed;
          }
        });
        Get.snackbar('Success', 'Repair approved successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve repair');
    } finally {
      isActionLoading.value = false;
    }
  }

  void rejectRepair() async {
    isActionLoading.value = true;
    try {
      final success = await _defectRepository.rejectRepair(defect.value.id);
      if (success) {
        defect.update((val) {
          if (val != null) {
            val.status = TicketStatus.rework;
          }
        });
        loadContractors(); // Allow re-assigning if needed
        Get.snackbar('Success', 'Repair rejected. Status set to REWORK.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject repair');
    } finally {
      isActionLoading.value = false;
    }
  }
}
